#############################################################################################
# This Feature file will test the the E2E functionality of Flight Status By Leg
# The following IFS services are tested in this flow
#
# @Author Eric Disrud
# @Date 05/30/2017
# Refactored 05/02/2018
# By Brian DeSimone
#############################################################################################
@DeltaFlightStatus @Regression
Feature: Validate Delta Flight Status By Leg APIs

  @HealthCheck
  Scenario: Validate successful response. (smoke test)
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=DAL&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].departure.airport.icao" as "departure_airport"
    And I save the JSON at "[0].arrival.airport.icao" as "arrival_airport"
    And I retrieve the departure time
    Given I format the departure time
    When I send a CPAPI GET request to "/v1/flightStatusByLeg?flightNum=%{flight_number}&depDate=%{date}&originCode=%{departure_airport}&destCode=%{arrival_airport}"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Verify success schema
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=DAL&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].departure.airport.icao" as "departure_airport"
    And I save the JSON at "[0].arrival.airport.icao" as "arrival_airport"
    And I retrieve the departure time
    Given I format the departure time
    When I send a CPAPI GET request to "/v1/flightStatusByLeg?flightNum=%{flight_number}&depDate=%{date}&originCode=%{departure_airport}&destCode=%{arrival_airport}"
    Then the response status should be "200"
    And the fsCallback JSON response should include the following:
      | flightStatusResponse        |
      | flightStatusResponse.status |

  @HealthCheck
  Scenario: Validate API returns proper headers on successful request
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=DAL&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].departure.airport.icao" as "departure_airport"
    And I save the JSON at "[0].arrival.airport.icao" as "arrival_airport"
    And I retrieve the departure time
    Given I format the departure time
    When I send a CPAPI GET request to "/v1/flightStatusByLeg?flightNum=%{flight_number}&depDate=%{date}&originCode=%{departure_airport}&destCode=%{arrival_airport}"
    Then the response status should be "200"
    And the response headers should be JSON

  @Negative
  Scenario: Verify that an invalid flightNum returns the proper error code and response
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=DAL&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].departure.airport.icao" as "departure_airport"
    And I save the JSON at "[0].arrival.airport.icao" as "arrival_airport"
    And I retrieve the departure time
    Given I format the departure time
    When I send a CPAPI GET request to "/v1/flightStatusByLeg?flightNum=INVALID&depDate=%{date}&originCode=%{departure_airport}&destCode=%{arrival_airport}"
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
      | statusCode | 400                                                          |
      | statusMsg  | Bad Request                                                  |
      | errorCode  | 2000                                                         |
      | errorMsg   | Delta does not have flights scheduled that match the request |

  @Negative
  Scenario: Verify that an invalid departureDate returns the proper error code and response
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=DAL&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].departure.airport.icao" as "departure_airport"
    And I save the JSON at "[0].arrival.airport.icao" as "arrival_airport"
    When I send a CPAPI GET request to "/v1/flightStatusByLeg?flightNum=%{flight_number}&depDate=INVALID&originCode=%{departure_airport}&destCode=%{arrival_airport}"
    And the response headers should be JSON
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

  @Negative
  Scenario: Verify that an invalid originCode returns the proper error code and response
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=DAL&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].arrival.airport.icao" as "arrival_airport"
    And I retrieve the departure time
    Given I format the departure time
    When I send a CPAPI GET request to "/v1/flightStatusByLeg?flightNum=%{flight_number}&depDate=INVALID&originCode=INVALID&destCode=%{arrival_airport}"
    And the response headers should be JSON
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

  @Negative
  Scenario: Verify that an invalid destCode returns the proper error code and response
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=DAL&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].departure.airport.icao" as "departure_airport"
    And I retrieve the departure time
    Given I format the departure time
    When I send a CPAPI GET request to "/v1/flightStatusByLeg?flightNum=%{flight_number}&depDate=%{date}&originCode=%{departure_airport}&destCode=INVALID"
    And the response headers should be JSON
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

  @Negative
  Scenario: Verify that an unknown flightNum returns the proper error code and response
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=DAL&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].departure.airport.icao" as "departure_airport"
    And I save the JSON at "[0].arrival.airport.icao" as "arrival_airport"
    And I retrieve the departure time
    Given I format the departure time
    When I send a CPAPI GET request to "/v1/flightStatusByLeg?flightNum=000&depDate=%{date}&originCode=%{departure_airport}&destCode=%{arrival_airport}"
    And the response headers should be JSON
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

  @Negative
  Scenario: Verify that a departureDate in the past returns the proper error code and response
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=DAL&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].departure.airport.icao" as "departure_airport"
    And I save the JSON at "[0].arrival.airport.icao" as "arrival_airport"
    When I send a CPAPI GET request to "/v1/flightStatusByLeg?flightNum=%{flight_number}&depDate=1936-12-12&originCode=%{departure_airport}&destCode=%{arrival_airport}"
    And the response headers should be JSON
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

  @Negative
  Scenario: Verify that an unknown originCode returns the proper error code and response
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=DAL&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].arrival.airport.icao" as "arrival_airport"
    And I retrieve the departure time
    Given I format the departure time
    When I send a CPAPI GET request to "/v1/flightStatusByLeg?flightNum=%{flight_number}&depDate=%{date}&originCode=XXXX&destCode=%{arrival_airport}"
    And the response headers should be JSON
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

  @Negative
  Scenario: Verify that an unknown destCode returns the proper error code and response
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=DAL&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].departure.airport.icao" as "departure_airport"
    And I save the JSON at "[0].arrival.airport.icao" as "arrival_airport"
    And I retrieve the departure time
    Given I format the departure time
    When I send a CPAPI GET request to "/v1/flightStatusByLeg?flightNum=%{flight_number}&depDate=%{date}&originCode=%{departure_airport}&destCode=XXXX"
    And the response headers should be JSON
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