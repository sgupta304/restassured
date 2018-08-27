#############################################################################################
# This Feature file will test the the E2E functionality of payment for VOZ.
# The following IFS services are tested in this flow:
# GPB
# API Decorator
# CloudDao
#
# @Author Eric Disrud
# @Date 10/31/2017
#############################################################################################

Feature: Validate Payment VOZ


  Scenario Outline: Validate a successful MOBILE purchase to VOZ with a VISA
    When I generate a MOBILE GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "MOBILE"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type VISA for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And I save the JSON at "serviceId" as "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "productInfo.serviceId" should be "%{serviceId}"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{userId}/uxdId/%{uxdid}"
    And the response status should be "200"
    And the JSON response should be the following:
      | trackingId                  | %{uxdid}       |
      | active[0].serviceIdentifier | %{serviceId}   |
      | active[0].productCode       | <productCode>  |
      | active[0].productName       | %{product}     |
      | active[0].productType       | %{productType} |
      | active[0].status            | ACTIVE         |
    Examples:
      | productCode |
      | VATIDB0060  |


  Scenario Outline: Validate a successful LAPTOP purchase to VOZ with a VISA
    When I generate a LAPTOP GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "LAPTOP"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type VISA for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And I save the JSON at "serviceId" as "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "productInfo.serviceId" should be "%{serviceId}"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{userId}/uxdId/%{uxdid}"
    And the response status should be "200"
    And the JSON response should be the following:
      | trackingId                  | %{uxdid}       |
      | active[0].serviceIdentifier | %{serviceId}   |
      | active[0].productCode       | <productCode>  |
      | active[0].productName       | %{product}     |
      | active[0].productType       | %{productType} |
      | active[0].status            | ACTIVE         |
    Examples:
      | productCode |
      | VATIDB0060  |

  @Positive
  Scenario Outline: Validate a successful MOBILE purchase to VOZ with a VISA
    When I generate a MOBILE GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "MOBILE"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type VISA for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And I save the JSON at "serviceId" as "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "productInfo.serviceId" should be "%{serviceId}"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{userId}/uxdId/%{uxdid}"
    And the response status should be "200"
    And the JSON response should be the following:
      | trackingId                  | %{uxdid}       |
      | active[0].serviceIdentifier | %{serviceId}   |
      | active[0].productCode       | <productCode>  |
      | active[0].productName       | %{product}     |
      | active[0].productType       | %{productType} |
      | active[0].status            | ACTIVE         |
    Examples:
      | productCode |
      | VATIDB0060  |

  @Positive
  Scenario Outline: Validate a successful LAPTOP purchase to VOZ with a VISA
    When I generate a LAPTOP GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "LAPTOP"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type VISA for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And I save the JSON at "serviceId" as "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "productInfo.serviceId" should be "%{serviceId}"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{userId}/uxdId/%{uxdid}"
    And the response status should be "200"
    And the JSON response should be the following:
      | trackingId                  | %{uxdid}       |
      | active[0].serviceIdentifier | %{serviceId}   |
      | active[0].productCode       | <productCode>  |
      | active[0].productName       | %{product}     |
      | active[0].productType       | %{productType} |
      | active[0].status            | ACTIVE         |
    Examples:
      | productCode |
      | VATIDB0060  |

   @Positive
  Scenario Outline: Validate a successful MOBILE purchase to VOZ with a SAVED VISA card
    When I generate a MOBILE GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "MOBILE"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type VISA for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", currency = "USD", and saveCard = TRUE
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And I save the JSON at "serviceId" as "serviceId"
    Then I send an APIDecorator GET request to "/v2/customer/%{userId}?dataTypes=PERSONAL,PMTINSTRUMENTS"
    And the response status should be "200"
    And I save the JSON at "creditCardDetails.paymentId" as "cardId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "productInfo.serviceId" should be "%{serviceId}"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{userId}/uxdId/%{uxdid}"
    And the response status should be "200"
    And the JSON response should be the following:
      | trackingId                  | %{uxdid}       |
      | active[0].serviceIdentifier | %{serviceId}   |
      | active[0].productCode       | <productCode>  |
      | active[0].productName       | %{product}     |
      | active[0].productType       | %{productType} |
      | active[0].status            | ACTIVE         |
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Then I generate a saved card process order model with cardId = "%{cardId}", for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And I save the JSON at "serviceId" as "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "productInfo.serviceId" should be "%{serviceId}"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{userId}/uxdId/%{uxdid}"
    And the response status should be "200"
    And the JSON response should be the following:
      | trackingId                  | %{uxdid}       |
      | active[0].serviceIdentifier | %{serviceId}   |
      | active[0].productCode       | <productCode>  |
      | active[0].productName       | %{product}     |
      | active[0].productType       | %{productType} |
      | active[0].status            | ACTIVE         |
    Examples:
      | productCode |
      | VATIDB0060  |

   @Positive
  Scenario Outline: Validate a successful LAPTOP purchase to VOZ with a SAVED VISA card
    When I generate a LAPTOP GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "LAPTOP"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type VISA for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", currency = "USD", and saveCard = TRUE
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And I save the JSON at "serviceId" as "serviceId"
    Then I send an APIDecorator GET request to "/v2/customer/%{userId}?dataTypes=PERSONAL,PMTINSTRUMENTS"
    And the response status should be "200"
    And I save the JSON at "creditCardDetails.paymentId" as "cardId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "productInfo.serviceId" should be "%{serviceId}"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{userId}/uxdId/%{uxdid}"
    And the response status should be "200"
    And the JSON response should be the following:
      | trackingId                  | %{uxdid}       |
      | active[0].serviceIdentifier | %{serviceId}   |
      | active[0].productCode       | <productCode>  |
      | active[0].productName       | %{product}     |
      | active[0].productType       | %{productType} |
      | active[0].status            | ACTIVE         |
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Then I generate a saved card process order model with cardId = "%{cardId}", for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And I save the JSON at "serviceId" as "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "productInfo.serviceId" should be "%{serviceId}"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{userId}/uxdId/%{uxdid}"
    And the response status should be "200"
    And the JSON response should be the following:
      | trackingId                  | %{uxdid}       |
      | active[0].serviceIdentifier | %{serviceId}   |
      | active[0].productCode       | <productCode>  |
      | active[0].productName       | %{product}     |
      | active[0].productType       | %{productType} |
      | active[0].status            | ACTIVE         |
    Examples:
      | productCode |
      | VATIDB0060  |

  @Positive
  Scenario Outline: Validate a successful MOBILE purchase to VOZ with a AMEX
    When I generate a MOBILE GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "MOBILE"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type AMEX for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And I save the JSON at "serviceId" as "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "productInfo.serviceId" should be "%{serviceId}"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{userId}/uxdId/%{uxdid}"
    And the response status should be "200"
    And the JSON response should be the following:
      | trackingId                  | %{uxdid}       |
      | active[0].serviceIdentifier | %{serviceId}   |
      | active[0].productCode       | <productCode>  |
      | active[0].productName       | %{product}     |
      | active[0].productType       | %{productType} |
      | active[0].status            | ACTIVE         |
    Examples:
      | productCode |
      | VATIDB0060  |

  @Positive
  Scenario Outline: Validate a successful LAPTOP purchase to VOZ with a AMEX
    When I generate a LAPTOP GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "LAPTOP"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type AMEX for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And I save the JSON at "serviceId" as "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "productInfo.serviceId" should be "%{serviceId}"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{userId}/uxdId/%{uxdid}"
    And the response status should be "200"
    And the JSON response should be the following:
      | trackingId                  | %{uxdid}       |
      | active[0].serviceIdentifier | %{serviceId}   |
      | active[0].productCode       | <productCode>  |
      | active[0].productName       | %{product}     |
      | active[0].productType       | %{productType} |
      | active[0].status            | ACTIVE         |
    Examples:
      | productCode |
      | VATIDB0060  |

  @Positive
  Scenario Outline: Validate a successful MOBILE purchase to VOZ with a SAVED AMEX card
    When I generate a MOBILE GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "MOBILE"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type AMEX for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", currency = "USD", and saveCard = TRUE
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And I save the JSON at "serviceId" as "serviceId"
    Then I send an APIDecorator GET request to "/v2/customer/%{userId}?dataTypes=PERSONAL,PMTINSTRUMENTS"
    And the response status should be "200"
    And I save the JSON at "creditCardDetails.paymentId" as "cardId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "productInfo.serviceId" should be "%{serviceId}"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{userId}/uxdId/%{uxdid}"
    And the response status should be "200"
    And the JSON response should be the following:
      | trackingId                  | %{uxdid}       |
      | active[0].serviceIdentifier | %{serviceId}   |
      | active[0].productCode       | <productCode>  |
      | active[0].productName       | %{product}     |
      | active[0].productType       | %{productType} |
      | active[0].status            | ACTIVE         |
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Then I generate a saved card process order model with cardId = "%{cardId}", for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And I save the JSON at "serviceId" as "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "productInfo.serviceId" should be "%{serviceId}"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{userId}/uxdId/%{uxdid}"
    And the response status should be "200"
    And the JSON response should be the following:
      | trackingId                  | %{uxdid}       |
      | active[0].serviceIdentifier | %{serviceId}   |
      | active[0].productCode       | <productCode>  |
      | active[0].productName       | %{product}     |
      | active[0].productType       | %{productType} |
      | active[0].status            | ACTIVE         |
    Examples:
      | productCode |
      | VATIDB0060  |

  @Positive
  Scenario Outline: Validate a successful LAPTOP purchase to VOZ with a SAVED AMEX card
    When I generate a LAPTOP GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "LAPTOP"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type AMEX for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", currency = "USD", and saveCard = TRUE
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And I save the JSON at "serviceId" as "serviceId"
    Then I send an APIDecorator GET request to "/v2/customer/%{userId}?dataTypes=PERSONAL,PMTINSTRUMENTS"
    And the response status should be "200"
    And I save the JSON at "creditCardDetails.paymentId" as "cardId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "productInfo.serviceId" should be "%{serviceId}"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{userId}/uxdId/%{uxdid}"
    And the response status should be "200"
    And the JSON response should be the following:
      | trackingId                  | %{uxdid}       |
      | active[0].serviceIdentifier | %{serviceId}   |
      | active[0].productCode       | <productCode>  |
      | active[0].productName       | %{product}     |
      | active[0].productType       | %{productType} |
      | active[0].status            | ACTIVE         |
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Then I generate a saved card process order model with cardId = "%{cardId}", for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And I save the JSON at "serviceId" as "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "productInfo.serviceId" should be "%{serviceId}"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{userId}/uxdId/%{uxdid}"
    And the response status should be "200"
    And the JSON response should be the following:
      | trackingId                  | %{uxdid}       |
      | active[0].serviceIdentifier | %{serviceId}   |
      | active[0].productCode       | <productCode>  |
      | active[0].productName       | %{product}     |
      | active[0].productType       | %{productType} |
      | active[0].status            | ACTIVE         |
    Examples:
      | productCode |
      | VATIDB0060  |

  @Positive
  Scenario Outline: Validate a successful MOBILE purchase to VOZ with a MC
    When I generate a MOBILE GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "MOBILE"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type MC for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And I save the JSON at "serviceId" as "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "productInfo.serviceId" should be "%{serviceId}"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{userId}/uxdId/%{uxdid}"
    And the response status should be "200"
    And the JSON response should be the following:
      | trackingId                  | %{uxdid}       |
      | active[0].serviceIdentifier | %{serviceId}   |
      | active[0].productCode       | <productCode>  |
      | active[0].productName       | %{product}     |
      | active[0].productType       | %{productType} |
      | active[0].status            | ACTIVE         |
    Examples:
      | productCode |
      | VATIDB0060  |

  @Positive
  Scenario Outline: Validate a successful LAPTOP purchase to VOZ with a MC
    When I generate a LAPTOP GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "LAPTOP"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type MC for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And I save the JSON at "serviceId" as "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "productInfo.serviceId" should be "%{serviceId}"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{userId}/uxdId/%{uxdid}"
    And the response status should be "200"
    And the JSON response should be the following:
      | trackingId                  | %{uxdid}       |
      | active[0].serviceIdentifier | %{serviceId}   |
      | active[0].productCode       | <productCode>  |
      | active[0].productName       | %{product}     |
      | active[0].productType       | %{productType} |
      | active[0].status            | ACTIVE         |
    Examples:
      | productCode |
      | VATIDB0060  |

  @Positive
  Scenario Outline: Validate a successful MOBILE purchase to VOZ with a SAVED MC card
    When I generate a MOBILE GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "MOBILE"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type MC for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", currency = "USD", and saveCard = TRUE
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And I save the JSON at "serviceId" as "serviceId"
    Then I send an APIDecorator GET request to "/v2/customer/%{userId}?dataTypes=PERSONAL,PMTINSTRUMENTS"
    And the response status should be "200"
    And I save the JSON at "creditCardDetails.paymentId" as "cardId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "productInfo.serviceId" should be "%{serviceId}"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{userId}/uxdId/%{uxdid}"
    And the response status should be "200"
    And the JSON response should be the following:
      | trackingId                  | %{uxdid}       |
      | active[0].serviceIdentifier | %{serviceId}   |
      | active[0].productCode       | <productCode>  |
      | active[0].productName       | %{product}     |
      | active[0].productType       | %{productType} |
      | active[0].status            | ACTIVE         |
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Then I generate a saved card process order model with cardId = "%{cardId}", for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And I save the JSON at "serviceId" as "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "productInfo.serviceId" should be "%{serviceId}"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{userId}/uxdId/%{uxdid}"
    And the response status should be "200"
    And the JSON response should be the following:
      | trackingId                  | %{uxdid}       |
      | active[0].serviceIdentifier | %{serviceId}   |
      | active[0].productCode       | <productCode>  |
      | active[0].productName       | %{product}     |
      | active[0].productType       | %{productType} |
      | active[0].status            | ACTIVE         |
    Examples:
      | productCode |
      | VATIDB0060  |

  @Positive
  Scenario Outline: Validate a successful LAPTOP purchase to VOZ with a SAVED MC card
    When I generate a LAPTOP GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "LAPTOP"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type MC for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", currency = "USD", and saveCard = TRUE
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And I save the JSON at "serviceId" as "serviceId"
    Then I send an APIDecorator GET request to "/v2/customer/%{userId}?dataTypes=PERSONAL,PMTINSTRUMENTS"
    And the response status should be "200"
    And I save the JSON at "creditCardDetails.paymentId" as "cardId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "productInfo.serviceId" should be "%{serviceId}"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{userId}/uxdId/%{uxdid}"
    And the response status should be "200"
    And the JSON response should be the following:
      | trackingId                  | %{uxdid}       |
      | active[0].serviceIdentifier | %{serviceId}   |
      | active[0].productCode       | <productCode>  |
      | active[0].productName       | %{product}     |
      | active[0].productType       | %{productType} |
      | active[0].status            | ACTIVE         |
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Then I generate a saved card process order model with cardId = "%{cardId}", for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And I save the JSON at "serviceId" as "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "productInfo.serviceId" should be "%{serviceId}"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{userId}/uxdId/%{uxdid}"
    And the response status should be "200"
    And the JSON response should be the following:
      | trackingId                  | %{uxdid}       |
      | active[0].serviceIdentifier | %{serviceId}   |
      | active[0].productCode       | <productCode>  |
      | active[0].productName       | %{product}     |
      | active[0].productType       | %{productType} |
      | active[0].status            | ACTIVE         |
    Examples:
      | productCode |
      | VATIDB0060  |

  @Negative
  Scenario Outline: Validate a successful MOBILE purchase to VOZ with an invalid card
    When I generate a MOBILE GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "MOBILE"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type INVALID for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "400"
    And the JSON response should include the following:
      | trackingId |
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | trackingId | string |
      | statusCode | string |
      | statusMsg  | string |
      | errorCode  | string |
      | errorMsg   | string |
    And the JSON response should be the following:
      | trackingId | %{uxdid}                                                             |
      | statusCode | 400                                                                  |
      | statusMsg  | Bad Request                                                          |
      | errorCode  | 1006                                                                 |
      | errorMsg   | Invalid or missing payment details. - Not a valid credit card number |
    And the JSON response should not include "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "404"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response should not include "productInfo.serviceId"
    And the JSON response at "uxdId" should be "%{uxdid}"
    Examples:
      | productCode |
      | VATIDB0060  |

  @Negative
  Scenario Outline: Validate a successful purchase to VOZ with an invalid user name
    When I generate a MOBILE GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "MOBILE"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type VISA for productCode = "<productCode>", price = "%{totalPrice}", user = "INVALID", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "403"
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | statusCode | string |
      | statusMsg  | string |
      | errorCode  | string |
      | errorMsg   | string |
    And the JSON response should be the following:
      | statusCode | 403                        |
      | statusMsg  | User not logged in.        |
      | errorCode  | 1023                       |
      | errorMsg   | User Information mismatch. |
    And the JSON response should not include "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "404"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response should not include "productInfo.serviceId"
    And the JSON response at "uxdId" should be "%{uxdid}"
    Examples:
      | productCode |
      | VATIDB0060  |

  @Negative
  Scenario Outline: Validate a successful purchase to VOZ with an invalid uxdid
    When I generate a MOBILE GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "MOBILE"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type VISA for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "INVALID", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "404"
    And the JSON response should include the following:
      | statusCode |
      | statusMsg  |
    And the JSON response should have the following data types:
      | statusCode | string |
      | statusMsg  | string |
    And the JSON response should be the following:
      | statusCode | 404             |
      | statusMsg  | UxdId not found |
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "404"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response should not include "productInfo.serviceId"
    And the JSON response at "uxdId" should be "%{uxdid}"
    Examples:
      | productCode |
      | VATIDB0060  |

  @Negative
  Scenario Outline: Validate a successful purchase to VOZ with an invalid zip code format
    When I generate a MOBILE GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "MOBILE"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type VISA for productCode = " <productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    Then I modify the JSON at "addressDetails.postalCode" to be "1"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "400"
    And the JSON response should include the following:
      | trackingId |
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | trackingId | string |
      | statusCode | string |
      | statusMsg  | string |
      | errorCode  | string |
      | errorMsg   | string |
    And the JSON response should be the following:
      | trackingId | %{uxdid}                         |
      | statusCode | 400                              |
      | statusMsg  | Bad Request                      |
      | errorCode  | 1002                             |
      | errorMsg   | [Incorrect value for postalCode] |
    And the JSON response should not include "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "404"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response should not include "productInfo.serviceId"
    And the JSON response at "uxdId" should be "%{uxdid}"
    Examples:
      | productCode |
      | VATIDB0060  |

  @Positive
  Scenario Outline: Validate a valid product with an invalid price
    When I generate a <sessionType> GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "<sessionType>"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type VISA for productCode = "<productCode>", price = "0", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And I save the JSON at "serviceId" as "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "productInfo.serviceId" should be "%{serviceId}"
    And the JSON response at "uxdId" should be "%{uxdid}"
    When I send an APIDecorator GET request to "/v2/subscription/user/%{userId}/uxdId/%{uxdid}"
    And the response status should be "200"
    And the JSON response should be the following:
      | trackingId                  | %{uxdid}       |
      | active[0].serviceIdentifier | %{serviceId}   |
      | active[0].productCode       | <productCode>  |
      | active[0].productName       | %{product}     |
      | active[0].productType       | %{productType} |
      | active[0].status            | ACTIVE         |
    Then I send a RUPP GET request to "/v1/customermanager/user/%{userId}?dataTypes=PURCHHIST,GROUP_ATTRIBUTES"
    And the JSON response should be the following:
      | statusCode                                        | 200           |
      | statusMsg                                         | SUCCESS       |
      | userName                                          | %{userId}     |
      | purchaseHistory.purchaseOrders[0].totalAmountPaid | %{totalPrice} |
    And the response status should be "200"
    Examples:
      | sessionType | productCode |
      | MOBILE      | VATIDB0060  |
      | LAPTOP      | VATIDB0060  |

  @Negative
  Scenario Outline: Validate a successful purchase to VOZ with an invalid product code
    When I generate a MOBILE GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "MOBILE"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type VISA for productCode = "INVALID", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "400"
    And the JSON response should include the following:
      | trackingId |
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | trackingId | string |
      | statusCode | string |
      | statusMsg  | string |
      | errorCode  | string |
      | errorMsg   | string |
    And the JSON response should be the following:
      | trackingId | %{uxdid}                          |
      | statusCode | 400                               |
      | statusMsg  | Bad Request                       |
      | errorCode  | 1040                              |
      | errorMsg   | Product Information not available |
    And the JSON response should not include "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "404"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response should not include "productInfo.serviceId"
    And the JSON response at "uxdId" should be "%{uxdid}"
    Examples:
      | productCode |
      | VATIDB0060  |

  @Positive
  Scenario Outline: Validate a valid product from a different airline
    When I generate a <sessionType> GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "<sessionType>"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type VISA for productCode = "NUSAAA0001", price = "0", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "400"
    And the JSON response should include the following:
      | trackingId |
      | statusCode |
      | statusMsg  |
      | errorCode  |
      | errorMsg   |
    And the JSON response should have the following data types:
      | trackingId | string |
      | statusCode | string |
      | statusMsg  | string |
      | errorCode  | string |
      | errorMsg   | string |
    And the JSON response should be the following:
      | trackingId | %{uxdid}                          |
      | statusCode | 400                               |
      | statusMsg  | Bad Request                       |
      | errorCode  | 1040                              |
      | errorMsg   | Product Information not available |
    And the JSON response should not include "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "404"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response should not include "productInfo.serviceId"
    And the JSON response at "uxdId" should be "%{uxdid}"
    Examples:
      | sessionType | productCode |
      | MOBILE      | VATIDB0060  |
      | LAPTOP      | VATIDB0060  |

  @Negative
  Scenario Outline: Validate a MOBILE purchase to VOZ does not work with a DISCOVER
    When I generate a MOBILE GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "MOBILE"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type DISCOVER for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | trackingId | %{uxdid}                              |
      | statusCode | 400                                   |
      | statusMsg  | Bad Request                           |
      | errorCode  | RF-905                                |
      | errorMsg   | 905 Payment details are not supported |
    Examples:
      | productCode |
      | VATIDB0060  |

  @Negative
  Scenario Outline: Validate a LAPTOP purchase to VOZ does not work with a DISCOVER
    When I generate a LAPTOP GBP SessionId with airlineCode = "VOZ", tailNumber = "0VOZQE", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "LAPTOP"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].productType" as "productType"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate a customer with the REQUIRED attributes
    When I send an APIDecorator POST request to "/v2/customer/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "userId" as "userId"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "%{userId}", currency = "USD", and uxdId = "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/calculateorder/" with the generated body
    Then the response status should be "200"
    And I save the JSON at "totalDue" as "totalPrice"
    When I send an APIDecorator GET request to "/v2/captcha/math/%{uxdid}"
    Then the response status should be "200"
    And I save the JSON at "captchaValue" as "captchaValue"
    And I validate captcha stored at "captchaValue" and store the result at "captchaResult"
    Given I generate a Math captcha object with captchaValue: "%{captchaResult}" for uxdId: "%{uxdid}"
    When I send an APIDecorator POST request to "/v2/captcha/validate/" with the generated body
    Then the response status should be "200"
    Given I generate a process order model with card type DISCOVER for productCode = "<productCode>", price = "%{totalPrice}", user = "%{userId}", uxdId = "%{uxdid}", locale = "en_US", and currency = "USD"
    When I send an APIDecorator POST request to "/v2/processorder/" with the generated body
    Then the response status should be "400"
    And the JSON response should be the following:
      | trackingId | %{uxdid}                              |
      | statusCode | 400                                   |
      | statusMsg  | Bad Request                           |
      | errorCode  | RF-905                                |
      | errorMsg   | 905 Payment details are not supported |
    Examples:
      | productCode |
      | VATIDB0060  |