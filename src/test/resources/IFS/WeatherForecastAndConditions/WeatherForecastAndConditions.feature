#############################################################################################
# This Feature file will test the the E2E functionality of Weather Forecast and Conditions
# The following IFS services are tested in this flow
#
# @Author Eric Disrud
# @Date 05/09/2017
#############################################################################################
@WeatherForecast
Feature: Validate Weather Forecast and Conditions

# /v2/weather/conditions/{airportCode} ========================================================

  @HealthCheck
  Scenario: Verify response status code is 200 for a domestic airportCode. (smoke test)
    Given I send a CPAPI GET request to "/v2/weather/conditions/KORD"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Verify response status code is 200 for an international airportCode. (smoke test)
    Given I send a CPAPI GET request to "/v2/weather/conditions/RJAA"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate API returns proper headers on successful request for a domestic airportCode
    Given I send a CPAPI GET request to "/v2/weather/conditions/KORD"
    Then the response status should be "200"
    And the response headers should be JSON

  @HealthCheck
  Scenario: Validate API returns proper headers on successful request for an international airportCode
    Given I send a CPAPI GET request to "/v2/weather/conditions/BIRL"
    Then the response status should be "200"
    And the response headers should be JSON

  @HealthCheck
  Scenario Outline: Validate proper translation of city to Japanese when locale is ja_JP
    Given I send a CPAPI GET request to "/v2/weather/conditions/<airportCode>/?locale=ja_JP"
    Then the response status should be "200"
    And the JSON response at "city" should be "<translation>"
    Examples:
      | translation | airportCode |
      | 秋田          | RJSK        |
      | 奄美          | RJKA        |
      | 青森          | RJSA        |
      | 旭川          | RJEC        |
      | シカゴ         | KORD        |
      | 福岡          | RJFF        |
      | 福島          | RJSF        |
      | 函館          | RJCH        |
      | 花巻          | RJSI        |
      | 広島          | RJOA        |
      | 硫黄島         | RJAW        |
      | 石垣          | ROIG        |
      | 出雲          | RJOC        |
      | 鹿児島         | RJFK        |
      | 喜界島         | RJKI        |
      | 北大東         | RORK        |
      | 北九州         | RJFR        |
      | 神戸          | RJBE        |
      | 高知          | RJOK        |
      | 金沢          | RJNK        |
      | 熊本          | RJFT        |
      | 久米島         | ROKJ        |
      | 釧路          | RJCK        |
      | 松本          | RJAF        |
      | 松山          | RJOM        |
      | 女満別         | RJCM        |
      | 三沢          | RJSM        |
      | 宮古          | ROMY        |
      | 宮古          | ROMY        |
      | 宮崎          | RJFM        |
      | 長崎          | RJFU        |
      | 名古屋(中部)     | RJNA        |
      | 南紀白浜        | RJBD        |
      | 新潟          | RJSN        |
      | 新潟          | RJSN        |
      | 帯広          | RJCB        |
      | 大分          | RJFO        |
      | 岡山          | RJOB        |
      | 隠岐          | RJNO        |
      | 沖縄(那覇)      | ROAH        |
      | 奥尻          | RJEO        |
      | 大阪          | RJOO        |
      | 大阪          | RJBB        |
      | 利尻          | RJER        |
      | 札幌(新千歳)     | RJCC        |
      | 仙台          | RJSS        |
      | 静岡          | RJNS        |
      | 但馬          | RJBT        |
      | 高松          | RJOT        |
      | 種子島         | RJFG        |
      | 徳之島         | RJKN        |
      | 徳島          | RJOS        |
      | 東京          | RJTT        |
      | 東京          | RJAA        |
      | 屋久島         | RJFC        |
      | 山口          | RJDC        |
      | 与那国         | ROYN        |
      | 与論          | RORY        |

  @Positive
  Scenario Outline:  Validate that all locales return 200s for domestic airportCodes
    Given I send a CPAPI GET request to "/v2/weather/conditions/KORD?locale=<locale>"
    Then the response status should be "200"
    Examples:
      | locale |
      | en_US  |
      | en_GB  |
      | es_MX  |
      | es_ES  |
      | fr_CA  |
      | pt_BR  |
      | ja_JP  |
      | es_BO  |

  @Positive
  Scenario Outline:  Validate that all locales return 200s for international airportCodes
    Given I send a CPAPI GET request to "/v2/weather/conditions/BIRL?locale=<locale>"
    Then the response status should be "200"
    Examples:
      | locale |
      | en_US  |
      | en_GB  |
      | es_MX  |
      | es_ES  |
      | fr_CA  |
      | pt_BR  |
      | ja_JP  |
      | es_BO  |

  @Negative
  Scenario: Verify that an invalid airportCode returns proper error code and JSON
    Given I send a CPAPI GET request to "/v2/weather/conditions/INVALID"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                    |
      | statusMsg  | Bad Request            |
      | errorCode  | 1112                   |
      | errorMsg   | airportCode is invalid |

  @Negative
  Scenario: Verify that an unknown airportCode returns proper error code and JSON
    Given I send a CPAPI GET request to "/v2/weather/conditions/XXXX"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                         |
      | statusMsg  | Bad Request                 |
      | errorCode  | 1002                        |
      | errorMsg   | external api request failed |

  @Positive
  Scenario: Verify that F scale returns a 200 and scale is in Fahrenheit for a domestic airport
    Given I send a CPAPI GET request to "/v2/weather/conditions/KORD?scale=F"
    Then the response status should be "200"
    And the JSON response at "scale" should be "F"

  @Positive
  Scenario: Verify that F scale returns a 200 and scale is in Fahrenheit for an international airport
    Given I send a CPAPI GET request to "/v2/weather/conditions/BIRL?scale=F"
    Then the response status should be "200"
    And the JSON response at "scale" should be "F"

  @Positive
  Scenario: Verify that C scale returns a 200 and scale is in Celsius for a domestic airport
    Given I send a CPAPI GET request to "/v2/weather/conditions/KORD?scale=C"
    Then the response status should be "200"
    And the JSON response at "scale" should be "C"

  @Positive
  Scenario: Verify that C scale returns a 200 and scale is in Celsius for an international airport
    Given I send a CPAPI GET request to "/v2/weather/conditions/BIRL?scale=C"
    Then the response status should be "200"
    And the JSON response at "scale" should be "C"

  @Negative
  Scenario: Verify that an invalid scale returns a 400 with proper error code and JSON for a domestic airport
    Given I send a CPAPI GET request to "/v2/weather/conditions/KORD?scale=INVALID"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                        |
      | statusMsg  | Bad Request                |
      | errorCode  | 1001                       |
      | errorMsg   | invalid/missing input data |

  @Negative
  Scenario: Verify that an invalid scale returns a 400 with proper error code and JSON for an international airport
    Given I send a CPAPI GET request to "/v2/weather/conditions/BIRL?scale=INVALID"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                        |
      | statusMsg  | Bad Request                |
      | errorCode  | 1001                       |
      | errorMsg   | invalid/missing input data |

  @Negative
  Scenario: Verify that an invalid locale returns a 400 with proper error code and JSON for a domestic airport
    Given I send a CPAPI GET request to "/v2/weather/conditions/KORD?locale=INVALID"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                        |
      | statusMsg  | Bad Request                |
      | errorCode  | 1111                       |
      | errorMsg   | locale/language is invalid |

  @Negative
  Scenario: Verify that an invalid locale returns a 400 with proper error code and JSON for an international airport
    Given I send a CPAPI GET request to "/v2/weather/conditions/BIRL?locale=INVALID"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                        |
      | statusMsg  | Bad Request                |
      | errorCode  | 1111                       |
      | errorMsg   | locale/language is invalid |

  @Negative
  Scenario: Verify that an unknown locale returns a 400 with proper error code and JSON for a domestic airport
    Given I send a CPAPI GET request to "/v2/weather/conditions/KORD?locale=xx_XX"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                       |
      | statusMsg  | Bad Request               |
      | errorCode  | 1110                      |
      | errorMsg   | Weather response is empty |

  @Negative
  Scenario: Verify that an unknown locale returns a 400 with proper error code and JSON for an international airport
    Given I send a CPAPI GET request to "/v2/weather/conditions/BIRL?locale=xx_XX"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                       |
      | statusMsg  | Bad Request               |
      | errorCode  | 1110                      |
      | errorMsg   | Weather response is empty |

