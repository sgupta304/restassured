#############################################################################################
# This Feature file will test the the E2E functionality of GBP Edge Cache Blog Feed API.
# This will send a request based on the parameters included in the request or get the cached call
#
# @Author Brian DeSimone
# @Date 05/31/2018
#############################################################################################
@GBPEdgeCache @Regression
Feature: Validate GET blog feed for GBP Edge Cache

  Background: Setup the flight information and attributes for the test
    Given I set the following attributes in memory:
      | airline_code | ASA   |
      | tail_number  | 0ASA2 |
      | locale       | en_US |

  @HealthCheck
  Scenario: Validate that a successful request returns the proper response code when not using cache
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/blogfeed/%{airline_code}/?tail_number=%{tail_number}&locale=%{locale}&version=2.0&cache_flag=0"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate that a successful request returns the proper response code when using cache
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/blogfeed/%{airline_code}/?tail_number=%{tail_number}&locale=%{locale}&version=precheck&cache_flag=0"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate that a successful request returns proper schema, data types, data, and headers when not using cache
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/blogfeed/%{airline_code}/?tail_number=%{tail_number}&locale=%{locale}&version=2.0&cache_flag=0"
    Then the response status should be "200"
    And the response headers should be JSON
    And the JSON response should include the following:
      | status_code              |
      | status_message           |
      | ttl                      |
      | version                  |
      | airline_code             |
      | blog_feeds               |
      | blog_feeds[0].locale     |
      | blog_feeds[0].content    |
      | blog_feeds[0].attributes |
      | info                     |
    And the JSON response should have the following data types:
      | status_code              | Integer   |
      | status_message           | String    |
      | ttl                      | Integer   |
      | version                  | String    |
      | airline_code             | String    |
      | blog_feeds               | ArrayList |
      | blog_feeds[0].locale     | String    |
      | blog_feeds[0].content    | String    |
      | blog_feeds[0].attributes | HashMap   |
      | info                     | HashMap   |
    And the JSON response should be the following:
      | status_code          | 200             |
      | status_message       | OK              |
      | ttl                  | 18000           |
      | version              | 2.0             |
      | airline_code         | %{airline_code} |
      | blog_feeds[0].locale | %{locale}       |

  @HealthCheck
  Scenario: Validate that a successful request returns proper schema, data types, data, and headers when using cache
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/blogfeed/%{airline_code}/?tail_number=%{tail_number}&locale=%{locale}&version=precheck&cache_flag=0"
    Then the response status should be "200"
    And the response headers should be JSON
    And the JSON response should include the following:
      | status_code              |
      | status_message           |
      | ttl                      |
      | version                  |
      | airline_code             |
      | blog_feeds               |
      | blog_feeds[0].locale     |
      | blog_feeds[0].content    |
      | blog_feeds[0].attributes |
      | info                     |
    And the JSON response should have the following data types:
      | status_code              | Integer   |
      | status_message           | String    |
      | ttl                      | Integer   |
      | version                  | String    |
      | airline_code             | String    |
      | blog_feeds               | ArrayList |
      | blog_feeds[0].locale     | String    |
      | blog_feeds[0].content    | String    |
      | blog_feeds[0].attributes | HashMap   |
      | info                     | HashMap   |
    And the JSON response should be the following:
      | status_code          | 200             |
      | status_message       | OK              |
      | ttl                  | 18000           |
      | version              | 2.0             |
      | airline_code         | %{airline_code} |
      | blog_feeds[0].locale | %{locale}       |

  @Positive
  Scenario: Validate that X-Client-ID header accepts any value
    Given I set custom headers:
      | X-Client-ID  | TEST            |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/blogfeed/%{airline_code}/?tail_number=%{tail_number}&locale=%{locale}&version=2.0&cache_flag=0"
    Then the response status should be "200"

  @Positive
  Scenario: Validate that X-Airline-ID header accepts any value
    Given I set custom headers:
      | X-Client-ID  | IFC    |
      | X-Request-ID | random |
      | X-Airline-ID | TEST   |
    When I send a GBP Lite GET request to "/edge/data/blogfeed/%{airline_code}/?tail_number=%{tail_number}&locale=%{locale}&version=2.0&cache_flag=0"
    Then the response status should be "200"

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when missing X-Client-ID header
    Given I set custom headers:
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/blogfeed/%{airline_code}/?tail_number=%{tail_number}&locale=%{locale}&version=2.0&cache_flag=0"
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
    When I send a GBP Lite GET request to "/edge/data/blogfeed/%{airline_code}/?tail_number=%{tail_number}&locale=%{locale}&version=2.0&cache_flag=0"
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
    When I send a GBP Lite GET request to "/edge/data/blogfeed/%{airline_code}/?tail_number=%{tail_number}&locale=%{locale}&version=2.0&cache_flag=0"
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
    When I send a GBP Lite GET request to "/edge/data/blogfeed/%{airline_code}/?locale=%{locale}&version=2.0&cache_flag=0"
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
    When I send a GBP Lite GET request to "/edge/data/blogfeed/INVALID/?tail_number=%{tail_number}&locale=%{locale}&version=2.0&cache_flag=0"
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                |
      | status_message | Bad Request                        |
      | error_code     | EDG001                             |
      | error_message  | Unsupported airline code parameter |

  @Positive
  Scenario: Validate that when missing locale in the request URI we default to en_US locale with successful response
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/blogfeed/%{airline_code}/?tail_number=%{tail_number}&version=2.0&cache_flag=0"
    Then the response status should be "200"
    And the JSON response should be the following:
      | status_code    | 200 |
      | status_message | OK  |

  @Negative
  Scenario: Validate that the proper error code and error message is displayed when missing version in the request URI
    Given I set custom headers:
      | X-Client-ID  | IFC             |
      | X-Request-ID | random          |
      | X-Airline-ID | %{airline_code} |
    When I send a GBP Lite GET request to "/edge/data/blogfeed/%{airline_code}/?tail_number=%{tail_number}&locale=%{locale}&cache_flag=0"
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
    When I send a GBP Lite GET request to "/edge/data/blogfeed/%{airline_code}/?tail_number=%{tail_number}&locale=%{locale}&version=2.0"
    Then the response status should be "400"
    And the JSON response should be the following:
      | status_code    | 400                                                    |
      | status_message | Bad Request                                            |
      | error_code     | EDG001                                                 |
      | error_message  | Required boolean parameter 'cache_flag' is not present |