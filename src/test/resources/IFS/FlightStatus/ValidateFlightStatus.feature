#############################################################################################
# This Feature file will test the the E2E functionality of Flight Status
# The following IFS services are tested in this flow
#
# @Author Eric Disrud
# @Date 05/30/2017
# Refactored 05/02/2018
# By Brian DeSimone
#############################################################################################
@FlightStatus @Regression
Feature: Validate Flight Status V2 for airport info

  @HealthCheck
  Scenario: Validate that the response status code is 200 for a domestic airportCode. (Smoke Test)
    Given I send a CPAPI GET request to "/v2/airportinfo/KORD"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate that the response status code is 200 for an international airportCode. (Smoke Test)
    Given I send a CPAPI GET request to "/v2/airportinfo/EGLL"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate API returns documented schema on successful request for a domestic airportCode.
    Given I send a CPAPI GET request to "/v2/airportinfo/KORD"
    Then the response status should be "200"
    And the response headers should be JSON
    And the JSON response should include the following:
      | Status        |
      | backgroundSrc |
      | Region        |
      | ImageCode     |
      | airportCode   |
      | CityName      |
      | locType       |
    And the JSON response should have the following data types:
      | Status        | string |
      | backgroundSrc | string |
      | Region        | string |
      | ImageCode     | string |
      | airportCode   | string |
      | CityName      | string |
      | locType       | string |

  @HealthCheck
  Scenario: Validate API returns documented schema on successful request for an international airportCode.
    Given I send a CPAPI GET request to "/v2/airportinfo/EGLL"
    Then the response status should be "200"
    And the response headers should be JSON
    And the JSON response should include the following:
      | Status        |
      | backgroundSrc |
      | Region        |
      | ImageCode     |
      | airportCode   |
      | CityName      |
      | locType       |
    And the JSON response should have the following data types:
      | Status        | string |
      | backgroundSrc | string |
      | Region        | string |
      | ImageCode     | string |
      | airportCode   | string |
      | CityName      | string |
      | locType       | string |

  @Negative
  Scenario: Verify that an invalid airportCode returns the proper error code and response.
    Given I send a CPAPI GET request to "/v2/airportinfo/INVALID"
    Then the response status should be "400"
    And the response headers should be JSON
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
      | statusCode | 400                                                   |
      | statusMsg  | Bad Request                                           |
      | errorCode  | 1001                                                  |
      | errorMsg   | Airport Code must be a valid 3 or 4 Char Airport code |

  @Negative
  Scenario: Verify that an unknown airportCode returns the proper error code and response.
    Given I send a CPAPI GET request to "/v2/airportinfo/XXXX"
    Then the response status should be "404"
    And the response headers should be JSON
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
      | statusCode | 404                           |
      | statusMsg  | No Data Found                 |
      | errorCode  | 1000                          |
      | errorMsg   | Airport Information not found |