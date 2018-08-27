#############################################################################################
# This Feature file will test the the E2E functionality of GBP Edge Cache Products call. This
# will call FIG based on the parameters included in the request or get the cached call
#
# @Author Brian DeSimone
# @Date 05/30/2018
#############################################################################################
@GBPEdgeCache @Regression
Feature: Validate POST products for GBP Edge Cache

  Background: Setup the flight information attributes for the test
    Given I set the following attributes in memory:
      | airline_code  | DAL    |
      | tail_number   | 0DAL2  |
      | flight_number | DAL123 |
      | version       | 3.0    |

  @HealthCheck
  Scenario: Validate that a successful request returns the proper response code when using cached data (smoke test)
    Given I generate a product object with the required attributes and caching enabled
    And I set custom headers:
      | X-Client-ID  | ABP             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite POST request to "/edge/data/product?cache_flag=0" with the generated body
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate that a successful request returns the proper response code when using on demand request (smoke-test)
    Given I generate a product object with the maximum attributes and caching disabled
    And I set custom headers:
      | X-Client-ID  | ABP             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite POST request to "/edge/data/product?cache_flag=0" with the generated body
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate that a successful request returns proper schema, data types, data, and headers when using cached data
    Given I generate a product object with the required attributes and caching enabled
    And I set custom headers:
      | X-Client-ID  | ABP             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite POST request to "/edge/data/product?cache_flag=0" with the generated body
    Then the response status should be "200"
    And the response headers should be JSON
    And the JSON response should include the following:
      | status_code                   |
      | status_message                |
      | ttl                           |
      | edge_cache_enabled            |
      | products                      |
      | products[0].locale            |
      | products[0].currency          |
      | products[0].device_type       |
      | products[0].content           |
      | products[0].version           |
      | products[0].region            |
      | info                          |
      | info.aircraft_tail_number     |
      | info.airline_code             |
      | info.departure_airport_code   |
      | info.destination_airport_code |
      | info.flight_number            |
      | info.flight_status            |
    And the JSON response should have the following data types:
      | status_code                   | Integer   |
      | status_message                | String    |
      | ttl                           | Integer   |
      | edge_cache_enabled            | String    |
      | products                      | ArrayList |
      | products[0].locale            | String    |
      | products[0].currency          | String    |
      | products[0].device_type       | String    |
      | products[0].content           | String    |
      | products[0].version           | String    |
      | products[0].region            | String    |
      | info                          | HashMap   |
      | info.aircraft_tail_number     | String    |
      | info.airline_code             | String    |
      | info.departure_airport_code   | String    |
      | info.destination_airport_code | String    |
      | info.flight_number            | String    |
      | info.flight_status            | String    |
    And the JSON response should be the following:
      | status_code               | 200             |
      | status_message            | OK              |
      | ttl                       | 3600            |
      | edge_cache_enabled        | true            |
      | info.aircraft_tail_number | %{tail_number}  |
      | info.airline_code         | %{airline_code} |

  @HealthCheck
  Scenario: Validate that a successful request returns proper schema, data types, data, and headers when using on demand data
    Given I generate a product object with the maximum attributes and caching disabled
    And I set custom headers:
      | X-Client-ID  | ABP             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite POST request to "/edge/data/product?cache_flag=0" with the generated body
    Then the response status should be "200"
    And the response headers should be JSON
    And the JSON response should include the following:
      | status_code                   |
      | status_message                |
      | ttl                           |
      | edge_cache_enabled            |
      | products                      |
      | products[0].locale            |
      | products[0].currency          |
      | products[0].device_type       |
      | products[0].content           |
      | products[0].region            |
      | info                          |
      | info.aircraft_tail_number     |
      | info.airline_code             |
      | info.departure_airport_code   |
      | info.destination_airport_code |
      | info.flight_number            |
    And the JSON response should have the following data types:
      | status_code                   | Integer   |
      | status_message                | String    |
      | ttl                           | Integer   |
      | edge_cache_enabled            | String    |
      | products                      | ArrayList |
      | products[0].locale            | String    |
      | products[0].currency          | String    |
      | products[0].device_type       | String    |
      | products[0].content           | String    |
      | products[0].region            | String    |
      | info                          | HashMap   |
      | info.aircraft_tail_number     | String    |
      | info.airline_code             | String    |
      | info.departure_airport_code   | String    |
      | info.destination_airport_code | String    |
      | info.flight_number            | String    |
    And the JSON response should be the following:
      | status_code                   | 200             |
      | status_message                | OK              |
      | ttl                           | 3600            |
      | edge_cache_enabled            | true            |
      | info.aircraft_tail_number     | %{tail_number}  |
      | info.airline_code             | %{airline_code} |
      | info.departure_airport_code   | LAX             |
      | info.destination_airport_code | ORD             |

  @Positive
  Scenario: Validate that X-Client-ID header accepts any value
    Given I generate a product object with the required attributes and caching enabled
    And I set custom headers:
      | X-Client-ID  | TEST            |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite POST request to "/edge/data/product?cache_flag=0" with the generated body
    Then the response status should be "200"

  @Positive
  Scenario: Validate that X-Airline-ID header accepts any value
    Given I generate a product object with the required attributes and caching enabled
    And I set custom headers:
      | X-Client-ID  | ABP    |
      | X-Request-ID | random |
      | X-Airline-ID | TEST   |
    When I send a GBP Lite POST request to "/edge/data/product?cache_flag=0" with the generated body
    Then the response status should be "200"

  @Positive
  Scenario Outline: Validate that parameters that have defaults are set when they are missing or empty in the request payload when caching enabled
    Given I generate a product object with the required attributes and caching enabled
    And I modify the JSON at "<attribute>" to be "<value>"
    And I set custom headers:
      | X-Client-ID  | ABP             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite POST request to "/edge/data/product?cache_flag=0" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | status_code    | 200 |
      | status_message | OK  |

    Examples: Missing or empty attributes with defaults
      | attribute | value |
      | version   | null  |
      | version   |       |

  @Positive
  Scenario Outline: Validate that pre_fetch_flag defaults to false when null or empty in the request payload
    Given I generate a product object with the required attributes and caching disabled
    And I modify the JSON at "pre_fetch_flag" to be "<value>"
    And I set custom headers:
      | X-Client-ID  | ABP             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite POST request to "/edge/data/product?cache_flag=0" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                 |
      | status_message | Bad Request                         |
      | error_code     | EDG001                              |
      | error_message  | Missing required request parameters |

    Examples: Pre fetch values
      | value |
      | null  |
      |       |

  @Positive
  Scenario Outline: Validate that when pre_fetch_flag is false the optional attribute: <attribute> defaults when value: <value>
    Given I generate a product object with the maximum attributes and caching disabled
    And I modify the JSON at "<attribute>" to be "<value>"
    And I set custom headers:
      | X-Client-ID  | ABP             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite POST request to "/edge/data/product?cache_flag=0" with the generated body
    Then the response status should be "200"

    Examples: Optional attributes that default
      | attribute                                   | value |
      | device_type                                 | null  |
      | locale                                      | null  |
      | connectivity_type                           | null  |
      | currency                                    | null  |
      | flight_information.departure_airport_code   | null  |
      | flight_information.destination_airport_code | null  |
      | flight_information.flight_number            | null  |
      | device_type                                 |       |
