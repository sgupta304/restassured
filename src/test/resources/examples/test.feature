Feature: As a QE engineer I must be able to test custom cookies in rest get requests

  Scenario: Test custom headers and custom cookies
    Given I set custom headers:
      | hello | world |
    Given I set custom cookies:
      | cookie | monster |
    When I send a GET request to "http://www.google.com"
    Then the response status should be "200"

  Scenario: Test custom headers only
    Given I set custom headers:
      | hello | world |
    When I send a GET request to "http://www.google.com"
    Then the response status should be "200"

  Scenario: Test custom cookies only
    Given I set custom cookies:
      | cookie | monster |
    When I send a GET request to "http://www.google.com"
    Then the response status should be "200"

  Scenario: Test no headers or cookies
    When I send a GET request to "http://www.google.com"
    Then the response status should be "200"

  Scenario: Testing proxy with ABP
    When I send an ABP GET request to "http://www.google.com"
    Then the response status should be "404"

  Scenario: Testing no proxy
    When I send a GET request to "http://www.google.com"
    Then the response status should be "200"

  Scenario: Testing no proxy and proxy in same scenario
    When I send a GET request to "http://www.google.com"
    Then the response status should be "200"
    When I send an ABP GET request to "http://www.google.com"
    Then the response status should be "404"

  Scenario: Testing no proxy proxy and no proxy in that order
    When I send a GET request to "http://www.google.com"
    Then the response status should be "200"
    When I send an ABP GET request to "http://www.google.com"
    Then the response status should be "404"
    When I send a GET request to "http://www.google.com"
    Then the response status should be "200"