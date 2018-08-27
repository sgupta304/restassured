#############################################################################################
# This Feature file will test the the E2E functionality of TMO 1 Hour Session.
# The following IFS services are tested in this flow
#
# @Author Brian DeSimone
# @Date 05/03/2017
# Refactored: 04/26/2018
#############################################################################################
@TMO @Regression
Feature: Validate TMO 1 Hour Session

  Background: Setup the flight information for TMO enabled flight
    Given I set the following attributes in memory:
      | airline_code  | DAL   |
      | tail_number   | 0DAL2 |
      | flight_number | DL123 |

  @HealthCheck
  Scenario: Validate successful TMO 1 Hour Session (Smoke Test)
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
    Given I generate a TMO object for 1HR with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "200"
    Given I generate a device state object to clear a 1HR session
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
    Given I generate a TMO object for 1HR with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
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
    Given I generate a device state object to clear a 1HR session
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
    Given I generate a TMO object for 1HR with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
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
    Given I generate a device state object to clear a 1HR session
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear" with the generated body
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate that a session is allowed when using a valid TMO number and zip code
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
    Given I generate a TMO object for 1HR with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | statusCode   | 200      |
      | statusMsg    | SUCCESS  |
      | trackingId   | %{uxdid} |
      | allowSession | true     |
    Given I generate a device state object to clear a 1HR session
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear" with the generated body
    Then the response status should be "200"

# REMOVING THIS TEST FOR NOW BECAUSE WE NO LONGER VALIDATE ANYTHING WITH ZIP CODES IN PROD
#  @HealthCheck
#  Scenario: Validate that a session is allowed when using a valid TMO number and any zip code when the number has no zip
#    When I send a GBP POST request to generate a MOBILE session
#    Then the response status should be "200"
#    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
#    Then the response status should be "200"
#    And the JSON response at "uxdId" should be "%{uxdid}"
#    When I send a GBP Lite GET request to "/v2/tmoSecureToken/%{uxdid}"
#    Then the response status should be "200"
#    And I save the JSON at "token" as "token"
#    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
#    Then the response status should be "200"
#    And I save the JSON at "captchaValue" as "captchaValue"
#    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
#    Given I generate a TMO object for NOZIP with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
#    And I set custom headers:
#      | X-Request-ID | %{token} |
#    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
#    Then the response status should be "200"
#    And the JSON response should be the following:
#      | statusCode   | 200      |
#      | statusMsg    | SUCCESS  |
#      | trackingId   | %{uxdid} |
#      | allowSession | true     |
#    Given I generate a device state object to clear a NOZIP session
#    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear" with the generated body
#    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate that a session is allowed when passing a valid TMO number and null zip (legacy functionality)
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
    Given I generate a TMO object for LEGACY with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | statusCode   | 200      |
      | statusMsg    | SUCCESS  |
      | trackingId   | %{uxdid} |
      | allowSession | true     |
    Given I generate a device state object to clear a 1HR session
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear" with the generated body
    Then the response status should be "200"


  @Negative
  Scenario: Validate that proper error code and message is returned when invalid TMO number
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
    Given I generate a TMO object for 1HR with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I modify the JSON at "phoneNumber" to be "0000000000"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | statusCode | 400                                  |
      | statusMsg  | Bad Request                          |
      | errorCode  | 18005                                |
      | errorMsg   | Please enter a valid T-Mobile number |

  @Negative
  Scenario: Validate that proper error code and message is returned when restricted TMO number
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
    Given I generate a TMO object for 1HR with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I modify the JSON at "phoneNumber" to be "9158310164"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | statusCode | 400                         |
      | statusMsg  | Bad Request                 |
      | errorCode  | TMO-2001                    |
      | errorMsg   | Restricted T-Mobile account |

