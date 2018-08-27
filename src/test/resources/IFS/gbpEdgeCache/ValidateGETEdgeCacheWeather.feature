#############################################################################################
# This Feature file will test the the E2E functionality of GBP Edge Cache Weather API.
# This will call CPAPI based on the parameters included in the request or get the cached call
#
# @Author Brian DeSimone
# @Date 05/31/2018
#############################################################################################
@GBPEdgeCache @Regression
Feature: Validate GET weather for GBP Edge Cache

  Background: Setup the flight information and attributes for the test
    Given I set the following attributes in memory:
      | locale       | en_US |
      | airport_code | ORD   |
      | airline_code | DAL   |
      | tail_number  | 0DAL2 |

  @HealthCheck
  Scenario: Validate that a successful request returns the proper response code when not using cache
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/weather/%{airport_code}?tail_number=%{tail_number}&locale=%{locale}&scale=F&days=1&version=2.0&cache_flag=0"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate that a successful request returns the proper response code when using cache
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/weather/%{airport_code}?tail_number=%{tail_number}&locale=%{locale}&scale=F&days=1&version=prefetch&cache_flag=0"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate that a successful request returns proper schema, data types, data, and headers when not using cache
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/weather/%{airport_code}?tail_number=%{tail_number}&locale=%{locale}&scale=F&days=1&version=2.0&cache_flag=0"
    Then the response status should be "200"
    And the response headers should be JSON
    And the JSON response should include the following:
      | status_code           |
      | status_message        |
      | ttl                   |
      | version               |
      | airport_code          |
      | weather               |
      | weather[0].locale     |
      | weather[0].scale      |
      | weather[0].days       |
      | weather[0].attributes |
      | weather[0].content    |
    And the JSON response should have the following data types:
      | status_code           | Integer   |
      | status_message        | String    |
      | ttl                   | Integer   |
      | version               | String    |
      | airport_code          | String    |
      | weather               | ArrayList |
      | weather[0].locale     | String    |
      | weather[0].scale      | String    |
      | weather[0].days       | Integer   |
      | weather[0].attributes | HashMap   |
      | weather[0].content    | String    |
    And the JSON response should be the following:
      | status_code       | 200             |
      | status_message    | OK              |
      | ttl               | 300             |
      | version           | 2.0             |
      | airport_code      | %{airport_code} |
      | weather[0].locale | %{locale}       |
      | weather[0].scale  | F               |
      | weather[0].days   | 1               |

  @HealthCheck
  Scenario: Validate that a successful request returns proper schema, data types, data, and headers when using cache
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/weather/%{airport_code}?tail_number=%{tail_number}&locale=%{locale}&scale=F&days=1&version=prefetch&cache_flag=0"
    Then the response status should be "200"
    And the response headers should be JSON
    And the JSON response should include the following:
      | status_code           |
      | status_message        |
      | ttl                   |
      | version               |
      | airport_code          |
      | weather               |
      | weather[0].locale     |
      | weather[0].scale      |
      | weather[0].days       |
      | weather[0].attributes |
      | weather[0].content    |
    And the JSON response should have the following data types:
      | status_code           | Integer   |
      | status_message        | String    |
      | ttl                   | Integer   |
      | version               | String    |
      | airport_code          | String    |
      | weather               | ArrayList |
      | weather[0].locale     | String    |
      | weather[0].scale      | String    |
      | weather[0].days       | Integer   |
      | weather[0].attributes | HashMap   |
      | weather[0].content    | String    |
    And the JSON response should be the following:
      | status_code       | 200             |
      | status_message    | OK              |
      | ttl               | 300             |
      | version           | 2.0             |
      | airport_code      | %{airport_code} |
      | weather[0].locale | %{locale}       |
      | weather[0].scale  | F               |
      | weather[0].days   | 1               |

  @Positive
  Scenario: Validate that X-Client-ID header accepts any value
    Given I set custom headers:
      | X-Client-ID  | TEST            |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/weather/%{airport_code}?tail_number=%{tail_number}&locale=%{locale}&scale=F&days=1&version=2.0&cache_flag=0"
    Then the response status should be "200"

  @Negative
  Scenario: Validate that X-Airline-ID header accepts any value
    Given I set custom headers:
      | X-Client-ID  | IFC    |
      | X-Request-ID | random |
      | X-Airline-ID | TEST   |
    When I send a GBP Lite GET request to "/edge/data/weather/%{airport_code}?tail_number=%{tail_number}&locale=%{locale}&scale=F&days=1&version=2.0&cache_flag=0"
    Then the response status should be "200"

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when missing X-Client-ID header
    Given I set custom headers:
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/weather/%{airport_code}?tail_number=%{tail_number}&locale=%{locale}&scale=F&days=1&version=2.0&cache_flag=0"
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
    When I send a GBP Lite GET request to "/edge/data/weather/%{airport_code}?tail_number=%{tail_number}&locale=%{locale}&scale=F&days=1&version=2.0&cache_flag=0"
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
    When I send a GBP Lite GET request to "/edge/data/weather/%{airport_code}?tail_number=%{tail_number}&locale=%{locale}&scale=F&days=1&version=2.0&cache_flag=0"
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
    When I send a GBP Lite GET request to "/edge/data/weather/%{airport_code}?locale=%{locale}&scale=F&days=1&version=2.0&cache_flag=0"
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                                    |
      | status_message | Bad Request                                            |
      | error_code     | EDG001                                                 |
      | error_message  | Required String parameter 'tail_number' is not present |

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when invalid airport_code in the request URI
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/weather/INVALID?tail_number=%{tail_number}&locale=%{locale}&scale=F&days=1&version=2.0&cache_flag=0"
    Then the response status should be "424"
    And the JSON response should be the following:
      | status_code    | 400                    |
      | status_message | Bad Request            |
      | error_code     | 1112                   |
      | error_message  | airportCode is invalid |

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when missing scale in the request URI
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/weather/%{airport_code}?tail_number=%{tail_number}&locale=%{locale}&days=1&version=2.0&cache_flag=0"
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                              |
      | status_message | Bad Request                                      |
      | error_code     | EDG001                                           |
      | error_message  | Required String parameter 'scale' is not present |

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when missing days in the request URI
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/weather/%{airport_code}?tail_number=%{tail_number}&locale=%{locale}&scale=F&version=2.0&cache_flag=0"
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                          |
      | status_message | Bad Request                                  |
      | error_code     | EDG001                                       |
      | error_message  | Required int parameter 'days' is not present |

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when missing locale in the request URI
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/weather/%{airport_code}?tail_number=%{tail_number}&scale=F&days=1&version=2.0&cache_flag=0"
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                               |
      | status_message | Bad Request                                       |
      | error_code     | EDG001                                            |
      | error_message  | Required String parameter 'locale' is not present |

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when missing version in the request URI
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/weather/%{airport_code}?tail_number=%{tail_number}&locale=%{locale}&scale=F&days=1&cache_flag=0"
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
    When I send a GBP Lite GET request to "/edge/data/weather/%{airport_code}?tail_number=%{tail_number}&locale=%{locale}&scale=F&days=1&version=2.0"
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                                    |
      | status_message | Bad Request                                            |
      | error_code     | EDG001                                                 |
      | error_message  | Required boolean parameter 'cache_flag' is not present |