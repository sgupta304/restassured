#############################################################################################
# This Feature file will test the the E2E functionality of TMO 1 Hour Session with EAP.
# The following IFS services are tested in this flow:
# GBP
# IFSGateway
# APIDecorator
# IFSUTILS
#
# @Author Brian DeSimone
# @Date 06/28/2017
# Refactored 04/27/2018
#############################################################################################
@TMO @EAP @Regression
Feature: Validate TMO EAP 1 Hour Session

  Background: Setup the flight information for TMO EAP enabled flight
    Given I set the following attributes in memory:
      | airline_code  | DAL   |
      | tail_number   | 0DAL2 |
      | flight_number | DL123 |

  @HealthCheck
  Scenario: Validate successful TMO EAP 1 hour session (Smoke Test)
    When I send a GBP POST request to generate a 1HR EAP session
    Then the response status should be "200"
    And I wait for 1 seconds
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "mac_address"
    And the JSON response should include "eapUserInfo.eap_user_name"
    And the JSON response at "eapUserInfo.service_code" should be "1001"
    When I send a GBP Lite GET request to "/v2/eap/secure-token/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a TMO object for EAP with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/eap/captcha/validate/" with the generated body
    Then the response status should be "200"
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    Given I generate a device state object to clear mac address: "%{mac_address}"
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear-expire" with the generated body
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate successful TMO EAP response contains documented schema
    When I send a GBP POST request to generate a 1HR EAP session
    Then the response status should be "200"
    And I wait for 1 seconds
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "mac_address"
    And the JSON response should include "eapUserInfo.eap_user_name"
    And the JSON response at "eapUserInfo.service_code" should be "1001"
    When I send a GBP Lite GET request to "/v2/eap/secure-token/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a TMO object for EAP with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/eap/captcha/validate/" with the generated body
    Then the response status should be "200"
    And the JSON response should include the following:
      | timestamp   |
      | statusCode  |
      | statusMsg   |
      | trackingId  |
      | featureName |
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    Given I generate a device state object to clear mac address: "%{mac_address}"
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear-expire" with the generated body
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate successful TMO EAP response matches the expected data types
    When I send a GBP POST request to generate a 1HR EAP session
    Then the response status should be "200"
    And I wait for 1 seconds
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "mac_address"
    And the JSON response should include "eapUserInfo.eap_user_name"
    And the JSON response at "eapUserInfo.service_code" should be "1001"
    When I send a GBP Lite GET request to "/v2/eap/secure-token/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a TMO object for EAP with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/eap/captcha/validate/" with the generated body
    Then the response status should be "200"
    And the JSON response should have the following data types:
      | timestamp   | Long    |
      | statusCode  | Integer |
      | statusMsg   | String  |
      | trackingId  | String  |
      | featureName | String  |
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    Given I generate a device state object to clear mac address: "%{mac_address}"
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear-expire" with the generated body
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate successful TMO EAP response contains the proper data and the session user info is correct
    When I send a GBP POST request to generate a 1HR EAP session
    Then the response status should be "200"
    And I wait for 1 seconds
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "mac_address"
    And the JSON response should include "eapUserInfo.eap_user_name"
    And the JSON response at "eapUserInfo.service_code" should be "1001"
    When I send a GBP Lite GET request to "/v2/eap/secure-token/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a TMO object for EAP with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/eap/captcha/validate/" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | statusCode  | 200      |
      | statusMsg   | SUCCESS  |
      | trackingId  | %{uxdid} |
      | featureName | TMO-1HR  |
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    Given I generate a device state object to clear mac address: "%{mac_address}"
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear-expire" with the generated body
    Then the response status should be "200"

  @Positive
  Scenario: Validate all EAP info is stored in cloud DAO after activation of EAP user
    When I send a GBP POST request to generate a 1HR EAP session
    Then the response status should be "200"
    And I wait for 1 seconds
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ip_address"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "mac_address"
    And the JSON response should include "eapUserInfo.eap_user_name"
    And the JSON response at "eapUserInfo.service_code" should be "1001"
    When I send a GBP Lite GET request to "/v2/eap/secure-token/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a TMO object for EAP with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/eap/captcha/validate/" with the generated body
    Then the response status should be "200"
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    When I retrieve user session info for uxdId: "%{uxdid}"
    Then the response status should be "200"
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response should be the following:
      | userType                    | BYPASS_EAP_TMO_1HR |
      | uxdId                       | %{uxdid}           |
      | simpleDeviceInfo.macAddress | %{mac_address}     |
      | simpleDeviceInfo.clientIp   | %{ip_address}      |
      | activated                   | true               |
      | loggedInStatus              | true               |
      | airlineCode                 | DAL                |
      | eap_availability            | false              |
    Given I generate a device state object to clear mac address: "%{mac_address}"
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear-expire" with the generated body
    Then the response status should be "200"

  @Positive
  Scenario: Validate EAP TMO bypass is activated successfully and displays the proper user info in RetrieveUserInfo
    When I send a GBP POST request to generate a 1HR EAP session
    Then the response status should be "200"
    And I wait for 1 seconds
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ip_address"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "mac_address"
    And the JSON response should include "eapUserInfo.eap_user_name"
    And the JSON response at "eapUserInfo.service_code" should be "1001"
    When I send a GBP Lite GET request to "/v2/eap/secure-token/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a TMO object for EAP with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/eap/captcha/validate/" with the generated body
    Then the response status should be "200"
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    When I retrieve user session info for uxdId: "%{uxdid}"
    Then the response status should be "200"
    And the XML response should be the following:
      | java.object.void[0]                | true                           |
      | java.object.void[1].object.void[0] | true                           |
      | java.object.void[1].object.void[1] | %{eap_user_name}               |
      | java.object.void[1].object.void[2] | 1001                           |
      | java.object.void[2].object.void[0] | %{ip_address}                  |
      | java.object.void[2].object.void[1] | bypass                         |
      | java.object.void[2].object.void[2] | BYPASS_EAP_TMO_1HR             |
      | java.object.void[2].object.void[3] | %{uxdid}                       |
      | java.object.void[2].object.void[4] | BYPASS_01H/TMO1HR/EAP/%{uxdid} |
      | java.object.void[3]                | %{mac_address}                 |
    Given I generate a device state object to clear mac address: "%{mac_address}"
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear-expire" with the generated body
    Then the response status should be "200"

  @Negative
  Scenario: Validate EAP TMO returns proper error messages when missing X-Request-ID secure-token
    When I send a GBP POST request to generate a 1HR EAP session
    Then the response status should be "200"
    And I wait for 1 seconds
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response should include "eapUserInfo.eap_user_name"
    And the JSON response at "eapUserInfo.service_code" should be "1001"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a TMO object for EAP with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    When I send a GBP Lite POST request to "/v2/eap/captcha/validate/" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | errorCode  | EAP-1024                                  |
      | errorMsg   | EAP TMO :: Missing security token header. |
      | statusCode | 400                                       |
      | statusMsg  | Bad Request                               |

  @Negative
  Scenario: Validate EAP TMO returns proper error messages when invalid secure-token
    When I send a GBP POST request to generate a 1HR EAP session
    Then the response status should be "200"
    And I wait for 1 seconds
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response should include "eapUserInfo.eap_user_name"
    And the JSON response at "eapUserInfo.service_code" should be "1001"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a TMO object for EAP with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | INVALID |
    When I send a GBP Lite POST request to "/v2/eap/captcha/validate/" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | errorCode  | EAP-1030                                             |
      | errorMsg   | EAP TMO :: Invalid or expired security token header. |
      | statusCode | 400                                                  |
      | statusMsg  | Bad Request                                          |

  @Negative
  Scenario: Validate EAP TMO returns proper error messages when no captcha value
    When I send a GBP POST request to generate a 1HR EAP session
    Then the response status should be "200"
    And I wait for 1 seconds
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response should include "eapUserInfo.eap_user_name"
    And the JSON response at "eapUserInfo.service_code" should be "1001"
    When I send a GBP Lite GET request to "/v2/eap/secure-token/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token"
    Given I generate a TMO object for EAP with uxdid: "%{uxdid}" and captcha: "1"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/eap/captcha/validate/" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | errorCode  | EAP-1027                  |
      | errorMsg   | Captcha validation failed |
      | statusCode | 400                       |
      | statusMsg  | Bad Request               |

  @Negative
  Scenario: Validate EAP TMO returns proper error message when invalid uxdid
    When I send a GBP POST request to generate a 1HR EAP session
    Then the response status should be "200"
    And I wait for 1 seconds
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response should include "eapUserInfo.eap_user_name"
    And the JSON response at "eapUserInfo.service_code" should be "1001"
    When I send a GBP Lite GET request to "/v2/eap/secure-token/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a TMO object for EAP with uxdid: "INVALID" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/eap/captcha/validate/" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | errorCode  | EAP-1027                  |
      | errorMsg   | Captcha validation failed |
      | statusCode | 400                       |
      | statusMsg  | Bad Request               |

  @Negative
  Scenario: Validate a non-EAP uxdid cannot get a valid session and the proper error message is displayed
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I wait for 1 seconds
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response should not include "eapUserInfo.eap_user_name"
    And the JSON response should not include "eapUserInfo.service_code"
    When I send a GBP Lite GET request to "/v2/eap/secure-token/%{uxdid}"
    Then the response status should be "200"
    And the response should be "{"token":null}"