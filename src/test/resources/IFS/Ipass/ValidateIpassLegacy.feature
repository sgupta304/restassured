########################################################################################################################
# This Feature file will test the the E2E functionality of iPass and retrieving the HTML tags in legacy iPass scenarios.
# The following IFS services are tested in this flow
#   - GBP
#   - GBP Edge
#
# @Author Brian DeSimone
# @Date 01/11/2018
########################################################################################################################
@iPassLegacy @Regression
Feature: Validate iPass legacy APIs

  @HealthCheck
  Scenario: Validate successful request returns proper response codes (smoke test)
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send a GBP Lite POST request to "/smartClientLogin.do?jsessionid=%{uxdid}&button=Login&UserName=test1@ipass.gogo.testing&Password=Z7i3AC7i&OriginatingServer=http://sniff.gslb.i-pass.com&FNAME=0"
    Then the response status should be "200"
    When I send a GBP Lite GET request to "/v2/gbp/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send a GBP Lite POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    When I send a GBP Lite GET request to "/captchaController.do?jsessionid=%{uxdid}&rand=1"
    Then the response status should be "200"
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    When I send a GBP Lite GET request to "/captchaController.do?jsessionid=%{uxdid}&rand=1"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate a successful request returns the proper data in the WISP tags for each stage in the flow
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ipAddress"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "macAddress"
    When I send a GBP Lite POST request to "/smartClientLogin.do?jsessionid=%{uxdid}&button=Login&UserName=test1@ipass.gogo.testing&Password=Z7i3AC7i&OriginatingServer=http://sniff.gslb.i-pass.com&FNAME=0"
    Then the response status should be "200"
    And I parse the last response to get "WISPAccessGatewayParam" and store it at "WISPAccessGateway"
    And the XML stored at "%{WISPAccessGateway}" should be the following:
      | MessageType     | 120                                                                                  |
      | ResponseCode    | 201                                                                                  |
      | ReplyMessage    | Authentication Pending                                                               |
      | LoginResultsURL | http://airborne.gogoinflight.com/gbp/captchaController.do;jsessionid=%{uxdid}?rand=1 |
      | LogoffURL       | http://airborne.gogoinflight.com/abp/page/aaaDeactivate.do?gbpsessionid=%{uxdid}     |
      | RedirectionURL  | http://airborne.gogoinflight.com/gbp/captchaController.do;jsessionid=%{uxdid}?rand=1 |
    And I parse the last response to get "CaptchaReply" and store it at "CaptchaReply"
    And the XML stored at "%{CaptchaReply}" should be the following:
      | MessageType  | 120             |
      | ResponseCode | 201             |
      | ReplyMessage | Captcha Pending |
      | Retry        | 0               |
    And I parse the last response to get "WISPROAMGatewayParam" and store it at "WISPROAMGatewayParam"
    And the XML stored at "%{WISPROAMGatewayParam}" should be the following:
      | CAPTCHAVIURL     | http://airborne.gogoinflight.com/gbp/v2/gbp/captcha/math/%{uxdid}  |
      | CAPTCHASURL      | http://airborne.gogoinflight.com/gbp/v2/gbp/captcha/image/%{uxdid} |
      | CAPTCHASubmitURL | http://airborne.gogoinflight.com/gbp/v2/gbp/captcha/validate       |
    When I send a GBP Lite GET request to "/v2/gbp/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send a GBP Lite POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    When I send a GBP Lite GET request to "/captchaController.do?jsessionid=%{uxdid}&rand=1"
    Then the response status should be "200"
    And I parse the last response to get "WISPAccessGatewayParam" and store it at "WISPAccessGateway"
    And the XML stored at "%{WISPAccessGateway}" should be the following:
      | MessageType    | 140                                                                                  |
      | ResponseCode   | 201                                                                                  |
      | ReplyMessage   | Authentication Pending                                                               |
      | Delay          | 4                                                                                    |
      | LogoffURL      | http://airborne.gogoinflight.com/abp/page/aaaDeactivate.do?gbpsessionid=%{uxdid}     |
      | RedirectionURL | http://airborne.gogoinflight.com/gbp/captchacontroller.do;jsessionid=%{uxdid}?rand=1 |
    And I parse the last response to get "CaptchaPollReply" and store it at "CaptchaPollReply"
    And the XML stored at "%{CaptchaPollReply}" should be the following:
      | MessageType  | 140                    |
      | ResponseCode | 201                    |
      | ReplyMessage | Authentication Pending |
      | Retry        | 0                      |
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    When I send a GBP Lite GET request to "/captchaController.do?jsessionid=%{uxdid}&rand=1"
    Then the response status should be "200"
    And I parse the last response to get "WISPAccessGatewayParam" and store it at "WISPAccessGateway"
    And the XML stored at "%{WISPAccessGateway}" should be the following:
      | MessageType    | 140                                                                                  |
      | ResponseCode   | 50                                                                                   |
      | ReplyMessage   | Authentication Successful                                                            |
      | Delay          | 4                                                                                    |
      | LogoffURL      | http://airborne.gogoinflight.com/abp/page/aaaDeactivate.do?gbpsessionid=%{uxdid}     |
      | RedirectionURL | http://airborne.gogoinflight.com/gbp/captchacontroller.do;jsessionid=%{uxdid}?rand=1 |
    And I parse the last response to get "CaptchaPollReply" and store it at "CaptchaPollReply"
    And the XML stored at "%{CaptchaPollReply}" should be the following:
      | MessageType  | 140                |
      | ResponseCode | 50                 |
      | ReplyMessage | Captcha Successful |
      | Retry        | 0                  |
    When I retrieve user session info for uxdId: "%{uxdid}"
    Then the response status should be "200"
    And the XML response should be the following:
      | java.object.void[0]                | true                     |
      | java.object.void[1].object.void[0] | %{ipAddress}             |
      | java.object.void[1].object.void[1] | Z7i3AC7i                 |
      | java.object.void[1].object.void[2] | SMARTCLIENT_SUCCESS      |
      | java.object.void[1].object.void[3] | %{uxdid}                 |
      | java.object.void[1].object.void[4] | test1@ipass.gogo.testing |
      | java.object.void[2]                | %{macAddress}            |

  @Negative
  Scenario: Validate proper error code and error message in the WISP tags response when invalid username/password
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send a GBP Lite POST request to "/smartClientLogin.do?jsessionid=%{uxdid}&button=Login&UserName=test1@ipass.gogo.testing&Password=INVALID&OriginatingServer=http://sniff.gslb.i-pass.com&FNAME=0"
    Then the response status should be "200"
    When I send a GBP Lite GET request to "/v2/gbp/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send a GBP Lite POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    When I send a GBP Lite GET request to "/captchaController.do?jsessionid=%{uxdid}&rand=1"
    Then the response status should be "200"
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    When I send a GBP Lite GET request to "/captchaController.do?jsessionid=%{uxdid}&rand=1"
    Then the response status should be "200"

  @Negative
  Scenario: Validate proper error code and error message in the WISP tags response data when trying to get captcha without logging in


  @Negative
  Scenario: Validate proper error code and error message in the WISP tags response when invalid captcha validation value before activation