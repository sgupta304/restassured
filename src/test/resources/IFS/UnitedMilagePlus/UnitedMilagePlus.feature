#############################################################################################
# This Feature file will test the the E2E functionality of the United Mileage Plus Feature
# The following IFS services are tested in this flow:
# GBP Legacy
# RUPP
#
# @Author Brian DeSimone
# @Date 10/31/2017
#############################################################################################
@UnitedMileagePlus @Regression
Feature: Validate United Mileage Plus

  Background: Set up the Flight Information
    Given I set the following attributes in memory:
      | airline_code  | UA    |
      | tail_number   | 0UALS |
      | flight_number | UA653 |

  @HealthCheck
  Scenario: Validate that RUPP can retrieve public key for a United Flight (Smoke Test)
    When I send a RUPP GET request to "/v1/united/public-key/tail-number/%{flight_number}"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate that RUPP retrieve public key returns the proper schema and data types
    When I send a RUPP GET request to "/v1/united/public-key/tail-number/%{flight_number}"
    Then the response status should be "200"
    And the response headers should be JSON
    And the JSON response should include the following:
      | ID        |
      | PublicKey |
    And the JSON response should have the following data types:
      | ID        | String |
      | PublicKey | String |

# FEATURE IS DEPRECIATED
#  @HealthCheck
#  Scenario: Validate that a successful United Mileage Plus user can login without X-Request-ID (auto gen header will be provided)
#    When I send a RUPP GET request to "/v1/united/public-key/tail-number/%{flight_number}"
#    Then the response status should be "200"
#    And I save the JSON at "ID" as "key_id"
#    Given I generate a United Mileage Plus Login object with key_id: "%{key_id}"
#    When I send an RUPP POST request to "/v1/united/mileage-plus" with the generated body
#    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate that a successful United Mileage Plus user can login with a specified X-Request-ID
    When I send a RUPP GET request to "/v1/united/public-key/tail-number/%{flight_number}"
    Then the response status should be "200"
    And I save the JSON at "ID" as "key_id"
    Given I generate a United Mileage Plus Login object with key_id: "%{key_id}"
    And I set custom headers:
      | X-Request-ID | random |
    When I send an RUPP POST request to "/v1/united/mileage-plus" with the generated body
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate that a successful United Mileage Plus user login has proper schema, headers, data types, and data
    When I send a RUPP GET request to "/v1/united/public-key/tail-number/%{flight_number}"
    Then the response status should be "200"
    And I save the JSON at "ID" as "key_id"
    Given I generate a United Mileage Plus Login object with key_id: "%{key_id}"
    And I set custom headers:
      | X-Request-ID | random |
    When I send an RUPP POST request to "/v1/united/mileage-plus" with the generated body
    Then the response status should be "200"
    And the response headers should be JSON
    And the JSON response should include the following:
      | active         |
      | userGuid       |
      | serviceErrorVO |
    And the JSON response should have the following data types:
      | active   | Boolean |
      | userGuid | String  |
    And the JSON response at "serviceErrorVO" should be null
    And the JSON response at "active" should be "true"

  @HealthCheck
  Scenario: Validate that a successful United Mileage Plus user is given active: true
    When I send a RUPP GET request to "/v1/united/public-key/tail-number/%{flight_number}"
    Then the response status should be "200"
    And I save the JSON at "ID" as "key_id"
    Given I generate a United Mileage Plus Login object with key_id: "%{key_id}"
    And I set custom headers:
      | X-Request-ID | random |
    When I send an RUPP POST request to "/v1/united/mileage-plus" with the generated body
    Then the response status should be "200"
    And the JSON response at "active" should be "true"

