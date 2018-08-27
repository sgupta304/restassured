#############################################################################################
# This Feature file will test the the E2E functionality of GBP Edge Cache Flight Info API.
# This will call CPAPI based on the parameters included in the request or get the cached call
#
# @Author Brian DeSimone
# @Date 05/31/2018
#############################################################################################
@GBPEdgeCache @Regression
Feature: Validate GET flight info for GBP Edge Cache

  Background: Setup the flight information and attributes for the test
    Given I set the following attributes in memory:
      | airline_code | DAL |
    When I send a FIG GET request to "/v1/flights?status=in_air&airline-icao=%{airline_code}&page-size=1&page=3"
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].departure.airport.icao" as "departure_airport"
    And I save the JSON at "[0].arrival.airport.icao" as "arrival_airport"
    And I save the JSON at "[0].aircraft.registration_number" as "tail_number"
    And I retrieve the departure time
    Given I format the departure time

  @HealthCheck
  Scenario: Validate that a successful request returns the proper response code when not using cache
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/flightstatus/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=1.0&cache_flag=0"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate that a successful request returns the proper response code when using cache
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/flightstatus/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=prefetch&cache_flag=0"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate that a successful request returns proper schema, data types, data, and headers when not using cache
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/flightstatus/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=1.0&cache_flag=0"
    Then the response status should be "200"
    And the response headers should be JSON
    And the JSON response should include the following:
      | status_code                   |
      | status_message                |
      | ttl                           |
      | version                       |
      | flight_number                 |
      | departure_airport_code        |
      | destination_airport_code      |
      | departure_date                |
      | flight_status_list            |
      | flight_status_list[0].content |
    And the JSON response should have the following data types:
      | status_code                   | Integer   |
      | status_message                | String    |
      | ttl                           | Integer   |
      | version                       | String    |
      | flight_number                 | String    |
      | departure_airport_code        | String    |
      | destination_airport_code      | String    |
      | departure_date                | String    |
      | flight_status_list            | ArrayList |
      | flight_status_list[0].content | String    |
    And the JSON response should be the following:
      | status_code              | 200                  |
      | status_message           | OK                   |
      | ttl                      | 3600                 |
      | version                  | 1.0                  |
      | flight_number            | %{flight_number}     |
      | departure_airport_code   | %{departure_airport} |
      | destination_airport_code | %{arrival_airport}   |
      | departure_date           | %{date}              |

  @HealthCheck
  Scenario: Validate that a successful request returns proper schema, data types, data, and headers when using cache
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/flightstatus/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=prefetch&cache_flag=0"
    Then the response status should be "200"
    And the response headers should be JSON
    And the JSON response should include the following:
      | status_code                   |
      | status_message                |
      | ttl                           |
      | version                       |
      | flight_number                 |
      | departure_airport_code        |
      | destination_airport_code      |
      | departure_date                |
      | flight_status_list            |
      | flight_status_list[0].content |
    And the JSON response should have the following data types:
      | status_code                   | Integer   |
      | status_message                | String    |
      | ttl                           | Integer   |
      | version                       | String    |
      | flight_number                 | String    |
      | departure_airport_code        | String    |
      | destination_airport_code      | String    |
      | departure_date                | String    |
      | flight_status_list            | ArrayList |
      | flight_status_list[0].content | String    |
    And the JSON response should be the following:
      | status_code              | 200                  |
      | status_message           | OK                   |
      | ttl                      | 3600                 |
      | version                  | 1.0                  |
      | flight_number            | %{flight_number}     |
      | departure_airport_code   | %{departure_airport} |
      | destination_airport_code | %{arrival_airport}   |
      | departure_date           | %{date}              |

  @Positive
  Scenario: Validate that X-Client-ID header accepts any value
    Given I set custom headers:
      | X-Client-ID  | TEST            |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/flightstatus/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=1.0&cache_flag=0"
    Then the response status should be "200"

  @Negative
  Scenario: Validate that X-Airline-ID header accepts any value
    Given I set custom headers:
      | X-Client-ID  | IFC    |
      | X-Request-ID | random |
      | X-Airline-ID | TEST   |
    When I send a GBP Lite GET request to "/edge/data/flightstatus/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=1.0&cache_flag=0"
    Then the response status should be "200"

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when missing X-Client-ID header
    Given I set custom headers:
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/flightstatus/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=1.0&cache_flag=0"
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                                                      |
      | status_message | Bad Request                                                              |
      | error_code     | EDG001                                                                   |
      | error_message  | Missing request header 'X-Client-ID' for method parameter of type String |

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when missing X-Request-ID header
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/flightstatus/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=1.0&cache_flag=0"
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                                                       |
      | status_message | Bad Request                                                               |
      | error_code     | EDG001                                                                    |
      | error_message  | Missing request header 'X-Request-ID' for method parameter of type String |

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when missing X-Airline-ID header
    Given I set custom headers:
      | X-Client-ID  | IFC    |
      | X-Request-ID | random |
    When I send a GBP Lite GET request to "/edge/data/flightstatus/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=1.0&cache_flag=0"
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                                                       |
      | status_message | Bad Request                                                               |
      | error_code     | EDG001                                                                    |
      | error_message  | Missing request header 'X-Airline-ID' for method parameter of type String |

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when missing tail_number in the request URI
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/flightstatus/%{airline_code}/%{flight_number}/?departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=1.0&cache_flag=0"
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                                    |
      | status_message | Bad Request                                            |
      | error_code     | EDG001                                                 |
      | error_message  | Required String parameter 'tail_number' is not present |

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when invalid airline_icao in the request URI
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/flightstatus/INVALID/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=1.0&cache_flag=0"
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                |
      | status_message | Bad Request                        |
      | error_code     | EDG001                             |
      | error_message  | Unsupported airline code parameter |

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when invalid flight_number in the request URI
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/flightstatus/%{airline_code}/INVALID/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=1.0&cache_flag=0"
    Then the response status should be "424"
    And the JSON response should be the following:
      | status_code    | 400                                                          |
      | status_message | Bad Request                                                  |
      | error_code     | 2000                                                         |
      | error_message  | Delta does not have flights scheduled that match the request |

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when invalid departure_airport_code in the request URI
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/flightstatus/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=1.0&cache_flag=0"
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                 |
      | status_message | Bad Request                         |
      | error_code     | EDG001                              |
      | error_message  | Missing required request parameters |

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when missing destination_airport_code in the request URI
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/flightstatus/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&departure_date=%{date}&version=1.0&cache_flag=0"
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                 |
      | status_message | Bad Request                         |
      | error_code     | EDG001                              |
      | error_message  | Missing required request parameters |

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when missing departure_date in the request URI
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/flightstatus/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&version=1.0&cache_flag=0"
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                                       |
      | status_message | Bad Request                                               |
      | error_code     | EDG001                                                    |
      | error_message  | Required String parameter 'departure_date' is not present |

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when missing version in the request URI
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/flightstatus/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&cache_flag=0"
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                                |
      | status_message | Bad Request                                        |
      | error_code     | EDG001                                             |
      | error_message  | Required String parameter 'version' is not present |

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when missing cache flag in the request URI
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/flightstatus/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=1.0"
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                                    |
      | status_message | Bad Request                                            |
      | error_code     | EDG001                                                 |
      | error_message  | Required boolean parameter 'cache_flag' is not present |