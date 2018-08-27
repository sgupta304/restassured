#############################################################################################
# This Feature file will test the the E2E functionality of Device Info.
# The following IFS services are tested in this flow:
# GPB
# API Decorator
# CloudDao
# IFS Utils
#
# @Author Eric Disrud
# @Date 05/16/2017
#############################################################################################
@DeviceInfo
Feature: Validate Device Info


  Scenario: Validate Device Info is created when a laptop GBP session is generated and the splash page is loaded
    When I generate a laptop GBP SessionId with airlineCode = "DAL", tailNumber = "0DAL2", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ipAddress"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "macAddress"
    Then I simulate a splash page load with uxdId: "%{uxdid}"
    Then I send an IFSUTILS GET request to "/v1/deviceinfo/mac/%{macAddress}"
    And the response status should be "200"
    Then I verify the S3 bucket with "%{ipAddress}" and "%{macAddress}"
    And the response status should be "200"


  Scenario: Validate Device Info is created when a mobile GBP session is generated and the splash page is loaded
    When I generate a mobile GBP SessionId with airlineCode = "DAL", tailNumber = "0DAL2", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ipAddress"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "macAddress"
    Then I simulate a splash page load with uxdId: "%{uxdid}"
    Then I send an IFSUTILS GET request to "/v1/deviceinfo/mac/%{macAddress}"
    And the response status should be "200"
    Then I verify the S3 bucket with "%{ipAddress}" and "%{macAddress}"
    And the response status should be "200"


  Scenario: Validate Device Info is correct when a laptop GBP session is generated and the splash page is loaded
    When I generate a laptop GBP SessionId with airlineCode = "DAL", tailNumber = "0DAL2", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ipAddress"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "macAddress"
    Then I simulate a splash page load with uxdId: "%{uxdid}"
    Then I send an IFSUTILS GET request to "/v1/deviceinfo/mac/%{macAddress}"
    And the response status should be "200"
    And the JSON response should include the following:
      | [0].ip_address   |
      | [0].mac_address  |
      | [0].tail_num     |
      | [0].airline_iata |
      | [0].ua_string    |
      | [0].jsession_id  |
      | [0].origin_iata  |
      | [0].dest_iata    |
      | [0].flight_info  |
      | [0].device_type  |
      | [0].ins_date     |
    And the JSON response should have the following data types:
      | [0].ip_address   | String |
      | [0].mac_address  | String |
      | [0].tail_num     | String |
      | [0].airline_iata | String |
      | [0].ua_string    | String |
      | [0].jsession_id  | String |
      | [0].origin_iata  | String |
      | [0].dest_iata    | String |
      | [0].flight_info  | String |
      | [0].device_type  | String |
      | [0].ins_date     | String |
    And the response headers should be "application/json;charset=UTF-8"
    And the JSON response should be the following:
      | [0].ip_address  | %{ipAddress}  |
      | [0].mac_address | %{macAddress} |
      | [0].tail_num    | 0DAL2         |
      | [0].jsession_id | %{uxdid}      |
      | [0].device_type | LAPTOP        |
    Then I verify the S3 bucket with "%{ipAddress}" and "%{macAddress}"
    And the response status should be "200"
    And the JSON response should include the following:
      | ip_address   |
      | mac_address  |
      | tail_num     |
      | airline_iata |
      | ua_string    |
      | jsession_id  |
      | origin_iata  |
      | dest_iata    |
      | flight_info  |
      | device_type  |
      | ins_date     |
    And the JSON response should have the following data types:
      | ip_address   | String |
      | mac_address  | String |
      | tail_num     | String |
      | airline_iata | String |
      | ua_string    | String |
      | jsession_id  | String |
      | origin_iata  | String |
      | dest_iata    | String |
      | flight_info  | String |
      | device_type  | String |
      | ins_date     | String |
    And the JSON response should be the following:
      | ip_address   | %{ipAddress}  |
      | mac_address  | %{macAddress} |
      | tail_num     | 0DAL2         |
      | airline_iata | DL            |
      | jsession_id  | %{uxdid}      |
      | device_type  | LAPTOP        |


  Scenario: Validate device info is updated after a successful purchase
    Given I generate a laptop GBP SessionId with airlineCode = "DAL", tailNumber = "0DAL2", and deviceMacAddress = "random" and store it at "uxdid"
    When I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "macAddress"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ipAddress"
    Then I simulate a splash page load with uxdId: "%{uxdid}"
    Then I send an IFSUTILS GET request to "/v1/deviceinfo/mac/%{macAddress}"
    And the response status should be "200"
    And the JSON response should include the following:
      | [0].ip_address   |
      | [0].mac_address  |
      | [0].tail_num     |
      | [0].airline_iata |
      | [0].ua_string    |
      | [0].jsession_id  |
      | [0].origin_iata  |
      | [0].dest_iata    |
      | [0].flight_info  |
      | [0].device_type  |
      | [0].ins_date     |
    And the JSON response should have the following data types:
      | [0].ip_address   | String |
      | [0].mac_address  | String |
      | [0].tail_num     | String |
      | [0].airline_iata | String |
      | [0].ua_string    | String |
      | [0].jsession_id  | String |
      | [0].origin_iata  | String |
      | [0].dest_iata    | String |
      | [0].flight_info  | String |
      | [0].device_type  | String |
      | [0].ins_date     | String |
    And the response headers should be "application/json;charset=UTF-8"
    And the JSON response should be the following:
      | [0].ip_address  | %{ipAddress}  |
      | [0].mac_address | %{macAddress} |
      | [0].tail_num    | 0DAL2         |
      | [0].jsession_id | %{uxdid}      |
      | [0].device_type | LAPTOP        |
    Then I verify the S3 bucket with "%{ipAddress}" and "%{macAddress}"
    And the response status should be "200"
    And the JSON response should include the following:
      | ip_address   |
      | mac_address  |
      | tail_num     |
      | airline_iata |
      | ua_string    |
      | jsession_id  |
      | origin_iata  |
      | dest_iata    |
      | flight_info  |
      | device_type  |
      | ins_date     |
    And the JSON response should have the following data types:
      | ip_address   | String |
      | mac_address  | String |
      | tail_num     | String |
      | airline_iata | String |
      | ua_string    | String |
      | jsession_id  | String |
      | origin_iata  | String |
      | dest_iata    | String |
      | flight_info  | String |
      | device_type  | String |
      | ins_date     | String |
    And the JSON response should be the following:
      | ip_address   | %{ipAddress}  |
      | mac_address  | %{macAddress} |
      | tail_num     | 0DAL2         |
      | airline_iata | DL            |
      | jsession_id  | %{uxdid}      |
      | device_type  | LAPTOP        |
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the JSON at "plans[0].productCode" as "productCode"
    And I save the JSON at "plans[0].productType" as "productType"
    And I save the JSON at "plans[0].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate a calculate order model for productCode = "%{productCode}", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model for productCode = "%{productCode}", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    When I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "productInfo.serviceId" as "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    Then I send an IFSUTILS GET request to "/v1/deviceinfo/mac/%{macAddress}"
    And the response status should be "200"
    And the JSON response should include the following:
      | [0].ip_address   |
      | [0].mac_address  |
      | [0].tail_num     |
      | [0].airline_iata |
      | [0].ua_string    |
      | [0].jsession_id  |
      | [0].origin_iata  |
      | [0].dest_iata    |
      | [0].flight_info  |
      | [0].device_type  |
      | [0].service_id   |
      | [0].ins_date     |
    And the JSON response should have the following data types:
      | [0].ip_address   | String |
      | [0].mac_address  | String |
      | [0].tail_num     | String |
      | [0].airline_iata | String |
      | [0].ua_string    | String |
      | [0].jsession_id  | String |
      | [0].origin_iata  | String |
      | [0].dest_iata    | String |
      | [0].flight_info  | String |
      | [0].device_type  | String |
      | [0].service_id   | String |
      | [0].ins_date     | String |
    And the response headers should be "application/json;charset=UTF-8"
    And the JSON response should be the following:
      | [0].ip_address   | %{ipAddress}   |
      | [0].mac_address  | %{macAddress}  |
      | [0].tail_num     | 0DAL2          |
      | [0].jsession_id  | %{uxdid}       |
      | [0].device_type  | LAPTOP         |
      | [0].product_code | %{productCode} |
      | [0].service_id   | %{serviceId}   |
    Then I verify the S3 bucket with "%{ipAddress}" and "%{macAddress}"
    And the response status should be "200"
    And the JSON response should include the following:
      | ip_address   |
      | mac_address  |
      | tail_num     |
      | airline_iata |
      | ua_string    |
      | jsession_id  |
      | origin_iata  |
      | dest_iata    |
      | flight_info  |
      | device_type  |
      | service_id   |
      | ins_date     |
    And the JSON response should have the following data types:
      | ip_address   | String |
      | mac_address  | String |
      | tail_num     | String |
      | airline_iata | String |
      | ua_string    | String |
      | jsession_id  | String |
      | origin_iata  | String |
      | dest_iata    | String |
      | flight_info  | String |
      | device_type  | String |
      | service_id   | String |
      | ins_date     | String |
    And the JSON response should be the following:
      | ip_address   | %{ipAddress}   |
      | mac_address  | %{macAddress}  |
      | tail_num     | 0DAL2          |
      | jsession_id  | %{uxdid}       |
      | device_type  | LAPTOP         |
      | product_code | %{productCode} |
      | service_id   | %{serviceId}   |