# REMOVING THIS TEST FOR NOW BECAUSE WE NO LONGER VALIDATE ANYTHING WITH ZIP CODES IN PROD
#  @Negative
#  Scenario: Validate that proper error code and message is returned when valid TMO number and invalid zip code
#    When I send a GBP POST request to generate a MOBILE session
#    Then the response status should be "200"
#    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
#    Then the response status should be "200"
#    And the JSON response at "uxdId" should be "%{uxdid}"
#    When I send a GBP Lite GET request to "/v2/tmoSecureToken/%{uxdid}"
#    Then the response status should be "200"
#    And I save the JSON at "token" as "token"
#    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
#    Then the response status should be "200"
#    And I save the JSON at "captchaValue" as "captchaValue"
#    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
#    Given I generate a TMO object for 1HR with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
#    And I modify the JSON at "zipCode" to be "00000"
#    And I set custom headers:
#      | X-Request-ID | %{token} |
#    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
#    Then the response status should be "400"
#    And the JSON response should be the following:
#      | statusCode | 400              |
#      | statusMsg  | Bad Request      |
#      | errorCode  | 18004            |
#      | errorMsg   | Invalid Zip Code |

  @Negative
  Scenario: Validate that proper error code and error message are returned when missing X-Request-Id header
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a TMO object for 1HR with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | statusCode | 400                            |
      | statusMsg  | Bad Request                    |
      | errorCode  | 1024                           |
      | errorMsg   | Missing security token header. |

  @Negative
  Scenario: Validate that proper error code and error message are returned when invalid X-Request-Id header
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a TMO object for 1HR with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | INVALID |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | statusCode | 400                                       |
      | statusMsg  | Bad Request                               |
      | errorCode  | 1030                                      |
      | errorMsg   | Invalid or expired security token header. |

  @Negative
  Scenario: Validate that proper error code and error message are returned when using a non-mobile device (Not a TMO phone)
    When I send a GBP POST request to generate a LAPTOP session
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
    Given I generate a TMO object for 1HR with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | statusCode | 400                                        |
      | statusMsg  | Bad Request                                |
      | errorCode  | 1022                                       |
      | errorMsg   | Product is only allowed in mobile devices. |

  @Negative
  Scenario: Validate that proper error code and message is returned when invalid request body
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send a GBP Lite GET request to "/v2/tmoSecureToken/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token"
    Given I generate a JSON body from the following:
    """
      {INVALID}
    """
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | statusCode | 400                  |
      | statusMsg  | Bad Request          |
      | errorCode  | 1005                 |
      | errorMsg   | Invalid JSON content |

  @Negative
  Scenario Outline: Validate that proper error code and message is returned when missing or empty <attribute> in post body
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
    Given I generate a TMO object for 1HR with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I modify the JSON at "<attribute>" to be "<newValue>"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | statusCode | 400         |
      | statusMsg  | <statusMsg> |
      | errorCode  | <errorCode> |
      | errorMsg   | <errorMsg>  |

    Examples: Attribute: <attribute> was set to <newValue>
      | attribute    | newValue | statusMsg   | errorCode | errorMsg                                                |
      | captchaType  |          | Bad Request | 1002      | Invalid CAPTCHA type entered                            |
      | captchaValue |          | Bad Request | 1002      | Invalid CAPTCHA value entered                           |
      | phoneNumber  |          | Bad Request | 1002      | phoneNumber is invalid                                  |
      | uxdId        |          | Bad Request | 1002      | Flight Info is missing in tokenInfo for uxdId { null }. |
      | captchaType  | null     | Bad Request | 1002      | captcha type is missing                                 |
      | captchaValue | null     | Bad Request | 1002      | captcha value is missing                                |
      | phoneNumber  | null     | Bad Request | 1023      | Phone number is missing.                                |
      | uxdId        | null     | Bad Request | 1002      | UxdId cannot be null.                                   |

  @Positive
  Scenario: Validate that a single device can be used on separate flights with separate sessions
    Given I set the following attributes in memory:
      | mac_address | 00:00:00:00:00 |
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
    Given I generate a TMO object for 1HR with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | statusCode   | 200      |
      | statusMsg    | SUCCESS  |
      | trackingId   | %{uxdid} |
      | allowSession | true     |
    Given I set the following attributes in memory:
      | airline_code  | ASA            |
      | tail_number   | 0ASA2          |
      | flight_number | AS123          |
      | mac_address   | 00:00:00:00:00 |
    When I send a GBP POST request to generate a MOBILE session
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send a GBP Lite GET request to "/v2/tmoSecureToken/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token2"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue2"
    And I validate captcha stored at "captchaValue2" and store the result at "captchaResult2"
    Given I generate a TMO object for 1HR with uxdid: "%{uxdid}" and captcha: "%{captchaResult2}"
    And I modify the JSON at "phoneNumber" to be "8472095203"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | statusCode   | 200      |
      | statusMsg    | SUCCESS  |
      | trackingId   | %{uxdid} |
      | allowSession | true     |
    Given I generate a device state object to clear a 1HR session
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear" with the generated body
    Then the response status should be "200"
    Given I generate an object with key: "user" value: "8472095203"
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear" with the generated body
    Then the response status should be "200"

  @Positive
  Scenario: Validate that a single device can be used on separate flights with the same session
    Given I set the following attributes in memory:
      | mac_address | 00:00:00:00:00 |
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
    Given I generate a TMO object for 1HR with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | statusCode   | 200      |
      | statusMsg    | SUCCESS  |
      | trackingId   | %{uxdid} |
      | allowSession | true     |
    Given I set the following attributes in memory:
      | mac_address | 00:00:00:00:00 |
    When I send a GBP POST request to generate a MOBILE session
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send a GBP Lite GET request to "/v2/tmoSecureToken/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token2"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue2"
    And I validate captcha stored at "captchaValue2" and store the result at "captchaResult2"
    Given I generate a TMO object for 1HR with uxdid: "%{uxdid}" and captcha: "%{captchaResult2}"
    And I set custom headers:
      | X-Request-ID | %{token2} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | statusCode   | 200      |
      | statusMsg    | SUCCESS  |
      | trackingId   | %{uxdid} |
      | allowSession | true     |
    Given I generate a device state object to clear a 1HR session
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear" with the generated body
    Then the response status should be "200"

  @Negative
  Scenario: Validate error code and message when a single session is used on the same flight with different devices
    Given I set the following attributes in memory:
      | airline_code  | ASA   |
      | tail_number   | 0ASA2 |
      | flight_number | AS123 |
    When I send a GBP POST request to generate a MOBILE session
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
    Given I generate a TMO object for 1HR with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | statusCode   | 200      |
      | statusMsg    | SUCCESS  |
      | trackingId   | %{uxdid} |
      | allowSession | true     |
    Given I set the following attributes in memory:
      | airline_code  | ASA            |
      | tail_number   | 0ASA2          |
      | flight_number | AS123          |
      | mac_address   | AB:CD:00:00:00 |
    When I send a GBP POST request to generate a MOBILE session
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send a GBP Lite GET request to "/v2/tmoSecureToken/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token2"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue2"
    And I validate captcha stored at "captchaValue2" and store the result at "captchaResult2"
    Given I generate a TMO object for 1HR with uxdid: "%{uxdid}" and captcha: "%{captchaResult2}"
    And I set custom headers:
      | X-Request-ID | %{token2} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "409"
    And the JSON response should be the following:
      | statusCode | 409                                                           |
      | statusMsg  | Data already exists                                           |
      | errorCode  | 1014                                                          |
      | errorMsg   | The number entered has been recently used for this promotion. |
    Given I generate a device state object to clear a 1HR session
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear" with the generated body
    Then the response status should be "200"

  @Negative
  Scenario: Validate error code and message when a single session is used on separate flights with separate devices
    When I send a GBP POST request to generate a MOBILE session
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
    Given I generate a TMO object for 1HR with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | statusCode   | 200      |
      | statusMsg    | SUCCESS  |
      | trackingId   | %{uxdid} |
      | allowSession | true     |
    Given I set the following attributes in memory:
      | airline_code  | ASA            |
      | tail_number   | 0ASA2          |
      | flight_number | AS123          |
      | mac_address   | 00:00:00:00:00 |
    When I send a GBP POST request to generate a MOBILE session
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send a GBP Lite GET request to "/v2/tmoSecureToken/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "token" as "token2"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue2"
    And I validate captcha stored at "captchaValue2" and store the result at "captchaResult2"
    Given I generate a TMO object for 1HR with uxdid: "%{uxdid}" and captcha: "%{captchaResult2}"
    And I set custom headers:
      | X-Request-ID | %{token2} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "409"
    And the JSON response should be the following:
      | statusCode | 409                                                           |
      | statusMsg  | Data already exists                                           |
      | errorCode  | 1014                                                          |
      | errorMsg   | The number entered has been recently used for this promotion. |
    Given I generate a device state object to clear a 1HR session
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear" with the generated body
    Then the response status should be "200"

  @Positive
  Scenario: Validate that a non one-plus tmo session does not return feature name in the response
    When I send a GBP POST request to generate a MOBILE session
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
    Given I generate a TMO object for 1HR with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
    And I set custom headers:
      | X-Request-ID | %{token} |
    When I send a GBP Lite POST request to "/v2/tmoValidate" with the generated body
    Then the response status should be "200"
    And the JSON response should not include "featureName"
    Given I generate a device state object to clear a 1HR session
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear" with the generated body
    Then the response status should be "200"

  @Positive @PROD
  Scenario: Validate that a TMO promotion is activated successfully and displays the proper user info in RetrieveUserInfo
    When I send a GBP POST request to generate a MOBILE session
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
    Given I generate a TMO object for 1HR with uxdid: "%{uxdid}" and captcha: "%{captchaResult}"
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
    Given I generate a device state object to clear a 1HR session
    When I send an IFSUTILS DELETE request to "/v1/devicestate/clear" with the generated body
    Then the response status should be "200"