# DEPRECIATED FEATURE
#  @Positive
#  Scenario: Validate that empty string X-Request-ID header is accepted and random X-Request-ID is used
#    When I send a RUPP GET request to "/v1/united/public-key/tail-number/%{flight_number}"
#    Then the response status should be "200"
#    And I save the JSON at "ID" as "key_id"
#    Given I generate a United Mileage Plus Login object with key_id: "%{key_id}"
#    And I set custom headers:
#      | X-Request-ID |  |
#    When I send an RUPP POST request to "/v1/united/mileage-plus" with the generated body
#    Then the response status should be "200"
#    And the JSON response at "active" should be "true"

  @Positive
  Scenario: Validate that a user that has no subscription returns active: false

  @Negative
  Scenario: Validate that a user with an expired subscription returns proper error code and error message

  @Negative
  Scenario: Validate that an invalid JSON in login request returns proper error code and message
    When I send a RUPP POST request to "/v1/united/mileage-plus" with JSON body:
    """
    {INVALID}
    """
    Then the response status should be "400"
    And the JSON response should be the following:
      | statusCode      | 400          |
      | statusMsg       | Bad Request  |
      | errorCode       |              |
      | errorMsg        | Invalid JSON |
      | friendlyMessage |              |

  @Negative
  Scenario Outline: Validate that <attribute> in request payload return proper error code and error message when value: <value>
    When I send a RUPP GET request to "/v1/united/public-key/tail-number/%{flight_number}"
    Then the response status should be "200"
    And I save the JSON at "ID" as "key_id"
    Given I generate a United Mileage Plus Login object with key_id: "%{key_id}"
    And I modify the JSON at "<attribute>" to be "<value>"
    And I set custom headers:
      | X-Request-ID | random |
    When I send an RUPP POST request to "/v1/united/mileage-plus" with the generated body
    Then the response status should be "<statusCode>"
    And the JSON response should be the following:
      | statusCode | <statusCode> |
      | statusMsg  | <statusMsg>  |
      | errorCode  | <errorCode>  |
      | errorMsg   | <errorMsg>   |

    Examples: Missing or Empty Attributes
      | attribute            | value | statusCode | statusMsg    | errorCode               | errorMsg                                    |
      | username             | null  | 400        | Bad Request  | UA_BAD_REQUEST          | Username must be available                  |
      | password             | null  | 400        | Bad Request  | UA_BAD_REQUEST          | Password code must be available             |
      | airline_code         | null  | 400        | Bad Request  | UA_BAD_REQUEST          | Airline code must be available              |
      | aircraft_tail_number | null  | 400        | Bad Request  | UA_BAD_REQUEST          | Tail number must be available               |
      | flight_number        | null  | 400        | Bad Request  | UA_BAD_REQUEST          | Flight number must be available             |
      | key_id               | null  | 400        | Bad Request  | UA_BAD_REQUEST          | Key Id must be available                    |
      | username             |       | 401        | Unauthorized | UA_UNAUTHORIZED_REQUEST | Unable to complete login. Please try again. |
      | password             |       | 401        | Unauthorized | UA_UNAUTHORIZED_REQUEST | Unable to complete login. Please try again. |
      | airline_code         |       | 400        | Bad Request  | UA_BAD_REQUEST          | Airline code must be valid                  |
      | aircraft_tail_number |       | 400        | Bad Request  | UA_BAD_REQUEST          | Tail number must be valid                   |
      | flight_number        |       | 400        | Bad Request  | UA_BAD_REQUEST          | FlightNumber must be valid                  |
      | key_id               |       | 400        | Bad Request  | UA_BAD_REQUEST          | Key Id must be valid                        |

  @Negative
  Scenario: Validate that invalid username returns proper error code and message
    When I send a RUPP GET request to "/v1/united/public-key/tail-number/UA653"
    Then the response status should be "200"
    And I save the JSON at "ID" as "key_id"
    Given I generate a United Mileage Plus Login object with key_id: "%{key_id}"
    And I modify the JSON at "username" to be "INVALID"
    And I set custom headers:
      | X-Request-ID | random |
    When I send an RUPP POST request to "/v1/united/mileage-plus" with the generated body
    Then the response status should be "401"
    And the JSON response should be the following:
      | statusCode      | 401                                                                                            |
      | statusMsg       | Unauthorized                                                                                   |
      | errorCode       | UA_UNAUTHORIZED_REQUEST                                                                        |
      | errorMsg        | The MileagePlus number you entered does not match an account in our records. Please try again. |
      | friendlyMessage | We could not process your request. Please try again later                                      |

  @Negative
  Scenario: Validate that invalid password returns proper error code and message
    When I send a RUPP GET request to "/v1/united/public-key/tail-number/UA653"
    Then the response status should be "200"
    And I save the JSON at "ID" as "key_id"
    Given I generate a United Mileage Plus Login object with key_id: "%{key_id}"
    And I modify the JSON at "password" to be "INVALID"
    And I set custom headers:
      | X-Request-ID | random |
    When I send an RUPP POST request to "/v1/united/mileage-plus" with the generated body
    Then the response status should be "401"
    And the JSON response should be the following:
      | statusCode      | 401                                                                               |
      | statusMsg       | Unauthorized                                                                      |
      | errorCode       | UA_UNAUTHORIZED_REQUEST                                                           |
      | errorMsg        | The Password entered does not match the account in our records. Please try again. |
      | friendlyMessage | We could not process your request. Please try again later                         |

  @Negative
  Scenario: Validate that invalid key_id returns proper error code and message
    Given I generate a United Mileage Plus Login object with key_id: "99"
    And I set custom headers:
      | X-Request-ID | random |
    When I send an RUPP POST request to "/v1/united/mileage-plus" with the generated body
    Then the response status should be "401"
    And the JSON response should be the following:
      | statusCode      |  |
      | statusMsg       |  |
      | errorCode       |  |
      | errorMsg        |  |
      | friendlyMessage |  |

  @Negative
  Scenario: Validate proper error code and error message when missing X-Request-ID in request
    When I send a RUPP GET request to "/v1/united/public-key/tail-number/%{flight_number}"
    Then the response status should be "200"
    And I save the JSON at "ID" as "key_id"
    Given I generate a United Mileage Plus Login object with key_id: "%{key_id}"
    When I send an RUPP POST request to "/v1/united/mileage-plus" with the generated body
    Then the response status should be "401"
    And the JSON response should be the following:
      | statusCode      | 401                                                       |
      | statusMsg       | Unauthorized                                              |
      | errorCode       | UA_UNAUTHORIZED_REQUEST                                   |
      | errorMsg        | Missing X-Request-Id in the http header                   |
      | friendlyMessage | We could not process your request. Please try again later |