#############################################################################################
# This Feature file will test the the E2E functionality of Video Service Availability Service
# The following IFS services are tested in this flow
#
# @Author Ravneet Sidhu
# @Refactor Brian DeSimone 04/03/2018
# @Date 05/09/2017
#############################################################################################
@VSA @Regression
Feature: Validate VSA

  Background: Set up the Flight Information
    Given I set the following attributes in memory:
      | airline_code  | QET    |
      | tail_number   | 0QET2  |
      | flight_number | QET123 |

  @HealthCheck
  Scenario: Validate successful request returns proper response code
    Given I generate an ASP object to enable video service
    When I send a GBP Lite VSA request to "/promotionInfo.do"
    Then the response status should be "201"
    When I send a GBP Lite GET request to "/v1/vsa/%{tail_number}"
    Then the response status should be "200"
    When I send a IFSUTILS DELETE request to "/v1/vsa/tail/%{tail_number}/locale/en_US"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate successful request returns the proper schema, headers, data types, and data
    Given I generate an ASP object to enable video service
    When I send a GBP Lite VSA request to "/promotionInfo.do"
    Then the response status should be "201"
    When I send a GBP Lite GET request to "/v1/vsa/%{tail_number}"
    Then the response status should be "200"
    And the response headers should be JSON
    And the JSON response should include the following:
      | TailInfo                 |
      | TailInfo[0].tailNumber   |
      | TailInfo[0].source       |
      | TailInfo[0].locale       |
      | TailInfo[0].availability |
    And the JSON response should have the following data types:
      | TailInfo                 | ArrayList |
      | TailInfo[0].tailNumber   | String    |
      | TailInfo[0].source       | String    |
      | TailInfo[0].locale       | String    |
      | TailInfo[0].availability | String    |
    And the JSON response should be the following:
      | TailInfo[0].tailNumber   | %{tail_number} |
      | TailInfo[0].source       | ASP            |
      | TailInfo[0].locale       | en_US          |
      | TailInfo[0].availability | Y              |
    When I send a IFSUTILS DELETE request to "/v1/vsa/tail/%{tail_number}/locale/en_US"
    Then the response status should be "200"

  @Positive
  Scenario: Validate airline video availability matches between GBPLite and IFSUTILS when video enabled
    Given I generate an ASP object to enable video service
    When I send a GBP Lite VSA request to "/promotionInfo.do"
    Then the response status should be "201"
    When I send a GBP Lite GET request to "/v1/vsa/%{tail_number}"
    Then the response status should be "200"
    And I save the position in collection "TailInfo" of "tailNumber" = "%{tail_number}" at "position"
    And the JSON response should be the following:
      | TailInfo[%{position}].tailNumber   | %{tail_number} |
      | TailInfo[%{position}].source       | ASP            |
      | TailInfo[%{position}].locale       | en_US          |
      | TailInfo[%{position}].availability | Y              |
    When I send a IFSUTILS GET request to "/v1/vsa/tail/%{tail_number}"
    And I save the position in collection "tailInfos" of "tailNumber" = "%{tail_number}" at "position"
    And the JSON response should be the following:
      | tailInfos[%{position}].tailNumber   | %{tail_number} |
      | tailInfos[%{position}].source       | ASP            |
      | tailInfos[%{position}].locale       | en_US          |
      | tailInfos[%{position}].activeStatus | true           |
    When I send a IFSUTILS DELETE request to "/v1/vsa/tail/%{tail_number}/locale/en_US"
    Then the response status should be "200"

  @Positive
  Scenario: Validate airline video availability matches between GBPLite and IFSUTILS when video disabled
    Given I generate an ASP object to disable video service
    When I send a GBP Lite VSA request to "/promotionInfo.do"
    Then the response status should be "201"
    When I send a GBP Lite GET request to "/v1/vsa/%{tail_number}"
    Then the response status should be "200"
    And I save the position in collection "TailInfo" of "tailNumber" = "%{tail_number}" at "position"
    And the JSON response should be the following:
      | TailInfo[%{position}].tailNumber   | %{tail_number} |
      | TailInfo[%{position}].source       | ASP            |
      | TailInfo[%{position}].locale       | en_US          |
      | TailInfo[%{position}].availability | N              |
    When I send a IFSUTILS GET request to "/v1/vsa/tail/%{tail_number}"
    And I save the position in collection "tailInfos" of "tailNumber" = "%{tail_number}" at "position"
    And the JSON response should be the following:
      | tailInfos[%{position}].tailNumber   | %{tail_number} |
      | tailInfos[%{position}].source       | ASP            |
      | tailInfos[%{position}].locale       | en_US          |
      | tailInfos[%{position}].activeStatus | false          |
    When I send a IFSUTILS DELETE request to "/v1/vsa/tail/%{tail_number}/locale/en_US"
    Then the response status should be "200"

  @Positive
  Scenario: Validate video availability for for airline with manually configured tails in IFSUTILS
    Given I generate a VSA Airline Object to disable video service
    When I send an IFSUTILS POST request to "/v1/vsa/airline" with the generated body
    Then the response status should be "201"
    Given I generate a VSA Tail Object to disable video service
    When I send an IFSUTILS POST request to "/v1/vsa/tail" with the generated body
    Then the response status should be "201"
    When I send a GBP Lite GET request to "/v1/vsa/%{tail_number}"
    Then the response status should be "200"
    And the JSON response should be the following:
      | TailInfo[0].tailNumber   | 0QET2  |
      | TailInfo[0].source       | MANUAL |
      | TailInfo[0].locale       | en_US  |
      | TailInfo[0].availability | N      |
    When I send a IFSUTILS DELETE request to "/v1/vsa/tail/%{tail_number}/locale/en_US"
    Then the response status should be "200"

  @Negative
  Scenario: Validate video availability N/A and no data found when no tail number found
    When I send a GBP Lite GET request to "/v1/vsa/INVALID"
    Then the response status should be "404"
    And the JSON response should be the following:
      | availability | NA |
    When I send a IFSUTILS GET request to "/v1/vsa/tail/INVALID"
    Then the response status should be "404"
    And the JSON response should be the following:
      | statusCode | 404           |
      | statusMsg  | No Data Found |