#############################################################################################
# This Feature file will test the the E2E functionality of TMO 1 and the GBP cache
#
# @Author Brian DeSimone
# @Date 02/01/2018
# Refactored 05/02/2018
#############################################################################################
@Cache
Feature: Validate TMO EAP with cache

  Background: Setup the flight information for TMO EAP enabled flight
    Given I set the following attributes in memory:
      | airline_code  | DAL    |
      | tail_number   | 0QEDEV |
      | flight_number | QE123  |

  # This test requires the tester to verify the results by looking at the logs
  Scenario Outline: Validate same user hits splash 2 times, second time should use the cache
    When I send a GBP POST request to generate a 1HR EAP session
    Then the response status should be "200"
    And I wait for 1 seconds
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "macAddress"
    And the JSON response should include "eapUserInfo.eap_user_name"
    And the JSON response at "eapUserInfo.service_code" should be "1001"
    When I simulate a splash page load for host: "http://<host>" with uxdId: "%{uxdid}"
    And I wait for 2 seconds
    When I simulate a splash page load for host: "http://<host>" with uxdId: "%{uxdid}"
    # Validate with logs
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
    When I send a GBP Lite POST request to "/v2/eap/captcha/validate/" with the generated body    Then the response status should be "200"
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    Given I generate a device state object to clear mac address: "%{mac_address}"
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear-expire" with the generated body
    Then the response status should be "200"

    Examples: Host to test
      | host               |
      | 172.21.20.154:8080 |
      | 172.21.135.70:8080 |

  # This test requires the tester to verify the results by looking at the logs
  Scenario: Validate same user hits splash 1 time then hit splash on second load balancer and uses cache
    When I send a GBP POST request to generate a 1HR EAP session
    Then the response status should be "200"
    And I wait for 1 seconds
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "macAddress"
    And the JSON response should include "eapUserInfo.eap_user_name"
    And the JSON response at "eapUserInfo.service_code" should be "1001"
    When I simulate a splash page load for host: "http://172.21.20.154:8080" with uxdId: "%{uxdid}"
    And I wait for 2 seconds
    When I simulate a splash page load for host: "http://172.21.135.70:8080" with uxdId: "%{uxdid}"
    # Validate with logs
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