# /v2/weather/forecast/{airportCode} ========================================================

  @HealthCheck
  Scenario: Verify response status code is 200 for a domestic airportCode. (Smoke Test)
    Given I send a CPAPI GET request to "/v2/weather/forecast/KORD"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Verify response status code is 200 for an international airportCode. (Smoke Test)
    Given I send a CPAPI GET request to "/v2/weather/forecast/BIRL"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Verify headers for a domestic airportCode.
    Given I send a CPAPI GET request to "/v2/weather/forecast/KORD"
    Then the response status should be "200"
    And the response headers should be JSON

  @HealthCheck
  Scenario: Verify headers for an international airportCode.
    Given I send a CPAPI GET request to "/v2/weather/forecast/BIRL"
    Then the response status should be "200"
    And the response headers should be JSON

  @Positive
  Scenario Outline: Validate that all locales return 200s for domestic airportCodes
    Given I send a CPAPI GET request to "/v2/weather/forecast/KORD?locale=<locale>"
    Then the response status should be "200"
    Examples:
      | locale |
      | en_US  |
      | en_GB  |
      | es_MX  |
      | es_ES  |
      | fr_CA  |
      | pt_BR  |
      | ja_JP  |
      | es_BO  |

  @Positive
  Scenario Outline: Validate that all locales return 200s for international airportCodes
    Given I send a CPAPI GET request to "/v2/weather/forecast/BIRL?locale=<locale>"
    Then the response status should be "200"
    Examples:
      | locale |
      | en_US  |
      | en_GB  |
      | es_MX  |
      | es_ES  |
      | fr_CA  |
      | pt_BR  |
      | ja_JP  |
      | es_BO  |

  @Positive
  Scenario: Verify that F scale returns a 200 and scale is in Fahrenheit for a domestic airport
    Given I send a CPAPI GET request to "/v2/weather/forecast/KORD?scale=F"
    Then the response status should be "200"
    And the JSON response at "scale" should be "F"

  @Positive
  Scenario: Verify that F scale returns a 200 and scale is in Fahrenheit for an international airport
    Given I send a CPAPI GET request to "/v2/weather/forecast/BIRL?scale=F"
    Then the response status should be "200"
    And the JSON response at "scale" should be "F"

  @Positive
  Scenario: Verify that C scale returns a 200 and scale is in Celsius for a domestic airport
    Given I send a CPAPI GET request to "/v2/weather/forecast/KORD?scale=C"
    Then the response status should be "200"
    And the JSON response at "scale" should be "C"

  @Positive
  Scenario: Verify that C scale returns a 200 and scale is in Celsius for an international airport
    Given I send a CPAPI GET request to "/v2/weather/forecast/BIRL?scale=C"
    Then the response status should be "200"
    And the JSON response at "scale" should be "C"

  @Negative
  Scenario: Verify that an invalid scale returns a 400 with proper error code and JSON for a domestic airport
    Given I send a CPAPI GET request to "/v2/weather/forecast/KORD?scale=INVALID"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                        |
      | statusMsg  | Bad Request                |
      | errorCode  | 1001                       |
      | errorMsg   | invalid/missing input data |

  @Negative
  Scenario: Verify that an invalid scale returns a 400 with proper error code and JSON for an international airport
    Given I send a CPAPI GET request to "/v2/weather/forecast/BIRL?scale=INVALID"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                        |
      | statusMsg  | Bad Request                |
      | errorCode  | 1001                       |
      | errorMsg   | invalid/missing input data |

  @Negative
  Scenario: Verify that an invalid locale returns a 400 with proper error code and JSON for a domestic airport
    Given I send a CPAPI GET request to "/v2/weather/forecast/KORD?locale=INVALID"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                        |
      | statusMsg  | Bad Request                |
      | errorCode  | 1111                       |
      | errorMsg   | locale/language is invalid |

  @Negative
  Scenario: Verify that an invalid locale returns a 400 with proper error code and JSON for an international airport
    Given I send a CPAPI GET request to "/v2/weather/forecast/BIRL?locale=INVALID"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                        |
      | statusMsg  | Bad Request                |
      | errorCode  | 1111                       |
      | errorMsg   | locale/language is invalid |

  @Negative
  Scenario: Verify that an unknown locale returns a 400 with proper error code and JSON for a domestic airport
    Given I send a CPAPI GET request to "/v2/weather/forecast/KORD?locale=xx_XX"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                       |
      | statusMsg  | Bad Request               |
      | errorCode  | 1110                      |
      | errorMsg   | Weather response is empty |

  @Negative
  Scenario: Verify that an unknown locale returns a 400 with proper error code and JSON for an international airport
    Given I send a CPAPI GET request to "/v2/weather/forecast/BIRL?locale=xx_XX"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                       |
      | statusMsg  | Bad Request               |
      | errorCode  | 1110                      |
      | errorMsg   | Weather response is empty |

  @Negative
  Scenario: Verify that an invalid airportCode returns proper error code and JSON
    Given I send a CPAPI GET request to "/v2/weather/forecast/INVALID"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                    |
      | statusMsg  | Bad Request            |
      | errorCode  | 1112                   |
      | errorMsg   | airportCode is invalid |

  @Negative
  Scenario: Verify that an unknown airportCode returns proper error code and JSON
    Given I send a CPAPI GET request to "/v2/weather/forecast/XXXX"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                         |
      | statusMsg  | Bad Request                 |
      | errorCode  | 1002                        |
      | errorMsg   | external api request failed |

