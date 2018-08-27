##############################################################################################
# This Feature file will test the the E2E functionality of Delta Flight Status.
# The following IFS services are tested in this flow
#
# @Author Eric Disrud
# @Date 05/09/2017
# Refactored 05/02/2018
# By Brian DeSimone
#
# The following scenarios will be tested:
#   1) Sunny day scenario validating that the response status code is 200. (Smoke Test)
#   2) Validate response matches documented json schema
#   3) Validate response data types match expected
#   4) Validate response contains proper headers
#   5) Verify that an invalid flightNum returns the proper error code and response
#   6) Verify that an invalid departureDate returns the proper error code and response
#   7) Verify that an invalid originCode returns the proper error code and response
#   8) Verify that an invalid destCode returns the proper error code and response
#   9) Verify that an unknown flightNum returns the proper error code and response
#  10) Verify that a departureDate in the past returns the proper error code and response
#  11) Verify that an unknown originCode returns the proper error code and response
#  12) Verify that an unknown destCode returns the proper error code and response
##############################################################################################
@DeltaFlightStatus @Regression
Feature: Validate Delta Flight Status APIs

  Background: Setup the flight information for TMO enabled flight
    Given I set the following attributes in memory:
      | airline_code | DAL |

  @HealthCheck
  Scenario: Sunny day scenario validating that the response status code is 200. (Smoke Test)
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=%{airline_code}&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].departure.airport.icao" as "departure_airport"
    And I save the JSON at "[0].arrival.airport.icao" as "arrival_airport"
    And I retrieve the departure time
    Given I format the departure time
    When I send a CPAPI GET request to "/v1/delta/flightStatus/%{flight_number}/%{date}/%{departure_airport}/%{arrival_airport}"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate response matches documented json schema
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=%{airline_code}&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].departure.airport.icao" as "departure_airport"
    And I save the JSON at "[0].arrival.airport.icao" as "arrival_airport"
    And I retrieve the departure time
    Given I format the departure time
    When I send a CPAPI GET request to "/v1/delta/flightStatus/%{flight_number}/%{date}/%{departure_airport}/%{arrival_airport}"
    Then the response status should be "200"
    And the JSON response should include the following:
      | flightStatusResponse                                          |
      | flightStatusResponse.status                                   |
      | flightStatusResponse.flightStatusByLegResponse                |
      | flightStatusResponse.flightStatusByLegResponse.flightStatusTO |

  @HealthCheck
  Scenario: Validate response data types match expected
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=%{airline_code}&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].departure.airport.icao" as "departure_airport"
    And I save the JSON at "[0].arrival.airport.icao" as "arrival_airport"
    And I retrieve the departure time
    Given I format the departure time
    When I send a CPAPI GET request to "/v1/delta/flightStatus/%{flight_number}/%{date}/%{departure_airport}/%{arrival_airport}"
    Then the response status should be "200"
    And the JSON response should have the following data types:
      | flightStatusResponse                                          | hashmap |
      | flightStatusResponse.status                                   | string  |
      | flightStatusResponse.flightStatusByLegResponse                | hashmap |
      | flightStatusResponse.flightStatusByLegResponse.flightStatusTO | hashmap |

  @HealthCheck
  Scenario: Validate response contains proper headers
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=%{airline_code}&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].departure.airport.icao" as "departure_airport"
    And I save the JSON at "[0].arrival.airport.icao" as "arrival_airport"
    And I retrieve the departure time
    Given I format the departure time
    When I send a CPAPI GET request to "/v1/delta/flightStatus/%{flight_number}/%{date}/%{departure_airport}/%{arrival_airport}"
    Then the response status should be "200"
    And the response headers should be JSON

  @Negative
  Scenario: Verify that an invalid flightNum returns the proper error code and response
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=%{airline_code}&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].departure.airport.icao" as "departure_airport"
    And I save the JSON at "[0].arrival.airport.icao" as "arrival_airport"
    And I retrieve the departure time
    Given I format the departure time
    When I send a CPAPI GET request to "/v1/delta/flightStatus/INVALID/%{date}/%{departure_airport}/%{arrival_airport}"
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
      | statusCode | 400                                                          |
      | statusMsg  | Bad Request                                                  |
      | errorCode  | 2000                                                         |
      | errorMsg   | Delta does not have flights scheduled that match the request |
    And the response headers should be JSON

  @Negative
  Scenario: Verify that an invalid departureDate returns the proper error code and response
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=%{airline_code}&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].departure.airport.icao" as "departure_airport"
    And I save the JSON at "[0].arrival.airport.icao" as "arrival_airport"
    When I send a CPAPI GET request to "/v1/delta/flightStatus/%{flight_number}/INVALID/%{departure_airport}/%{arrival_airport}"
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
      | statusCode | 400                                                        |
      | statusMsg  | Bad Request                                                |
      | errorCode  | 1005                                                       |
      | errorMsg   | Departure date must be in yyyy-MM-dd format -eg 2014-07-14 |
    And the response headers should be JSON

  @Negative
  Scenario: Verify that an invalid originCode returns the proper error code and response
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=%{airline_code}&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].arrival.airport.icao" as "arrival_airport"
    And I retrieve the departure time
    Given I format the departure time
    When I send a CPAPI GET request to "/v1/delta/flightStatus/%{flight_number}/%{date}/INVALID/%{arrival_airport}"
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
      | statusCode | 400                                                   |
      | statusMsg  | Bad Request                                           |
      | errorCode  | 1003                                                  |
      | errorMsg   | Airport Code must be a valid 3 or 4 Char Airport code |
    And the response headers should be JSON

  @Negative
  Scenario: Verify that an invalid destCode returns the proper error code and response
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=%{airline_code}&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].departure.airport.icao" as "departure_airport"
    And I retrieve the departure time
    Given I format the departure time
    When I send a CPAPI GET request to "/v1/delta/flightStatus/%{flight_number}/%{date}/%{departure_airport}/INVALID"
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
      | statusCode | 400                                                   |
      | statusMsg  | Bad Request                                           |
      | errorCode  | 1004                                                  |
      | errorMsg   | Airport Code must be a valid 3 or 4 Char Airport code |
    And the response headers should be JSON

  @Negative
  Scenario: Verify that an unknown flightNum returns the proper error code and response
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=%{airline_code}&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].departure.airport.icao" as "departure_airport"
    And I save the JSON at "[0].arrival.airport.icao" as "arrival_airport"
    And I retrieve the departure time
    Given I format the departure time
    When I send a CPAPI GET request to "/v1/delta/flightStatus/000/%{date}/%{departure_airport}/%{arrival_airport}"
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
      | statusCode | 400                                                          |
      | statusMsg  | Bad Request                                                  |
      | errorCode  | 2000                                                         |
      | errorMsg   | Delta does not have flights scheduled that match the request |
    And the response headers should be JSON

  @Negative
  Scenario: Verify that a departureDate in the past returns the proper error code and response
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=%{airline_code}&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].departure.airport.icao" as "departure_airport"
    And I save the JSON at "[0].arrival.airport.icao" as "arrival_airport"
    When I send a CPAPI GET request to "/v1/delta/flightStatus/%{flight_number}/1936-12-12/%{departure_airport}/%{arrival_airport}"
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
      | statusCode | 400                                                          |
      | statusMsg  | Bad Request                                                  |
      | errorCode  | 2000                                                         |
      | errorMsg   | Delta does not have flights scheduled that match the request |
    And the response headers should be JSON

  @Negative
  Scenario: Verify that an unknown originCode returns the proper error code and response
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=%{airline_code}&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].arrival.airport.icao" as "arrival_airport"
    And I retrieve the departure time
    Given I format the departure time
    When I send a CPAPI GET request to "/v1/delta/flightStatus/%{flight_number}/%{date}/XXXX/%{arrival_airport}"
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
      | statusCode | 400                                                          |
      | statusMsg  | Bad Request                                                  |
      | errorCode  | 2000                                                         |
      | errorMsg   | Delta does not have flights scheduled that match the request |
    And the response headers should be JSON

  @Negative
  Scenario: Verify that an unknown destCode returns the proper error code and response
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=%{airline_code}&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].departure.airport.icao" as "departure_airport"
    And I retrieve the departure time
    Given I format the departure time
    When I send a CPAPI GET request to "/v1/delta/flightStatus/%{flight_number}/%{date}/%{departure_airport}/XXXX"
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
      | statusCode | 400                                                          |
      | statusMsg  | Bad Request                                                  |
      | errorCode  | 2000                                                         |
      | errorMsg   | Delta does not have flights scheduled that match the request |
    And the response headers should be JSON