#      | locale                                      |       |
      | connectivity_type                           |       |
#      | currency                                    |       |
      | flight_information.departure_airport_code   |       |
      | flight_information.destination_airport_code |       |
      | flight_information.flight_number            |       |

  @Negative
  Scenario: Validate that when locale is empty or invalid we have a failed dependency error code and error message
    Given I generate a product object with the maximum attributes and caching disabled
    And I modify the JSON at "locale" to be "INVALID"
    And I set custom headers:
      | X-Client-ID  | ABP             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite POST request to "/edge/data/product?cache_flag=0" with the generated body
    Then the response status should be "424"
    And the JSON response should be the following:
      | status_code    | 400                          |
      | status_message | Bad Request                  |
      | error_code     | 1002                         |
      | error_message  | [Incorrect value for locale] |

  @Negative
  Scenario: Validate that when currency is empty or invalid we have a failed dependency error code and error message
    Given I generate a product object with the maximum attributes and caching disabled
    And I modify the JSON at "currency" to be "INVALID"
    And I set custom headers:
      | X-Client-ID  | ABP             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite POST request to "/edge/data/product?cache_flag=0" with the generated body
    Then the response status should be "424"
    And the JSON response should be the following:
      | status_code    | 400                            |
      | status_message | Bad Request                    |
      | error_code     | 1002                           |
      | error_message  | [Incorrect value for currency] |

  @Negative
  Scenario: Validate that the proper error code and error message are displayed when invalid JSON in request payload
    Given I set custom headers:
      | X-Client-ID  | ABP             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite POST request to "/edge/data/product?cache_flag=0" with JSON body:
      """
      {invalid:invalid}
      """
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                               |
      | status_message | Bad Request                       |
      | error_code     | EDG001                            |
      | error_message  | Request JSON structure is invalid |

  @Negative
  Scenario: Validate that the proper error code and error message are displayed when missing X-Client-ID header
    Given I generate a product object with the required attributes and caching enabled
    And I set custom headers:
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite POST request to "/edge/data/product?cache_flag=0" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                                                      |
      | status_message | Bad Request                                                              |
      | error_code     | EDG001                                                                   |
      | error_message  | Missing request header 'X-Client-ID' for method parameter of type String |

  @Negative
  Scenario: Validate that the proper error code and error message are displayed when missing X-Request-ID header
    Given I generate a product object with the required attributes and caching enabled
    And I set custom headers:
      | X-Client-ID  | ABP             |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite POST request to "/edge/data/product?cache_flag=0" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                                                       |
      | status_message | Bad Request                                                               |
      | error_code     | EDG001                                                                    |
      | error_message  | Missing request header 'X-Request-ID' for method parameter of type String |

  @Negative
  Scenario: Validate that the proper error code and error message are displayed when missing X-Airline-ID header
    Given I generate a product object with the required attributes and caching enabled
    And I set custom headers:
      | X-Client-ID  | ABP    |
      | X-Request-ID | random |
    When I send a GBP Lite POST request to "/edge/data/product?cache_flag=0" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                                                       |
      | status_message | Bad Request                                                               |
      | error_code     | EDG001                                                                    |
      | error_message  | Missing request header 'X-Airline-ID' for method parameter of type String |

  @Negative
  Scenario: Validate that the proper error code and error message are displayed when missing cache flag in the request URI
    Given I generate a product object with the required attributes and caching enabled
    And I set custom headers:
      | X-Client-ID  | ABP             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite POST request to "/edge/data/product" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                                    |
      | status_message | Bad Request                                            |
      | error_code     | EDG001                                                 |
      | error_message  | Required boolean parameter 'cache_flag' is not present |

  @Negative
  Scenario Outline: Validate that the proper error code and error message are displayed when attribute: <attribute> is value: <value> in the request payload
    Given I generate a product object with the required attributes and caching enabled
    And I modify the JSON at "<attribute>" to be "<value>"
    And I set custom headers:
      | X-Client-ID  | ABP             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite POST request to "/edge/data/product?cache_flag=0" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400             |
      | status_message | Bad Request     |
      | error_code     | <error_code>    |
      | error_message  | <error_message> |

    Examples: Missing or invalid attributes and error messages
      | attribute                               | value | error_code | error_message                       |
      | pre_fetch_flag                          | null  | EDG001     | Missing required request parameters |
      | flight_information                      | null  | EDG001     | Missing required request parameters |
      | flight_information.aircraft_tail_number | null  | EDG001     | Missing required request parameters |
      | pre_fetch_flag                          |       | EDG001     | Missing required request parameters |
      | flight_information.aircraft_tail_number |       | EDG001     | Missing required request parameters |

  @Negative
  Scenario Outline: Validate that the proper error code and error message are displayed when attribute: <attribute> is value: <value> when prefetch is false in the request payload
    Given I generate a product object with the maximum attributes and caching disabled
    And I modify the JSON at "<attribute>" to be "<value>"
    And I set custom headers:
      | X-Client-ID  | ABP             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite POST request to "/edge/data/product?cache_flag=0" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400             |
      | status_message | Bad Request     |
      | error_code     | <error_code>    |
      | error_message  | <error_message> |

    Examples: Missing or invalid attributes and error messages
      | attribute                               | value | error_code | error_message                       |
      | flight_information                      | null  | EDG001     | Missing required request parameters |
      | flight_information.aircraft_tail_number | null  | EDG001     | Missing required request parameters |
      | flight_information.airline_code         | null  | EDG001     | Missing required request parameters |
      | flight_information.aircraft_tail_number |       | EDG001     | Missing required request parameters |
      | flight_information.airline_code         |       | EDG001     | Missing required request parameters |