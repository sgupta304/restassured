#############################################################################################
# This Feature file will test the the E2E functionality of TMO 1 Hour Session plus messaging.
# The following IFS services are tested in this flow
#
# @Author Brian DeSimone
# @Date 05/03/2017
# Refactored: 04/26/2018
#############################################################################################
@TMO @Regression
Feature: Validate TMO 1 Hour Session plus 8 hour messaging pass

  Background: Setup the flight information for TMO enabled flight
    Given I set the following attributes in memory:
      | airline_code  | DAL   |
      | tail_number   | 0DAL2 |
      | flight_number | DL123 |
  
  @HealthCheck
  Scenario: Validate successful TMO 1 Hour Session plus messaging (Smoke Test)
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send a GBP Lite GET request to "/v2/tmoSecureToken/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a TMO object for LUP with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "200"
    Given I generate a device state object to clear a LUP session
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear" with the generated body
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate successful response contains proper schema
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send a GBP Lite GET request to "/v2/tmoSecureToken/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a TMO object for LUP with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "200"
    And the JSON response should include the following:
      | timestamp    |
      | statusCode   |
      | statusMsg    |
      | trackingId   |
      | allowSession |
    Given I generate a device state object to clear a LUP session
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear" with the generated body
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate successful response contains proper data types
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send a GBP Lite GET request to "/v2/tmoSecureToken/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a TMO object for LUP with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "200"
    And the JSON response should have the following data types:
      | timestamp    | Long    |
      | statusCode   | String  |
      | statusMsg    | String  |
      | trackingId   | String  |
      | allowSession | Boolean |
    Given I generate a device state object to clear a LUP session
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear" with the generated body
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate that a 1 hour + messaging session is allowed when using a valid TMO number and zip code
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send a GBP Lite GET request to "/v2/tmoSecureToken/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a TMO object for LUP with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | statusCode   | 200      |
      | statusMsg    | SUCCESS  |
      | trackingId   | %{uxdid} |
      | allowSession | true     |
    Given I generate a device state object to clear a LUP session
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear" with the generated body
    Then the response status should be "200"

  @Positive
  Scenario: Validate that a TMO promotion is activated successfully and displays the proper user info in RetrieveUserInfo
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ipAddress"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "macAddress"
    When I send a GBP Lite GET request to "/v2/tmoSecureToken/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a TMO object for LUP with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | statusCode   | 200      |
      | statusMsg    | SUCCESS  |
      | trackingId   | %{uxdid} |
      | allowSession | true     |
    When I send an ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    When I retrieve user session info for uxdId: "%{uxdid}"
    Then the response status should be "200"
    And the XML response should be the following:
      | java.object.void[0]                | true                       |
      | java.object.void[1].object.void[0] | %{ipAddress}               |
      | java.object.void[1].object.void[1] | bypass                     |
      | java.object.void[1].object.void[2] | BYPASS_TMO_1HR             |
      | java.object.void[1].object.void[3] | %{uxdid}                   |
      | java.object.void[1].object.void[4] | BYPASS_01H/TMO1HR/%{uxdid} |
      | java.object.void[2]                | %{macAddress}              |
    Given I generate a device state object to clear a LUP session
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear" with the generated body
    Then the response status should be "200"