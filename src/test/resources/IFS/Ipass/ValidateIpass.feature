#############################################################################################
# This Feature file will test the the E2E functionality of iPass and retrieving the HTML tags
# The following IFS services are tested in this flow
#   - GBP
#   - GBP Edge
#
# @Author Brian DeSimone
# @Date 01/11/2018
#############################################################################################
@iPass @Regression
Feature: Validate iPass new architecture APIs

  @HealthCheck
  Scenario: Validate successful iPass smart client login returns proper response on captcha validate
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send a GBP Lite GET request to "/v2/gbp/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    Given I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    And I generate an iPass captcha validation object for uxdId: "%{uxdid}" with captcha result: "%{captcha_result}"
    And I set custom headers:
      | X-Client-ID  | a2rt2      |
      | X-Request-ID | 0U3OxJq01S |
    When I send a GBP Lite POST request to "/v2/roaming/captcha/validate/" with the generated body
    Then the response status should be "200"
    And the response headers should be JSON
    And the JSON response should include the following:
      | timestamp  |
      | trackingId |
      | statusCode |
      | statusMsg  |
      | nextURL    |
    And the JSON response should have the following data types:
      | timestamp  | Long    |
      | trackingId | String  |
      | statusCode | Integer |
      | statusMsg  | String  |
      | nextURL    | String  |
    And the JSON response should be the following:
      | trackingId | %{uxdid}                                                                       |
      | statusCode | 200                                                                            |
      | statusMsg  | SUCCESS                                                                        |
      | nextURL    | http://airborne.gogoinflight.com/abp/page/aaaActivate.do?gbpsessionid=%{uxdid} |

  @Positive
  Scenario: Validate successful iPass smart client activation returns proper retrieve user info from GBP
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ipAddress"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "macAddress"
    When I send a GBP Lite GET request to "/v2/gbp/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    Given I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    And I generate an iPass captcha validation object for uxdId: "%{uxdid}" with captcha result: "%{captcha_result}"
    And I set custom headers:
      | X-Client-ID  | a2rt2      |
      | X-Request-ID | 0U3OxJq01S |
    When I send a GBP Lite POST request to "/v2/roaming/captcha/validate/" with the generated body
    Then the response status should be "200"
    When I send an ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    When I retrieve user session info for uxdId: "%{uxdid}"
    Then the response status should be "200"
    And the XML response should be the following:
      | java.object.void[0]                | true                                                |
      | java.object.void[1].object.void[0] | %{ipAddress}                                        |
      | java.object.void[1].object.void[1] | airlab101234                                        |
      | java.object.void[1].object.void[2] | SMARTCLIENT_SUCCESS                                 |
      | java.object.void[1].object.void[3] | %{uxdid}                                            |
      | java.object.void[1].object.void[4] | IPASS:Roaming/0U3OxJq01S/bdb_airlab1@opstesting.com |
      | java.object.void[2]                | %{macAddress}                                       |

  @Negative
  Scenario: Validate GET iPass captcha returns proper error code and error message when invalid uxdid in request
    When I send a GBP Lite GET request to "/v2/gbp/captcha/math/INVALID"
    Then the response status should be "400"
    And the JSON response should be the following:
      | trackingId | INVALID              |
      | statusCode | 400                  |
      | statusMsg  | Bad Request          |
      | errorCode  | 1006                 |
      | errorMsg   | Invalid data entered |

  @Negative
  Scenario Outline: Validate iPass captcha validation request returns proper error code and error message when missing attribute: <attribute>
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send a GBP Lite GET request to "/v2/gbp/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate an iPass captcha validation object for uxdId: "%{uxdid}" with captcha result: "%{captchaResult}"
    And I modify the JSON at "<attribute>" to be "null"
    And I set custom headers:
      | X-Client-ID  | a2rt2      |
      | X-Request-ID | 0U3OxJq01S |
    When I send a GBP Lite POST request to "/v2/roaming/captcha/validate/" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | statusCode | 400            |
      | statusMsg  | Bad Request    |
      | errorCode  | <errorCode>    |
      | errorMsg   | <errorMessage> |

    Examples: Missing attributes, error codes, and error messages
      | attribute    | errorCode | errorMessage                                                 |
      | trackingId   | R-1056    | Invalid user session id                                      |
      | userName     | R-1059    | Invalid userName/password entered(value should not be empty) |
      | password     | R-1059    | Invalid userName/password entered(value should not be empty) |
      | captchaType  | R-1060    | captchaType/captchaValue is missing                          |
      | captchaValue | R-1060    | captchaType/captchaValue is missing                          |

  @Negative
  Scenario: Validate POST captcha request returns proper error code and error message when missing X-Client-ID header
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send a GBP Lite GET request to "/v2/gbp/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    Given I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    And I generate an iPass captcha validation object for uxdId: "%{uxdid}" with captcha result: "%{captcha_result}"
    And I set custom headers:
      | X-Request-ID | 0U3OxJq01S |
    When I send a GBP Lite POST request to "/v2/roaming/captcha/validate/" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | statusCode | 400                                 |
      | statusMsg  | Bad Request                         |
      | errorCode  | R-1058                              |
      | errorMsg   | Invalid X-Client-ID value in header |

  @Negative
  Scenario: Validate POST captcha request returns proper error code and error message when missing X-Request-ID header
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send a GBP Lite GET request to "/v2/gbp/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    Given I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    And I generate an iPass captcha validation object for uxdId: "%{uxdid}" with captcha result: "%{captcha_result}"
    And I set custom headers:
      | X-Client-ID | a2rt2 |
    When I send a GBP Lite POST request to "/v2/roaming/captcha/validate/" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | statusCode | 400                                  |
      | statusMsg  | Bad Request                          |
      | errorCode  | R-1062                               |
      | errorMsg   | Invalid X-Request-ID value in header |

  @Negative
  Scenario Outline: Validate iPass captcha validation request returns proper error code and error message when attribute: <attribute> has empty string as value
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send a GBP Lite GET request to "/v2/gbp/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate an iPass captcha validation object for uxdId: "%{uxdid}" with captcha result: "%{captchaResult}"
    And I modify the JSON at "<attribute>" to be ""
    And I set custom headers:
      | X-Client-ID  | a2rt2      |
      | X-Request-ID | 0U3OxJq01S |
    When I send a GBP Lite POST request to "/v2/roaming/captcha/validate/" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | statusCode | 400            |
      | statusMsg  | Bad Request    |
      | errorCode  | <errorCode>    |
      | errorMsg   | <errorMessage> |

    Examples: Missing attributes, error codes, and error messages
      | attribute    | errorCode | errorMessage                                                 |
      | trackingId   | R-1056    | Invalid user session id                                      |
      | userName     | R-1059    | Invalid userName/password entered(value should not be empty) |
      | password     | R-1059    | Invalid userName/password entered(value should not be empty) |
      | captchaType  | R-1060    | captchaType/captchaValue is missing                          |
      | captchaValue | R-1060    | captchaType/captchaValue is missing                          |

  @Negative
  Scenario: Validate POST captcha request returns proper error code and error message when invalid captcha value entered
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send a GBP Lite GET request to "/v2/gbp/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    Given I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    And I generate an iPass captcha validation object for uxdId: "%{uxdid}" with captcha result: "INVALID"
    And I set custom headers:
      | X-Client-ID  | a2rt2      |
      | X-Request-ID | 0U3OxJq01S |
    When I send a GBP Lite POST request to "/v2/roaming/captcha/validate/" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | statusCode | 400                           |
      | statusMsg  | Bad Request                   |
      | errorCode  | R-1057                        |
      | errorMsg   | Invalid CAPTCHA value entered |