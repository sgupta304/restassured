#############################################################################################
# This Feature file will test the the E2E functionality of Roaming Employee Login.
# The following IFS services are tested in this flow:
# GPB
#
# @Author Eric Disrud
# @Date 07/28/2017
#############################################################################################

Feature: Validate Employee Login

  Scenario: Validate a successful MOBILE roaming employee login
    Given I generate a MOBILE GBP SessionId with airlineCode = "ASA", tailNumber = "0ASQE", and deviceMacAddress = "random" and store it at "uxdid"
    Then I generate a roaming login object with uxdid = "%{uxdid}" and realm = "GO_GO"
    Then I send a GBP POST request to "/v2/roaming?method=employee" with the generated body
    Then the response status should be "200"
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | timestamp  |
      | trackingId |
    And the JSON response should have the following data types:
      | statusCode | integer |
      | statusMsg  | string  |
      | timestamp  | long    |
      | trackingId | string  |
    And the JSON response should be the following:
      | statusCode | 200      |
      | statusMsg  | success  |
      | trackingId | %{uxdid} |

  Scenario: Validate a successful LAPTOP roaming employee login
    Given I generate a LAPTOP GBP SessionId with airlineCode = "ASA", tailNumber = "0ASQE", and deviceMacAddress = "random" and store it at "uxdid"
    Then I generate a roaming login object with uxdid = "%{uxdid}" and realm = "GO_GO"
    Then I send a GBP POST request to "/v2/roaming?method=employee" with the generated body
    Then the response status should be "200"
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | timestamp  |
      | trackingId |
    And the JSON response should have the following data types:
      | statusCode | integer |
      | statusMsg  | string  |
      | timestamp  | long    |
      | trackingId | string  |
    And the JSON response should be the following:
      | statusCode | 200      |
      | statusMsg  | success  |
      | trackingId | %{uxdid} |

  @Negative
  Scenario: Validate a MOBILE roaming employee login with an empty email
    Given I generate a MOBILE GBP SessionId with airlineCode = "ASA", tailNumber = "0ASQE", and deviceMacAddress = "random" and store it at "uxdid"
    Then I generate a roaming login object with uxdid = "%{uxdid}" and realm = "GO_GO"
    Then I modify the JSON at "username" to be ""
    Then I send a GBP POST request to "/v2/roaming?method=employee" with the generated body
    Then the response status should be "400"
    And the JSON response should include the following:
      | errorCode  |
      | errorMsg   |
      | statusCode |
      | statusMsg  |
    And the JSON response should have the following data types:
      | errorCode  | string  |
      | errorMsg   | string  |
      | statusCode | integer |
      | statusMsg  | string  |
    And the JSON response should be the following:
      | errorCode  | 1002                                                                 |
      | errorMsg   | [size must be between 1 and 255, UserName must not be null or empty] |
      | statusCode | 400                                                                  |
      | statusMsg  | Bad Request                                                          |

  @Negative
  Scenario: Validate a MOBILE roaming employee login with an empty password
    Given I generate a MOBILE GBP SessionId with airlineCode = "ASA", tailNumber = "0ASQE", and deviceMacAddress = "random" and store it at "uxdid"
    Then I generate a roaming login object with uxdid = "%{uxdid}" and realm = "GO_GO"
    Then I modify the JSON at "password" to be ""
    Then I send a GBP POST request to "/v2/roaming?method=employee" with the generated body
    Then the response status should be "400"
    And the JSON response should include the following:
      | errorCode  |
      | errorMsg   |
      | statusCode |
      | statusMsg  |
    And the JSON response should have the following data types:
      | errorCode  | string  |
      | errorMsg   | string  |
      | statusCode | integer |
      | statusMsg  | string  |
    And the JSON response should be the following:
      | errorCode  | 1002                               |
      | errorMsg   | Password must not be null or empty |
      | statusCode | 400                                |
      | statusMsg  | Bad Request                        |

  @Negative
  Scenario: Validate a MOBILE roaming employee login with an empty xdid
    Given I generate a MOBILE GBP SessionId with airlineCode = "ASA", tailNumber = "0ASQE", and deviceMacAddress = "random" and store it at "uxdid"
    Then I generate a roaming login object with uxdid = "" and realm = "GO_GO"
    Then I send a GBP POST request to "/v2/roaming?method=employee" with the generated body
    Then the response status should be "400"
    And the JSON response should include the following:
      | errorCode  |
      | errorMsg   |
      | statusCode |
      | statusMsg  |
    And the JSON response should have the following data types:
      | errorCode  | string  |
      | errorMsg   | string  |
      | statusCode | integer |
      | statusMsg  | string  |
    And the JSON response should be the following:
      | errorCode  | 1002                            |
      | errorMsg   | UxdId must not be null or empty |
      | statusCode | 400                             |
      | statusMsg  | Bad Request                     |

  @Negative
  Scenario: Validate a MOBILE roaming employee login with an empty realm
    Given I generate a MOBILE GBP SessionId with airlineCode = "ASA", tailNumber = "0ASQE", and deviceMacAddress = "random" and store it at "uxdid"
    Then I generate a roaming login object with uxdid = "%{uxdid}" and realm = ""
    Then I send a GBP POST request to "/v2/roaming?method=employee" with the generated body
    Then the response status should be "400"
    And the JSON response should include the following:
      | errorCode  |
      | errorMsg   |
      | statusCode |
      | statusMsg  |
    And the JSON response should have the following data types:
      | errorCode  | string  |
      | errorMsg   | string  |
      | statusCode | integer |
      | statusMsg  | string  |
    And the JSON response should be the following:
      | errorCode  | 1002                            |
      | errorMsg   | Realm must not be null or empty |
      | statusCode | 400                             |
      | statusMsg  | Bad Request                     |
