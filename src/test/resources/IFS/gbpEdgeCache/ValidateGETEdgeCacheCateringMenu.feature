#############################################################################################
# This Feature file will test the the E2E functionality of GBP Edge Cache Catering Menu API.
# This will send a request based on the parameters included in the request or get the cached call
#
# @Author Brian DeSimone
# @Date 05/31/2018
#############################################################################################
@GBPEdgeCache @Regression
Feature: Validate GET catering menu for GBP Edge Cache

  Background: Setup the flight information and attributes for the test
    Given I set the following attributes in memory:
      | airline_code | ASA |
    When I retrieve in_air flights and verify the airline partner
    Then the response status should be "200"
    And I save the JSON at "[0].flight.flight_number" as "flight_number"
    And I save the JSON at "[0].departure.airport.iata" as "departure_airport"
    And I save the JSON at "[0].arrival.airport.iata" as "arrival_airport"
    And I save the JSON at "[0].aircraft.registration_number" as "tail_number"
    And I retrieve the departure time
    Given I format the departure time

  @HealthCheck
  Scenario: Validate that a successful request returns the proper response code when not using cache
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/cateringmenu/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=1.0&cache_flag=0"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate that a successful request returns the proper response code when using cache
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/cateringmenu/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=prefetch&cache_flag=0"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate that a successful request returns proper schema, data types, data, and headers when not using cache
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/cateringmenu/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=1.0&cache_flag=0"
    Then the response status should be "200"
    And the response headers should be JSON
    And the JSON response should include the following:
      | status_code                  |
      | status_message               |
      | ttl                          |
      | version                      |
      | catering_menus               |
      | catering_menus[0].content    |
      | catering_menus[0].attributes |
    And the JSON response should have the following data types:
      | status_code                  | Integer   |
      | status_message               | String    |
      | ttl                          | Integer   |
      | version                      | String    |
      | catering_menus               | ArrayList |
      | catering_menus[0].content    | String    |
      | catering_menus[0].attributes | HashMap   |
    And the JSON response should be the following:
      | status_code    | 200   |
      | status_message | OK    |
      | ttl            | 18000 |
      | version        | 2.0   |

  @HealthCheck
  Scenario: Validate that a successful request returns proper schema, data types, data, and headers when using cache
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/cateringmenu/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=prefetch&cache_flag=0"
    Then the response status should be "200"
    And the response headers should be JSON
    And the JSON response should include the following:
      | status_code                  |
      | status_message               |
      | ttl                          |
      | version                      |
      | catering_menus               |
      | catering_menus[0].content    |
      | catering_menus[0].attributes |
    And the JSON response should have the following data types:
      | status_code                  | Integer   |
      | status_message               | String    |
      | ttl                          | Integer   |
      | version                      | String    |
      | catering_menus               | ArrayList |
      | catering_menus[0].content    | String    |
      | catering_menus[0].attributes | HashMap   |
    And the JSON response should be the following:
      | status_code    | 200   |
      | status_message | OK    |
      | ttl            | 18000 |
      | version        | 2.0   |

  @Positive
  Scenario: Validate that X-Client-ID header accepts any value
    Given I set custom headers:
      | X-Client-ID  | TEST            |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/cateringmenu/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=2.0&cache_flag=0"
    Then the response status should be "200"

  @Positive
  Scenario: Validate that X-Airline-ID header accepts any value
    Given I set custom headers:
      | X-Client-ID  | IFC    |
      | X-Request-ID | random |
      | X-Airline-ID | TEST   |
    When I send a GBP Lite GET request to "/edge/data/cateringmenu/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=2.0&cache_flag=0"
    Then the response status should be "200"

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when missing X-Client-ID header
    Given I set custom headers:
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/cateringmenu/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=2.0&cache_flag=0"
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
    When I send a GBP Lite GET request to "/edge/data/cateringmenu/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=2.0&cache_flag=0"
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
    When I send a GBP Lite GET request to "/edge/data/cateringmenu/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=2.0&cache_flag=0"
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
    When I send a GBP Lite GET request to "/edge/data/cateringmenu/%{airline_code}/%{flight_number}/?departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=2.0&cache_flag=0"
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
    When I send a GBP Lite GET request to "/edge/data/cateringmenu/INVALID/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=2.0&cache_flag=0"
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
    When I send a GBP Lite GET request to "/edge/data/cateringmenu/%{airline_code}/INVALID/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=2.0&cache_flag=0"
    Then the response status should be "424"
    And the JSON response should be the following:
      | status_code    | 400                              |
      | status_message | Bad Request                      |
      | error_code     | 1011                             |
      | error_message  | Flight number is invalid or null |

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when invalid departure_airport_code in the request URI
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/cateringmenu/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=2.0&cache_flag=0"
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                                               |
      | status_message | Bad Request                                                       |
      | error_code     | EDG001                                                            |
      | error_message  | Required String parameter 'departure_airport_code' is not present |

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when missing destination_airport_code in the request URI
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/cateringmenu/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&departure_date=%{date}&version=2.0&cache_flag=0"
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                                                 |
      | status_message | Bad Request                                                         |
      | error_code     | EDG001                                                              |
      | error_message  | Required String parameter 'destination_airport_code' is not present |

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when missing departure_date in the request URI
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/cateringmenu/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&version=2.0&cache_flag=0"
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
    When I send a GBP Lite GET request to "/edge/data/cateringmenu/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&cache_flag=0"
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
    When I send a GBP Lite GET request to "/edge/data/cateringmenu/%{airline_code}/%{flight_number}/?tail_number=%{tail_number}&departure_airport_code=%{departure_airport}&destination_airport_code=%{arrival_airport}&departure_date=%{date}&version=2.0"
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                                    |
      | status_message | Bad Request                                            |
      | error_code     | EDG001                                                 |
      | error_message  | Required boolean parameter 'cache_flag' is not present |