# /v2/weather/full/{airportCode} ========================================================

  @HealthCheck
  Scenario: Verify response status code is 200 for a domestic airportCode. (smoke test)
    Given I send a CPAPI GET request to "/v2/weather/full/KORD"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Verify response status code is 200 for an international airportCode. (smoke test)
    Given I send a CPAPI GET request to "/v2/weather/full/BIRL"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Verify headers for a domestic airportCode. (smoke test)
    Given I send a CPAPI GET request to "/v2/weather/full/KORD"
    Then the response status should be "200"
    And the response headers should be JSON

  @HealthCheck
  Scenario: Verify headers for an international airportCode. (smoke test)
    Given I send a CPAPI GET request to "/v2/weather/full/BIRL"
    Then the response status should be "200"
    And the response headers should be JSON

  @HealthCheck
  Scenario Outline: Validate proper translation of city to Japanese when locale is ja_JP
    Given I send a CPAPI GET request to "/v2/weather/full/<airportCode>/?locale=ja_JP"
    Then the response status should be "200"
    And the JSON response at "currentConditions.city" should be "<translation>"
    Examples:
      | translation | airportCode |
      | 秋田          | RJSK        |
      | 奄美          | RJKA        |
      | 青森          | RJSA        |
      | 旭川          | RJEC        |
      | シカゴ         | KORD        |
      | 福岡          | RJFF        |
      | 福島          | RJSF        |
      | 函館          | RJCH        |
      | 花巻          | RJSI        |
      | 広島          | RJOA        |
      | 硫黄島         | RJAW        |
      | 石垣          | ROIG        |
      | 出雲          | RJOC        |
      | 鹿児島         | RJFK        |
      | 喜界島         | RJKI        |
      | 北大東         | RORK        |
      | 北九州         | RJFR        |
      | 神戸          | RJBE        |
      | 高知          | RJOK        |
      | 金沢          | RJNK        |
      | 熊本          | RJFT        |
      | 久米島         | ROKJ        |
      | 釧路          | RJCK        |
      | 松本          | RJAF        |
      | 松山          | RJOM        |
      | 女満別         | RJCM        |
      | 三沢          | RJSM        |
      | 宮古          | ROMY        |
      | 宮古          | ROMY        |
      | 宮崎          | RJFM        |
      | 長崎          | RJFU        |
      | 名古屋(中部)     | RJNA        |
      | 南紀白浜        | RJBD        |
      | 新潟          | RJSN        |
      | 新潟          | RJSN        |
      | 帯広          | RJCB        |
      | 大分          | RJFO        |
      | 岡山          | RJOB        |
      | 隠岐          | RJNO        |
      | 沖縄(那覇)      | ROAH        |
      | 奥尻          | RJEO        |
      | 大阪          | RJOO        |
      | 大阪          | RJBB        |
      | 利尻          | RJER        |
      | 札幌(新千歳)     | RJCC        |
      | 仙台          | RJSS        |
      | 静岡          | RJNS        |
      | 但馬          | RJBT        |
      | 高松          | RJOT        |
      | 種子島         | RJFG        |
      | 徳之島         | RJKN        |
      | 徳島          | RJOS        |
      | 東京          | RJTT        |
      | 東京          | RJAA        |
      | 屋久島         | RJFC        |
      | 山口          | RJDC        |
      | 与那国         | ROYN        |
      | 与論          | RORY        |

  @HealthCheck
  Scenario Outline:  Validate that all locales return 200s for domestic airportCodes
    Given I send a CPAPI GET request to "/v2/weather/full/KORD/?locale=<locale>"
    Then the response status should be "200"
    Examples:
      | locale |
      | en_US  |
      | en_GB  |
      | es_MX  |
      | es_ES  |
      | fr_CA  |
      | pt_BR  |
      | ja_JP  |
      | es_BO  |

  @HealthCheck
  Scenario Outline:  Validate that all locales return 200s for international airportCodes
    Given I send a CPAPI GET request to "/v2/weather/full/BIRL/?locale=<locale>"
    Then the response status should be "200"
    Examples:
      | locale |
      | en_US  |
      | en_GB  |
      | es_MX  |
      | es_ES  |
      | fr_CA  |
      | pt_BR  |
      | ja_JP  |
      | es_BO  |

  @Negative
  Scenario: Verify that an invalid airportCode returns proper error code and JSON
    Given I send a CPAPI GET request to "/v2/weather/full/INVALID"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                    |
      | statusMsg  | Bad Request            |
      | errorCode  | 1112                   |
      | errorMsg   | airportCode is invalid |

  @Negative
  Scenario: Verify that an unknown airportCode returns proper error code and JSON
    Given I send a CPAPI GET request to "/v2/weather/full/XXXX"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                         |
      | statusMsg  | Bad Request                 |
      | errorCode  | 1002                        |
      | errorMsg   | external api request failed |

  @Positive
  Scenario: Verify that F scale returns a 200 and scale is in Fahrenheit for a domestic airport
    Given I send a CPAPI GET request to "/v2/weather/full/KORD/?scale=F"
    Then the response status should be "200"
    And the JSON response at "currentConditions.scale" should be "F"

  @Positive
  Scenario: Verify that F scale returns a 200 and scale is in Fahrenheit for an international airport
    Given I send a CPAPI GET request to "/v2/weather/full/BIRL/?scale=F"
    Then the response status should be "200"
    And the JSON response at "currentConditions.scale" should be "F"

  @Positive
  Scenario: Verify that C scale returns a 200 and scale is in Celsius for a domestic airport
    Given I send a CPAPI GET request to "/v2/weather/full/KORD/?scale=C"
    Then the response status should be "200"
    And the JSON response at "currentConditions.scale" should be "C"

  @Positive
  Scenario: Verify that C scale returns a 200 and scale is in Celsius for an international airport
    Given I send a CPAPI GET request to "/v2/weather/full/BIRL/?scale=C"
    Then the response status should be "200"
    And the JSON response at "currentConditions.scale" should be "C"

  @Negative
  Scenario: Verify that an invalid scale returns a 400 with proper error code and JSON for a domestic airport
    Given I send a CPAPI GET request to "/v2/weather/full/KORD/?scale=INVALID"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                        |
      | statusMsg  | Bad Request                |
      | errorCode  | 1001                       |
      | errorMsg   | invalid/missing input data |

  @Negative
  Scenario: Verify that an invalid scale returns a 400 with proper error code and JSON for an international airport
    Given I send a CPAPI GET request to "/v2/weather/full/BIRL/?scale=INVALID"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                        |
      | statusMsg  | Bad Request                |
      | errorCode  | 1001                       |
      | errorMsg   | invalid/missing input data |

  @Negative
  Scenario: Verify that an invalid locale returns a 400 with proper error code and JSON for a domestic airport
    Given I send a CPAPI GET request to "/v2/weather/full/KORD/?locale=INVALID"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                        |
      | statusMsg  | Bad Request                |
      | errorCode  | 1111                       |
      | errorMsg   | locale/language is invalid |

  @Negative
  Scenario: Verify that an invalid locale returns a 400 with proper error code and JSON for an international airport
    Given I send a CPAPI GET request to "/v2/weather/full/BIRL/?locale=INVALID"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                        |
      | statusMsg  | Bad Request                |
      | errorCode  | 1111                       |
      | errorMsg   | locale/language is invalid |

  @Negative
  Scenario: Verify that an unknown locale returns a 400 with proper error code and JSON for a domestic airport
    Given I send a CPAPI GET request to "/v2/weather/full/KORD/?locale=xx_XX"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                       |
      | statusMsg  | Bad Request               |
      | errorCode  | 1110                      |
      | errorMsg   | Weather response is empty |

  @Negative
  Scenario: Verify that an unknown locale returns a 400 with proper error code and JSON for an international airport
    Given I send a CPAPI GET request to "/v2/weather/full/BIRL/?locale=xx_XX"
    Then the response status should be "400"
    And the response headers should be JSON
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | String |
      | statusMsg  | String |
      | errorCode  | String |
      | errorMsg   | String |
    And the JSON response should be the following:
      | statusCode | 400                       |
      | statusMsg  | Bad Request               |
      | errorCode  | 1110                      |
      | errorMsg   | Weather response is empty |