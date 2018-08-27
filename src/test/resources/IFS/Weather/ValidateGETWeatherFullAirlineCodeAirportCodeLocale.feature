#############################################################################################
# This Feature file will test the the E2E functionality of Weather Controller.
# The following IFS services are tested in this flow
#
# @Author Eric Disrud
# @Date 05/09/2017
#############################################################################################

# The following scenarios will be tested:
#
#   1) Sunny day scenario validating that the response status code is 200 for a domestic airlineCode, airportCode, and locale. (Smoke Test)
#   2) Sunny day scenario validating that the response status code is 200 for a international airlineCode, airportCode, and locale. (Smoke Test)
#   7) Validate API returns proper headers on successful request for a domestic airportCode
#   8) Validate API returns proper headers on successful request for an international airportCode
#   9) Verify that an invalid airlineCode with a domestic airport passes with proper response
#  10) Verify that an invalid airlineCode with an international airport passes with proper response
#  11) Verify that an invalid airportCode returns the proper error code and response
#  12) Verify that an invalid locale with a domestic airport returns the proper error code and response
#  13) Verify that an invalid locale with an international airport returns the proper error code and response
#  14) Verify that an unknown airportCode returns the proper error code and response
#  15) Verify that an unknown locale with a domestic airport returns the proper error code and response
#  16) Verify that an unknown locale with an international airport returns the proper error code and response
@Weather @Regression
Feature: Validate Weather Controller

# smoke, schema, and schema type tests -----------------------------------------------------------
  @HealthCheck
  Scenario: 1) Sunny day scenario validating that the response status code is 200 for a domestic airlineCode, airportCode, and locale. (Smoke Test)
    When I send a CPAPI GET request to "/v1/weather/full/DAL/KORD/en_US"
    Then the response status should be "200"

  @HealthCheck
  Scenario: 2) Sunny day scenario validating that the response status code is 200 for a international airlineCode, airportCode, and locale. (Smoke Test)
    When I send a CPAPI GET request to "/v1/weather/full/GOL/BIRL/ja_JP"
    Then the response status should be "200"

  @HealthCheck
  Scenario: 7) Validate API returns proper headers on successful request for a domestic airportCode
    When I send a CPAPI GET request to "/v1/weather/full/DAL/KORD/en_US"
    Then the response status should be "200"
    And the response headers should be JSON

  @HealthCheck
  Scenario: 8) Validate API returns proper headers on successful request for an international airportCode
    When I send a CPAPI GET request to "/v1/weather/full/GOL/BIRL/ja_JP"
    Then the response status should be "200"
    And the response headers should be JSON

  @Negative
  Scenario: 9) Verify that an invalid airlineCode with a domestic airport passes with proper response
    When I send a CPAPI GET request to "/v1/weather/full/INVALID/KORD/en_US"
    Then the response status should be "200"

  @Negative
  Scenario: 10) Verify that an invalid airlineCode with an international airport passes with proper response
    When I send a CPAPI GET request to "/v1/weather/full/INVALID/BIRL/ja_JP"
    Then the response status should be "200"

  @Negative
  Scenario: 11) Verify that an invalid airportCode returns the proper error code and response
    When I send a CPAPI GET request to "/v1/weather/full/DAL/INVALID/en_US"
    Then the response status should be "400"
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | string |
      | statusMsg  | string |
      | errorCode  | string |
      | errorMsg   | string |
    And the JSON response should be the following:
      | statusCode | 400                    |
      | statusMsg  | Bad Request            |
      | errorCode  | 1112                   |
      | errorMsg   | airportCode is invalid |
    And the response headers should be JSON

  @Negative
  Scenario: 12) Verify that an invalid locale with a domestic airport returns the proper error code and response
    When I send a CPAPI GET request to "/v1/weather/full/DAL/KORD/INVALID"
    Then the response status should be "400"
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | string |
      | statusMsg  | string |
      | errorCode  | string |
      | errorMsg   | string |
    And the JSON response should be the following:
      | statusCode | 400                        |
      | statusMsg  | Bad Request                |
      | errorCode  | 1111                       |
      | errorMsg   | locale/language is invalid |
    And the response headers should be JSON

  @Negative
  Scenario: 13) Verify that an invalid locale with an international airport returns the proper error code and response
    When I send a CPAPI GET request to "/v1/weather/full/DAL/BIRL/INVALID"
    Then the response status should be "400"
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | string |
      | statusMsg  | string |
      | errorCode  | string |
      | errorMsg   | string |
    And the JSON response should be the following:
      | statusCode | 400                        |
      | statusMsg  | Bad Request                |
      | errorCode  | 1111                       |
      | errorMsg   | locale/language is invalid |
    And the response headers should be JSON

  @Negative
  Scenario: 14) Verify that an unknown airportCode returns the proper error code and response
    When I send a CPAPI GET request to "/v1/weather/full/DAL/XXXX/en_US"
    Then the response status should be "400"
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | string |
      | statusMsg  | string |
      | errorCode  | string |
      | errorMsg   | string |
    And the JSON response should be the following:
      | statusCode | 400                        |
      | statusMsg  | Bad Request                |
      | errorCode  | 1001                       |
      | errorMsg   | invalid/missing input data |
    And the response headers should be JSON

  @Negative
  Scenario: 15) Verify that an unknown locale with a domestic airport returns the proper error code and response
    When I send a CPAPI GET request to "/v1/weather/full/DAL/KORD/xx_XX"
    Then the response status should be "400"
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | string |
      | statusMsg  | string |
      | errorCode  | string |
      | errorMsg   | string |
    And the JSON response should be the following:
      | statusCode | 400                       |
      | statusMsg  | Bad Request               |
      | errorCode  | 1110                      |
      | errorMsg   | Weather response is empty |
    And the response headers should be JSON

  @Negative
  Scenario: 16) Verify that an unknown locale with an international airport returns the proper error code and response
    When I send a CPAPI GET request to "/v1/weather/full/DAL/BIRL/xx_XX"
    Then the response status should be "400"
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | string |
      | statusMsg  | string |
      | errorCode  | string |
      | errorMsg   | string |
    And the JSON response should be the following:
      | statusCode | 400                       |
      | statusMsg  | Bad Request               |
      | errorCode  | 1110                      |
      | errorMsg   | Weather response is empty |
    And the response headers should be JSON
