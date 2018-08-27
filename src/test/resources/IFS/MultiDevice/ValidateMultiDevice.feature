#############################################################################################
# This Feature file will test the the E2E functionality of MultiDevice Passes
# The following IFS services are tested in this flow:
# GBP
# API Decorator
# IFSGateway
# IFSUTILS
#
# @Author Brian DeSimone
# @Date 05/12/2017
# Refactored: 05/15/2018
#############################################################################################
@MultiDevice @Regression
Feature: Validate MultiDevice Functionality

  Background: Setup the flight information for multi-device enabled flight
    Given I set the following attributes in memory:
      | airline_code  | DAL    |
      | tail_number   | 0QEDAL |
      | flight_number | DL123  |

  @HealthCheck
  Scenario: Validate a successful multi-device session (smoke test)
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save product information for product title: "Delta 2-Device Plan"
    Given I generate a customer
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "user_id"
    Given I generate a calculate order object for productCode: "%{product_code}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    And I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    Given I generate a Math captcha object with captchaValue: "%{captcha_result}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order object for VISA purchase with productCode: "%{product_code}"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    When I retrieve user session info for uxdId: "%{uxdid}"
    Then the response status should be "200"

  @HealthCheck
  Scenario: Validate that a successful multi-device session returns proper schema when checked through IFSUTILS
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ip_address"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save product information for product title: "Delta 2-Device Plan"
    Given I generate a customer
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "user_id"
    Given I generate a calculate order object for productCode: "%{product_code}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    And I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    Given I generate a Math captcha object with captchaValue: "%{captcha_result}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order object for VISA purchase with productCode: "%{product_code}"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    Given I generate a device state object to check multi-device session status
    When I send an IFSUTILS POST request to "/v1/devicestate/check" with the generated body
    Then the response status should be "200"
    And the JSON response should include the following:
      | timestamp             |
      | trackingId            |
      | statusCode            |
      | statusMsg             |
      | allowSession          |
      | availableSessionCount |
      | avaialbleSessionCount |
      | currentSessionCount   |
      | existingSessionIds    |

  @HealthCheck
  Scenario: Validate that a successful multi-device session returns proper data types when checked through IFSUTILS
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ip_address"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save product information for product title: "Delta 2-Device Plan"
    Given I generate a customer
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "user_id"
    Given I generate a calculate order object for productCode: "%{product_code}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    And I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    Given I generate a Math captcha object with captchaValue: "%{captcha_result}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order object for VISA purchase with productCode: "%{product_code}"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    Given I generate a device state object to check multi-device session status
    When I send an IFSUTILS POST request to "/v1/devicestate/check" with the generated body
    Then the response status should be "200"
    And the JSON response should have the following data types:
      | timestamp             | Long      |
      | trackingId            | String    |
      | statusCode            | String    |
      | statusMsg             | String    |
      | allowSession          | Boolean   |
      | availableSessionCount | Integer   |
      | avaialbleSessionCount | Integer   |
      | currentSessionCount   | Integer   |
      | existingSessionIds    | ArrayList |

  @HealthCheck
  Scenario: Validate that a successful multi-device session stores proper data in the IFSUTILS DB
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ip_address"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save product information for product title: "Delta 2-Device Plan"
    Given I generate a customer
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "user_id"
    Given I generate a calculate order object for productCode: "%{product_code}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    And I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    Given I generate a Math captcha object with captchaValue: "%{captcha_result}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order object for VISA purchase with productCode: "%{product_code}"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    Given I generate a device state object to check multi-device session status
    When I send an IFSUTILS POST request to "/v1/devicestate/check" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | trackingId            | %{ip_address} |
      | statusCode            | 200           |
      | statusMsg             | SUCCESS       |
      | allowSession          | true          |
      | availableSessionCount | 2             |
      | avaialbleSessionCount | 2             |
      | currentSessionCount   | 1             |

  @HealthCheck
  Scenario: Validate that a successful multi-device session increases the session count in IFSUTILS
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ip_address"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save product information for product title: "Delta 2-Device Plan"
    Given I generate a customer
    And I save the generated JSON at "email" as "email"
    And I save the generated JSON at "password" as "password"
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "user_id"
    Given I generate a calculate order object for productCode: "%{product_code}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    And I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    Given I generate a Math captcha object with captchaValue: "%{captcha_result}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order object for VISA purchase with productCode: "%{product_code}"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    Given I generate a device state object to check multi-device session status
    When I send an IFSUTILS POST request to "/v1/devicestate/check" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | trackingId            | %{ip_address} |
      | statusCode            | 200           |
      | statusMsg             | SUCCESS       |
      | allowSession          | true          |
      | availableSessionCount | 2             |
      | avaialbleSessionCount | 2             |
      | currentSessionCount   | 1             |
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ip_address"
    Given I generate a customer authentication object with username: "%{email}" and password: "%{password}"
    When I send an APIDecorator POST request to "/v2/customer/authenticate" with the generated body
    Then the response status should be "200"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{user_id}/uxdId/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "active[0].serviceIdentifier" as "service_id"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    And I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    Given I generate a Math captcha object with captchaValue: "%{captcha_result}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    Given I generate a device state object to check multi-device session status
    When I send an IFSUTILS POST request to "/v1/devicestate/check" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | trackingId            | %{ip_address} |
      | statusCode            | 200           |
      | statusMsg             | SUCCESS       |
      | allowSession          | true          |
      | availableSessionCount | 2             |
      | avaialbleSessionCount | 2             |
      | currentSessionCount   | 2             |

  @HealthCheck
  Scenario: Validate that a successful 3rd multi-device session logs out the 1st session and logs in the 3rd
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ip_address"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ip_address1"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save product information for product title: "Delta 2-Device Plan"
    Given I generate a customer
    And I save the generated JSON at "email" as "email"
    And I save the generated JSON at "password" as "password"
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "user_id"
    Given I generate a calculate order object for productCode: "%{product_code}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    And I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    Given I generate a Math captcha object with captchaValue: "%{captcha_result}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order object for VISA purchase with productCode: "%{product_code}"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    Given I generate a device state object to check multi-device session status
    When I send an IFSUTILS POST request to "/v1/devicestate/check" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | trackingId            | %{ip_address} |
      | statusCode            | 200           |
      | statusMsg             | SUCCESS       |
      | allowSession          | true          |
      | availableSessionCount | 2             |
      | avaialbleSessionCount | 2             |
      | currentSessionCount   | 1             |
    And I save the JSON at "existingSessionIds[0]" as "session"
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ip_address"
    Given I generate a customer authentication object with username: "%{email}" and password: "%{password}"
    When I send an APIDecorator POST request to "/v2/customer/authenticate" with the generated body
    Then the response status should be "200"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{user_id}/uxdId/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "active[0].serviceIdentifier" as "service_id"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    And I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    Given I generate a Math captcha object with captchaValue: "%{captcha_result}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    Given I generate a device state object to check multi-device session status
    When I send an IFSUTILS POST request to "/v1/devicestate/check" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | trackingId            | %{ip_address} |
      | statusCode            | 200           |
      | statusMsg             | SUCCESS       |
      | allowSession          | true          |
      | availableSessionCount | 2             |
      | avaialbleSessionCount | 2             |
      | currentSessionCount   | 2             |
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ip_address"
    Given I generate a customer authentication object with username: "%{email}" and password: "%{password}"
    When I send an APIDecorator POST request to "/v2/customer/authenticate" with the generated body
    Then the response status should be "200"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{user_id}/uxdId/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "active[0].serviceIdentifier" as "service_id"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    And I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    Given I generate a Math captcha object with captchaValue: "%{captcha_result}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    Given I generate a device state object to check multi-device session status
    When I send an IFSUTILS POST request to "/v1/devicestate/check" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | trackingId            | %{ip_address} |
      | statusCode            | 200           |
      | statusMsg             | SUCCESS       |
      | allowSession          | true          |
      | availableSessionCount | 2             |
      | avaialbleSessionCount | 2             |
      | currentSessionCount   | 2             |
    And the JSON response should not be the following:
      | existingSessionIds[0] | %{session} |
      | existingSessionIds[1] | %{session} |
    Given I generate a device state object to check multi-device session status
    And I modify the JSON at "ipaddress" to be "%{ip_address1}"
    When I send an IFSUTILS POST request to "/v1/devicestate/check" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | trackingId            | %{ip_address1} |
      | statusCode            | 200            |
      | statusMsg             | SUCCESS        |
      | allowSession          | false          |
      | availableSessionCount | 2              |
      | avaialbleSessionCount | 2              |
      | currentSessionCount   | 2              |
    And the JSON response should not be the following:
      | existingSessionIds[0] | %{session} |
      | existingSessionIds[1] | %{session} |

  Scenario: Validate previously purchased pass user can log in on two devices
  # TODO


  Scenario: Validate <airline> airline can purchase a multi-device pass with promo code and get 2 active sessions
  # TODO: When we do promo codes

  @Negative
  Scenario: Validate a successful multi-device session and purchase when using the wrong product price. The history should show correct price
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ip_address"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save product information for product title: "Delta 2-Device Plan"
    Given I generate a customer
    And I save the generated JSON at "email" as "email"
    And I save the generated JSON at "password" as "password"
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "user_id"
    Given I generate a calculate order object for productCode: "%{product_code}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    And I modify the JSON at "product.price" to be "1"
    Then the response status should be "200"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    And I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    Given I generate a Math captcha object with captchaValue: "%{captcha_result}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order object for VISA purchase with productCode: "%{product_code}"
    And I modify the JSON at "product.price" to be "1"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    When I send a RUPP GET request to "/v1/customermanager/purchasehistory/user/%{user_id}"
    Then the response status should be "200"
    And the JSON response at "purchaseHistory.purchaseOrders[0].totalAmountPaid" should be "%{price}"
    Given I generate a device state object to check multi-device session status
    When I send an IFSUTILS POST request to "/v1/devicestate/check" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | trackingId            | %{ip_address} |
      | statusCode            | 200           |
      | statusMsg             | SUCCESS       |
      | allowSession          | true          |
      | availableSessionCount | 2             |
      | avaialbleSessionCount | 2             |
      | currentSessionCount   | 1             |

  @Positive
  Scenario: Validate a multi device purchased pass shows the correct data when retrieving session info from GBP
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ip_address"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save product information for product title: "Delta 2-Device Plan"
    Given I generate a customer
    And I save the generated JSON at "email" as "email"
    And I save the generated JSON at "password" as "password"
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "user_id"
    Given I generate a calculate order object for productCode: "%{product_code}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    And I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    Given I generate a Math captcha object with captchaValue: "%{captcha_result}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order object for VISA purchase with productCode: "%{product_code}"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "serviceId" as "service_id"
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    Given I generate a device state object to check multi-device session status
    When I send an IFSUTILS POST request to "/v1/devicestate/check" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | trackingId            | %{ip_address} |
      | statusCode            | 200           |
      | statusMsg             | SUCCESS       |
      | allowSession          | true          |
      | availableSessionCount | 2             |
      | avaialbleSessionCount | 2             |
      | currentSessionCount   | 1             |
    When I retrieve user session info for uxdId: "%{uxdid}"
    Then the response status should be "200"
    And the XML response should be the following:
      | java.object.void[0]                | true                          |
      | java.object.void[1].object.void[0] | %{ip_address}                 |
      | java.object.void[1].object.void[1] | DUMMY                         |
      | java.object.void[1].object.void[2] | REGULAR                       |
      | java.object.void[1].object.void[3] | %{uxdid}                      |
      | java.object.void[1].object.void[4] | 1_MD/%{user_id}%%{service_id} |
      | java.object.void[2]                | %{mac_address}                |
    When I send a GBP POST request to generate a MOBILE session
    Then the response status should be "200"
    And I send a IFSGateway GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ip_address"
    Given I generate a customer authentication object with username: "%{email}" and password: "%{password}"
    When I send an APIDecorator POST request to "/v2/customer/authenticate" with the generated body
    Then the response status should be "200"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{user_id}/uxdId/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "active[0].serviceIdentifier" as "service_id"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captcha_value"
    And I validate captcha stored at "captcha_value" and store the result at "captcha_result"
    Given I generate a Math captcha object with captchaValue: "%{captcha_result}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    When I send a ABP GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    Given I generate a device state object to check multi-device session status
    When I send an IFSUTILS POST request to "/v1/devicestate/check" with the generated body
    Then the response status should be "200"
    And the JSON response should be the following:
      | trackingId            | %{ip_address} |
      | statusCode            | 200           |
      | statusMsg             | SUCCESS       |
      | allowSession          | true          |
      | availableSessionCount | 2             |
      | avaialbleSessionCount | 2             |
      | currentSessionCount   | 2             |
    When I retrieve user session info for uxdId: "%{uxdid}"
    Then the response status should be "200"
    And the XML response should be the following:
      | java.object.void[0]                | true                          |
      | java.object.void[1].object.void[0] | %{ip_address}                 |
      | java.object.void[1].object.void[1] | DUMMY                         |
      | java.object.void[1].object.void[2] | REGULAR                       |
      | java.object.void[1].object.void[3] | %{uxdid}                      |
      | java.object.void[1].object.void[4] | 2_MD/%{user_id}%%{service_id} |
      | java.object.void[2]                | %{mac_address}                |