#############################################################################################
# This Feature file will test the the E2E functionality of message bypass for VIR.
# The following IFS services are tested in this flow:
# GPBlite
#
# @Author Eric Disrud
# @Date 07/20/2017
# Refactored 05/02/2018
# By Brian DeSimone
#############################################################################################
@MessageBypass @Regression
Feature: Validate Message Bypass - VIR

  Background: Setup the flight information message bypass enabled airlines
    Given I set the following attributes in memory:
      | airline_code  | VIR   |
      | tail_number   | 0VIR2 |
      | flight_number | DL123 |

  @HealthCheck
  Scenario: Validate a successful Message Bypass request to VIR
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "MOBILE"
    When I send a GBP Lite GET request to "/v2/secureToken/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token"
    When I send a GBP Lite GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    And I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    Given I set custom headers:
      | X-Request-Id | %{token} |
    And I generate a message bypass object with uxdid: "%{uxdid}" and captcha: "%{captcha_result}"
    When I send a GBP Lite POST request to "/bypassmsgvalidate" with the generated body
    Then the response status should be "200"
    And the response headers should be JSON
    And the JSON response should include the following:
      | timestamp  |
      | statusCode |
      | statusMsg  |
    And the JSON response should have the following data types:
      | timestamp  | long   |
      | statusCode | string |
      | statusMsg  | string |
    And the JSON response should be the following:
      | statusCode | 200     |
      | statusMsg  | success |

  @Negative
  Scenario: Validate proper error code and error message when invalid JSON in the request payload
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "MOBILE"
    When I send a GBP Lite GET request to "/v2/secureToken/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token"
    Given I set custom headers:
      | X-Request-Id | %{token} |
    When I send a GBP Lite POST request to "/bypassmsgvalidate" with JSON body:
    """
      {invalid:invalid}
    """
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should be the following:
      | statusCode | 400                  |
      | statusMsg  | Bad Request          |
      | errorCode  | 1005                 |
      | errorMsg   | Invalid JSON content |

  @Negative
  Scenario Outline: Validate proper error code and error message when attribute <attribute> is value "<value>" in the request payload
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "MOBILE"
    When I send a GBP Lite GET request to "/v2/secureToken/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token"
    When I send a GBP Lite GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    And I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    Given I set custom headers:
      | X-Request-Id | %{token} |
    And I generate a message bypass object with uxdid: "%{uxdid}" and captcha: "%{captcha_result}"
    And I modify the JSON at "<attribute>" to be "<value>"
    When I send a GBP Lite POST request to "/bypassmsgvalidate" with the generated body
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should be the following:
      | statusCode | 400            |
      | statusMsg  | Bad Request    |
      | errorCode  | <errorCode>    |
      | errorMsg   | <errorMessage> |

    Examples: Missing or Invalid Attributes and Respective Error Codes and Messages
      | attribute    | value   | errorCode | errorMessage                                 |
      | uxdId        | null    | 1002      | UxdId cannot be null.                        |
      | uxdId        |         | 1002      | uxdId is empty                               |
      | uxdId        | INVALID | 1002      | Token info is missing for uxdId { INVALID }. |
      | captchaType  | null    | 1002      | captcha type is missing                      |
      | captchaType  |         | 1002      | Invalid CAPTCHA value entered                |
      | captchaType  | CI      | 1002      | Invalid CAPTCHA value entered                |
      | captchaType  | INVALID | 1002      | Invalid CAPTCHA value entered                |
      | captchaValue | null    | 1002      | captcha value is missing                     |
      | captchaValue |         | 1002      | Invalid CAPTCHA value entered                |
      | captchaValue | INVALID | 1002      | Invalid CAPTCHA value entered                |

  @Negative
  Scenario: Validate a Message Bypass to VIR with a missing security token
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "MOBILE"
    When I send a GBP Lite GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    And I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    Given I generate a message bypass object with uxdid: "%{uxdid}" and captcha: "%{captcha_result}"
    When I send a GBP Lite POST request to "/bypassmsgvalidate" with the generated body
    And the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | errorCode  |
      | errorMsg   |
      | statusCode |
      | statusMsg  |
    And the JSON response should have the following data types:
      | errorCode  | string  |
      | errorMsg   | string  |
      | statusCode | integer |
      | statusMsg  | string  |
    And the JSON response should be the following:
      | errorCode  | 1024                           |
      | errorMsg   | Missing security token header. |
      | statusCode | 400                            |
      | statusMsg  | Bad Request                    |

  @Negative
  Scenario: Validate a Message Bypass to VIR with an invalid security token
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "MOBILE"
    When I send a GBP Lite GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    And I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    Given I set custom headers:
      | X-Request-Id | INVALID |
    And I generate a message bypass object with uxdid: "%{uxdid}" and captcha: "%{captcha_result}"
    When I send a GBP Lite POST request to "/bypassmsgvalidate" with the generated body
    And the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | errorCode  |
      | errorMsg   |
      | statusCode |
      | statusMsg  |
    And the JSON response should have the following data types:
      | errorCode  | string  |
      | errorMsg   | string  |
      | statusCode | integer |
      | statusMsg  | string  |
    And the JSON response should be the following:
      | errorCode  | 1024                           |
      | errorMsg   | Missing security token header. |
      | statusCode | 400                            |
      | statusMsg  | Bad Request                    |

  @Negative
  Scenario: Validate a Message Bypass does not work on non MOBILE devices
    When I send a GBP POST request to generate a LAPTOP session
    Then the response status should be "200"
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "LAPTOP"
    When I send a GBP Lite GET request to "/v2/secureToken/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token"
    When I send a GBP Lite GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    And I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    Given I set custom headers:
      | X-Request-Id | %{token} |
    And I generate a message bypass object with uxdid: "%{uxdid}" and captcha: "%{captcha_result}"
    When I send a GBP Lite POST request to "/bypassmsgvalidate" with the generated body
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | errorCode  |
      | errorMsg   |
      | statusCode |
      | statusMsg  |
    And the JSON response should have the following data types:
      | errorCode  | string  |
      | errorMsg   | string  |
      | statusCode | integer |
      | statusMsg  | string  |
    And the JSON response should be the following:
      | errorCode  | 1022                                       |
      | errorMsg   | Product is only allowed in mobile devices. |
      | statusCode | 400                                        |
      | statusMsg  | Bad Request                                |

  @Negative
  Scenario: Validate a Message Bypass to a non enabled airline
    Given I set the following attributes in memory:
      | airline_code  | BAW   |
      | tail_number   | 0BAW2 |
      | flight_number | BW123 |
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    When I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "MOBILE"
    When I send a GBP Lite GET request to "/v2/secureToken/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token"
    When I send a GBP Lite GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    And I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    Given I set custom headers:
      | X-Request-Id | %{token} |
    And I generate a message bypass object with uxdid: "%{uxdid}" and captcha: "%{captcha_result}"
    When I send a GBP Lite POST request to "/bypassmsgvalidate" with the generated body
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | errorCode  |
      | errorMsg   |
      | statusCode |
      | statusMsg  |
    And the JSON response should have the following data types:
      | errorCode  | string  |
      | errorMsg   | string  |
      | statusCode | integer |
      | statusMsg  | string  |
    And the JSON response should be the following:
      | errorCode  | MB-1031                                  |
      | errorMsg   | Product is not enabled for this airline. |
      | statusCode | 400                                      |
      | statusMsg  | Bad Request                              |