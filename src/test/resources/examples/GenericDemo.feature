Feature: This is a Demo Feature File that will show the features of the generic framework

  @Demo
  Scenario: Setting headers to default to application/json
    Given I send and accept JSON

  @Demo
  Scenario: Setting headers to have pre-set values that are configurable
    Given I send "content-type header" and accept "accept header"

  @Demo
  Scenario: Setting headers with a table to be custom configurable headers (This can include customer labeled headers)
    Given I send and accept custom headers:
      | header      | value               |
      | Accept      | accept header value |
      | contentType | contentType value   |

  @Demo
  Scenario: Example of a GET request with assertion for status code
    When I send a GET request to "http://google.com"
    Then the response status should be "200"
    When I send a GET request to "http://google.com" with JSON body:
    """
    {"testing":"json"}
    """
    Then the response status should be "400"
    When I send a GET request to "http://google.com#q=hello"
    Then the response status should be "200"

  @Demo
  Scenario: Testing a GET request that has JSON response
    When I send a GET request to "http://ifsutils.ifs.dev.gogoair.com/v1/bypassrule/airlines"
    Then the response status should be "200"
    And the response headers should be JSON

  @Demo
  Scenario: Testing a GET request that has JSON response from a custom header
    When I send a GET request to "http://ifsutils.ifs.dev.gogoair.com/v1/bypassrule/airlines"
    Then the response status should be "200"
    And the response headers should be "application/json;charset=UTF-8"

  @Demo
  Scenario: Testing a GET request for a complete custom header
    When I send a GET request to "http://ifsutils.ifs.dev.gogoair.com/v1/bypassrule/airlines"
    Then the response status should be "200"
    And the "Content-Type" header should be "application/json;charset=UTF-8"

  @Demo
  Scenario: Testing not null response
    When I send a GET request to "http://ifsutils.ifs.dev.gogoair.com/v1/bypassrule/airlines"
    Then the response status should be "200"
    And the response should not be null

  @Demo
  Scenario: Testing a null response assert returns failing test
    When I send a GET request to "http://ifsutils.ifs.dev.gogoair.com/v1/bypassrule/airlines"
    Then the response status should be "200"
    # UNCOMMENT TO USE THIS ONE
    #And the response should be null

  @Demo
  Scenario: Testing that the collection at a specific JSON path has correct # of items
    When I send a GET request to "http://ifsutils.ifs.dev.gogoair.com/v1/bypassrule/airlines"
    Then the response status should be "200"
    And the JSON response at "list" should have "12"
    And the JSON response at "list" should not have "10"
    # THESE WORK... BUG IN IDEA
    And the JSON response at "list" should have "12" entries
    And the JSON response at "list" should have "12" items
    And the JSON response at "list" should not have "10" entries
    And the JSON response at "list" should not have "10" items

  @Demo
  Scenario: Testing that the collection at a specific JSON path in table has correct # of items
    When I send a GET request to "http://ifsutils.ifs.dev.gogoair.com/v1/bypassrule/airlines"
    Then the response status should be "200"
    And the JSON response should have the following number of entries:
      | list | 12 |
    And the JSON response should not have the following number of entries:
      | list | 10 |

  @Demo
  Scenario: Testing that response does and does not contain JSON single values
    When I send a GET request to "http://ifsutils.ifs.dev.gogoair.com/v1/bypassrule/airlines"
    Then the response status should be "200"
    And the JSON response at "status_code" should be "200"
    And the JSON response at "status_msg" should be "SUCCESS"
    And the JSON response at "status_code" should not be "400"
    And the JSON response at "status_msg" should not be "INCORRECT"

  @Demo
  Scenario: Testing that response does and does not contain JSON values in table
    When I send a GET request to "http://ifsutils.ifs.dev.gogoair.com/v1/bypassrule/airlines"
    Then the response status should be "200"
    And the JSON response should be the following:
      | status_code | 200     |
      | status_msg  | SUCCESS |
    And the JSON response should not be the following:
      | status_code | 400  |
      | status_msg  | FAIL |

  @Demo
  Scenario: Testing that response contains and does not contain single keys
    When I send a GET request to "http://ifsutils.ifs.dev.gogoair.com/v1/bypassrule/airlines"
    Then the response status should be "200"
    And the JSON response should include "status_code"
    And the JSON response should include "status_msg"
    And the JSON response should include "timestamp"
    And the JSON response should not include "id"
    And the JSON response should not include "airline_code"

  @Demo
  Scenario: Testing that response contains and does not contain keys from table
    When I send a GET request to "http://ifsutils.ifs.dev.gogoair.com/v1/bypassrule/airlines"
    Then the response status should be "200"
    And the JSON response should include the following:
      | status_code |
      | status_msg  |
      | timestamp   |
      | list        |
    And the JSON response should not include the following:
      | id           |
      | airline_code |
      | INVALID      |

  @Demo
  Scenario: Testing that the response at key contains and does not contain the proper data type single values
    When I send a GET request to "http://ifsutils.ifs.dev.gogoair.com/v1/bypassrule/airlines"
    Then the response status should be "200"
    And the JSON response at "status_code" should have data type "String"
    And the JSON response at "status_msg" should have data type "String"
    And the JSON response at "list" should have data type "ArrayList"
    And the JSON response at "status_code" should not have data type "Integer"
    And the JSON response at "status_msg" should not have data type "Long"
    And the JSON response at "list" should not have data type "List"

  @Demo
  Scenario: Testing that the response at key contains and does not contain the proper data types in table
    When I send a GET request to "http://ifsutils.ifs.dev.gogoair.com/v1/bypassrule/airlines"
    Then the response status should be "200"
    And the JSON response should have the following data types:
      | status_code | String    |
      | status_msg  | String    |
      | list        | ArrayList |
    And the JSON response should not have the following data types:
      | status_code | Integer |
      | status_msg  | Long    |
      | list        | Arrays  |

  @Demo
  Scenario: Testing saving a value from string and validate in same scenario
    Given I save the String "SUCCESS" as "test"
    When I send a GET request to "http://ifsutils.ifs.dev.gogoair.com/v1/bypassrule/airlines"
    Then the response status should be "200"
    And the JSON response at "status_msg" should be "%{test}"

  @Demo
  Scenario: Testing that we cleared the memory between scenarios
    Given I save the String "ERROR" as "test"
    When I send a GET request to "http://ifsutils.ifs.dev.gogoair.com/v1/bypassrule/airlines"
    Then the response status should be "200"
    And the JSON response at "status_msg" should not be "%{test}"

  @Demo
  Scenario: Testing saving a JSON response and validating with that saved response
    When I send a GET request to "http://ifsutils.ifs.dev.gogoair.com/v1/bypassrule/airlines"
    Then the response status should be "200"
    And I save the JSON at "status_msg" as "test"
    And the JSON response at "status_msg" should be "%{test}"

  @Demo
  Scenario: Testing saved json in a table
    When I send a GET request to "http://ifsutils.ifs.dev.gogoair.com/v1/bypassrule/airlines"
    Then the response status should be "200"
    And I save the JSON at "status_msg" as "test"
    And I save the String "WRONG" as "wrong"
    And the JSON response should be the following:
      | status_msg  | %{test} |
      | status_code | 200     |
      | status_msg  | SUCCESS |
    And the JSON response should not be the following:
      | status_msg | %{wrong} |

  @Demo
  Scenario Outline: Example of a scenario outline to loop through data
    Given I send a POST request to "http://ifsutils.ifs.dev.gogoair.com/v1/bypassrule/airline" with JSON body:
      """
      <body>
      """
    Then the response status should be "400"
    And the JSON response at "status_msg" should be "<error>"

    Examples:
      | body                   | error       |
      | INVALID                | Bad Request |
      | {"airline_code":"ZZZ"} | Bad Request |

  Scenario: Showing how you can put variables that were saved in a REST request
    When I send a POST request to "http://ifsutils.ifs.stage.gogoair.com/v1/bypassrule/airline" with JSON body:
    """
    {
    "active_users": 1,
    "airline_code": "QET",
    "connectivity_type": [
        "ATG"
    ],
    "day_of_week": [
        "MON"
    ],
    "departure": "ALL",
    "destination": "ALL",
    "device_type": [
        "LAPTOP"
    ],
    "effective_date": "2019-04-19T19:33Z",
    "expiration_date": "2020-04-19T13:32Z",
    "region": [
        "DOM"
    ],
    "time_of_day": [
        "AM"
    ],
    "tracking_id": "QE-TrackingID-TEST"
    }
    """
    Then the response status should be "201"
    And I save the JSON at "id" as "ruleId"
    When I send a GET request to "http://ifsutils.ifs.stage.gogoair.com/v1/bypassrule/airline/id/%{ruleId}"
    Then the response status should be "200"
    When I send a DELETE request to "http://ifsutils.ifs.stage.gogoair.com/v1/bypassrule/airline/id/%{ruleId}"
    Then the response status should be "200"

  Scenario: Testing saving a variable from a generated object in memory so we can use in later parts of scenario:
    Given I generate a uxdId for tail "0VIR2" and save as "uxdid"
    And I save the generated JSON at "expireTime" as "time"
    And I print the stored value at "time"
    When I send a CloudDao POST request to "/v2/token/%{uxdid}" with the generated body
    Then the response status should be "201"
    And I print the stored value at "time"

  Scenario: Testing some variables in URLs that have special chars
    Given I generate an object with the following attributes:
      | ip    | 10.10.10.10       |
      | mac   | 45:a5:00:00:00:00 |
      | name  | Eric Disrud       |
      | name2 | Brian DeSimone    |
    And I save the generated JSON at "ip" as "ip"
    And I save the generated JSON at "mac" as "mac"
    And I save the generated JSON at "name" as "name"
    And I save the generated JSON at "name2" as "name2"
    When I send a GET request to "http://google.com?%{ip}"
    Then the response status should be "200"
    And I print the stored value at "ip"
    Given I save the String "12.12.12.12" as "ip2"
    When I send a GET request to "http://google.com?%{ip2}"
    Then the response status should be "200"
    And I print the stored value at "ip2"

  Scenario: Gen uxdid by seperate calls
    When I send a FLIGHTINFO GET request to "/v1/tail/0VIR2"
    Then the response status should be "200"
    Given I generate a SimpleFlightInfo object with the REQUIRED attributes for tail "0VIR2"
    And I generate a Token object with the REQUIRED attributes for tail "0VIR2"

  Scenario: Gen and post uxdid
    Given I generate a uxdId for tail "0VIR2" and save as "uxdid"
    When I send a CloudDao POST request to "/v2/token/%{uxdid}" with the generated body
    Then the response status should be "201"
    And the JSON response at "trackingId" should be "%{uxdid}"
    And I print the stored value at "uxdid"

  Scenario: Generate a customer and post it
    Given I generate a uxdId for tail "0VIR2" and save as "uxdid"
    When I send a CloudDao POST request to "/v2/token/%{uxdid}" with the generated body
    Then the response status should be "201"
    And the JSON response at "trackingId" should be "%{uxdid}"
    And I print the stored value at "uxdid"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    And I print the stored value at "userId"

  Scenario: Generate an authenticate user object and authenticate a user
    Given I generate a uxdId for tail "0VIR2" and save as "uxdid"
    When I send a CloudDao POST request to "/v2/token/%{uxdid}" with the generated body
    Then the response status should be "201"
    Given I generate a customer with email = "bdesimone1@test.com" and password = "testpassword"
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    Given I generate a uxdId for tail "0VIR2" and save as "uxdid"
    When I send a CloudDao POST request to "/v2/token/%{uxdid}" with the generated body
    Then the response status should be "201"
    Given I generate an authenticate object with username = "bdesimone1@test.com", password = "testpassword", and uxdId = "uxdid"
    When I send an APIDecorator POST request to "/v2/customer/authenticate" with the generated body
    Then the response status should be "200"