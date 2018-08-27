#############################################################################################
# This Feature file will test the the E2E functionality of Guest Checkout for AAL
# The following IFS services are tested in this flow:
# GBP
# API Decorator
# CloudDao
#
# @Author Eric Disrud
# @Date 07/13/2017
#############################################################################################

Feature: Validate Guest Checkout AAL


  Scenario Outline: Validate a successful AAL guest checkout with a VISA card for all applicable productCodes
    When I generate a <sessionType> GBP SessionId with airlineCode = "<airlineCode>", tailNumber = "<tailNumber>", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "<sessionType>"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "macAddress"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ipAddress"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "guestcheckout_user", currency = "<currency>", and uxdId = "%{uxdid}"
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
    Given I generate a guest purchase object with card type VISA for productCode = "<productCode>", price = "%{totalPrice}", email = "random", uxdId = "%{uxdid}", locale = "<locale>", and currency = "<currency>"
    And I save the generated JSON at "email" as "email"
    When I send an APIDecorator POST request to "/v2/guestpurchase/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And the JSON response should be the following:
      | statusMsg   | SUCCESS       |
      | productCode | <productCode> |
      | activated   | true          |
    And I save the JSON at "serviceId" as "serviceId"
    And I save the JSON at "userName" as "userName"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response should be the following:
      | productCode                 | <productCode> |
      | uxdId                       | %{uxdid}      |
      | simpleDeviceInfo.deviceType | <sessionType> |
      | simpleDeviceInfo.macAddress | %{macAddress} |
      | simpleDeviceInfo.clientIp   | %{ipAddress}  |
      | activated                   | true          |
      | loggedInStatus              | true          |
      | username                    | %{userName}   |
      | productInfo.productCode     | <productCode> |
      | productInfo.serviceId       | %{serviceId}  |
      | emailAddress                | %{email}      |
    Examples:
      | sessionType | airlineCode | tailNumber | productCode | locale | currency |
      | MOBILE      | AAL         | 0AAL2      | AASSAA0001  | en_US  | USD      |
      | LAPTOP      | AAL         | 0AAL2      | AAMPRC1010  | en_US  | USD      |

  @Positive
  Scenario Outline: Validate a successful AAL guest checkout with a VISA card for all applicable productCodes
    When I generate a <sessionType> GBP SessionId with airlineCode = "<airlineCode>", tailNumber = "<tailNumber>", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "<sessionType>"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "macAddress"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ipAddress"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "guestcheckout_user", currency = "<currency>", and uxdId = "%{uxdid}"
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
    Given I generate a guest purchase object with card type VISA for productCode = "<productCode>", price = "%{totalPrice}", email = "random", uxdId = "%{uxdid}", locale = "<locale>", and currency = "<currency>"
    And I save the generated JSON at "email" as "email"
    When I send an APIDecorator POST request to "/v2/guestpurchase/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And the JSON response should be the following:
      | statusMsg   | SUCCESS       |
      | productCode | <productCode> |
      | activated   | true          |
    And I save the JSON at "serviceId" as "serviceId"
    And I save the JSON at "userName" as "userName"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response should be the following:
      | productCode                 | <productCode> |
      | uxdId                       | %{uxdid}      |
      | simpleDeviceInfo.deviceType | <sessionType> |
      | simpleDeviceInfo.macAddress | %{macAddress} |
      | simpleDeviceInfo.clientIp   | %{ipAddress}  |
      | activated                   | true          |
      | loggedInStatus              | true          |
      | username                    | %{userName}   |
      | productInfo.productCode     | <productCode> |
      | productInfo.serviceId       | %{serviceId}  |
      | emailAddress                | %{email}      |
    Examples:
      | sessionType | airlineCode | tailNumber | productCode | locale | currency |
      | MOBILE      | AAL         | 0AAL2      | AASSAA0001  | en_US  | USD      |
      | MOBILE      | AAL         | 0AAL2      | AAMPRC1010  | en_US  | USD      |
      | LAPTOP      | AAL         | 0AAL2      | AASSAA0001  | en_US  | USD      |
      | LAPTOP      | AAL         | 0AAL2      | AAMPRC1010  | en_US  | USD      |

  @Positive
  Scenario Outline: Validate a successful AAL guest checkout with an MC card for all applicable productCodes
    When I generate a <sessionType> GBP SessionId with airlineCode = "<airlineCode>", tailNumber = "<tailNumber>", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "<sessionType>"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "macAddress"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ipAddress"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "guestcheckout_user", currency = "<currency>", and uxdId = "%{uxdid}"
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
    Given I generate a guest purchase object with card type MC for productCode = "<productCode>", price = "%{totalPrice}", email = "random", uxdId = "%{uxdid}", locale = "<locale>", and currency = "<currency>"
    And I save the generated JSON at "email" as "email"
    When I send an APIDecorator POST request to "/v2/guestpurchase/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And the JSON response should be the following:
      | statusMsg   | SUCCESS       |
      | productCode | <productCode> |
      | activated   | true          |
    And I save the JSON at "serviceId" as "serviceId"
    And I save the JSON at "userName" as "userName"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response should be the following:
      | productCode                 | <productCode> |
      | uxdId                       | %{uxdid}      |
      | simpleDeviceInfo.deviceType | <sessionType> |
      | simpleDeviceInfo.macAddress | %{macAddress} |
      | simpleDeviceInfo.clientIp   | %{ipAddress}  |
      | activated                   | true          |
      | loggedInStatus              | true          |
      | username                    | %{userName}   |
      | productInfo.productCode     | <productCode> |
      | productInfo.serviceId       | %{serviceId}  |
      | emailAddress                | %{email}      |
    Examples:
      | sessionType | airlineCode | tailNumber | productCode | locale | currency |
      | MOBILE      | AAL         | 0AAL2      | AASSAA0001  | en_US  | USD      |
      | MOBILE      | AAL         | 0AAL2      | AAMPRC1010  | en_US  | USD      |
      | LAPTOP      | AAL         | 0AAL2      | AASSAA0001  | en_US  | USD      |
      | LAPTOP      | AAL         | 0AAL2      | AAMPRC1010  | en_US  | USD      |

  @Positive
  Scenario Outline: Validate a successful AAL guest checkout with an AMEX card for all applicable productCodes
    When I generate a <sessionType> GBP SessionId with airlineCode = "<airlineCode>", tailNumber = "<tailNumber>", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "<sessionType>"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "macAddress"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ipAddress"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "guestcheckout_user", currency = "<currency>", and uxdId = "%{uxdid}"
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
    Given I generate a guest purchase object with card type AMEX for productCode = "<productCode>", price = "%{totalPrice}", email = "random", uxdId = "%{uxdid}", locale = "<locale>", and currency = "<currency>"
    And I save the generated JSON at "email" as "email"
    When I send an APIDecorator POST request to "/v2/guestpurchase/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And the JSON response should be the following:
      | statusMsg   | SUCCESS       |
      | productCode | <productCode> |
      | activated   | true          |
    And I save the JSON at "serviceId" as "serviceId"
    And I save the JSON at "userName" as "userName"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response should be the following:
      | productCode                 | <productCode> |
      | uxdId                       | %{uxdid}      |
      | simpleDeviceInfo.deviceType | <sessionType> |
      | simpleDeviceInfo.macAddress | %{macAddress} |
      | simpleDeviceInfo.clientIp   | %{ipAddress}  |
      | activated                   | true          |
      | loggedInStatus              | true          |
      | username                    | %{userName}   |
      | productInfo.productCode     | <productCode> |
      | productInfo.serviceId       | %{serviceId}  |
      | emailAddress                | %{email}      |
    Examples:
      | sessionType | airlineCode | tailNumber | productCode | locale | currency |
      | MOBILE      | AAL         | 0AAL2      | AASSAA0001  | en_US  | USD      |
      | MOBILE      | AAL         | 0AAL2      | AAMPRC1010  | en_US  | USD      |
      | LAPTOP      | AAL         | 0AAL2      | AASSAA0001  | en_US  | USD      |
      | LAPTOP      | AAL         | 0AAL2      | AAMPRC1010  | en_US  | USD      |

  @Positive
  Scenario Outline: Validate a successful AAL guest checkout with a JCB card for all applicable productCodes
    When I generate a <sessionType> GBP SessionId with airlineCode = "<airlineCode>", tailNumber = "<tailNumber>", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "<sessionType>"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "macAddress"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ipAddress"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "guestcheckout_user", currency = "<currency>", and uxdId = "%{uxdid}"
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
    Given I generate a guest purchase object with card type JCB for productCode = "<productCode>", price = "%{totalPrice}", email = "random", uxdId = "%{uxdid}", locale = "<locale>", and currency = "<currency>"
    And I save the generated JSON at "email" as "email"
    When I send an APIDecorator POST request to "/v2/guestpurchase/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And the JSON response should be the following:
      | statusMsg   | SUCCESS       |
      | productCode | <productCode> |
      | activated   | true          |
    And I save the JSON at "serviceId" as "serviceId"
    And I save the JSON at "userName" as "userName"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response should be the following:
      | productCode                 | <productCode> |
      | uxdId                       | %{uxdid}      |
      | simpleDeviceInfo.deviceType | <sessionType> |
      | simpleDeviceInfo.macAddress | %{macAddress} |
      | simpleDeviceInfo.clientIp   | %{ipAddress}  |
      | activated                   | true          |
      | loggedInStatus              | true          |
      | username                    | %{userName}   |
      | productInfo.productCode     | <productCode> |
      | productInfo.serviceId       | %{serviceId}  |
      | emailAddress                | %{email}      |
    Examples:
      | sessionType | airlineCode | tailNumber | productCode | locale | currency |
      | MOBILE      | AAL         | 0AAL2      | AASSAA0001  | en_US  | USD      |
      | MOBILE      | AAL         | 0AAL2      | AAMPRC1010  | en_US  | USD      |
      | LAPTOP      | AAL         | 0AAL2      | AASSAA0001  | en_US  | USD      |
      | LAPTOP      | AAL         | 0AAL2      | AAMPRC1010  | en_US  | USD      |

  @Positive
  Scenario Outline: Validate a successful AAL guest checkout with a DISCOVER card for all applicable productCodes
    When I generate a <sessionType> GBP SessionId with airlineCode = "<airlineCode>", tailNumber = "<tailNumber>", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "<sessionType>"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "macAddress"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ipAddress"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "guestcheckout_user", currency = "<currency>", and uxdId = "%{uxdid}"
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
    Given I generate a guest purchase object with card type DISCOVER for productCode = "<productCode>", price = "%{totalPrice}", email = "random", uxdId = "%{uxdid}", locale = "<locale>", and currency = "<currency>"
    And I save the generated JSON at "email" as "email"
    When I send an APIDecorator POST request to "/v2/guestpurchase/" with the generated body
    Then the response status should be "200"
    And the JSON response at "activated" should be "true"
    And the JSON response should be the following:
      | statusMsg   | SUCCESS       |
      | productCode | <productCode> |
      | activated   | true          |
    And I save the JSON at "serviceId" as "serviceId"
    And I save the JSON at "userName" as "userName"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "200"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response should be the following:
      | productCode                 | <productCode> |
      | uxdId                       | %{uxdid}      |
      | simpleDeviceInfo.deviceType | <sessionType> |
      | simpleDeviceInfo.macAddress | %{macAddress} |
      | simpleDeviceInfo.clientIp   | %{ipAddress}  |
      | activated                   | true          |
      | loggedInStatus              | true          |
      | username                    | %{userName}   |
      | productInfo.productCode     | <productCode> |
      | productInfo.serviceId       | %{serviceId}  |
      | emailAddress                | %{email}      |
    Examples:
      | sessionType | airlineCode | tailNumber | productCode | locale | currency |
      | MOBILE      | AAL         | 0AAL2      | AASSAA0001  | en_US  | USD      |
      | MOBILE      | AAL         | 0AAL2      | AAMPRC1010  | en_US  | USD      |
      | LAPTOP      | AAL         | 0AAL2      | AASSAA0001  | en_US  | USD      |
      | LAPTOP      | AAL         | 0AAL2      | AAMPRC1010  | en_US  | USD      |

  @Negative
  Scenario Outline: Validate a guest checkout to AAL with an invalid card
    When I generate a <sessionType> GBP SessionId with airlineCode = "<airlineCode>", tailNumber = "<tailNumber>", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "<sessionType>"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "macAddress"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ipAddress"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "guestcheckout_user", currency = "<currency>", and uxdId = "%{uxdid}"
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
    Given I generate a guest purchase object with card type INVALID for productCode = "<productCode>", price = "%{totalPrice}", email = "random", uxdId = "%{uxdid}", locale = "<locale>", and currency = "<currency>"
    And I save the generated JSON at "email" as "email"
    When I send an APIDecorator POST request to "/v2/guestpurchase/" with the generated body
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
    Examples:
      | sessionType | airlineCode | tailNumber | productCode | locale | currency |
      | MOBILE      | AAL         | 0AAL2      | AASSAA0001  | en_US  | USD      |

  @Negative
  Scenario Outline: Validate an AAL guest checkout with an invalid uxdid
    When I generate a <sessionType> GBP SessionId with airlineCode = "<airlineCode>", tailNumber = "<tailNumber>", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "<sessionType>"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "macAddress"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ipAddress"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "guestcheckout_user", currency = "<currency>", and uxdId = "%{uxdid}"
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
    Given I generate a guest purchase object with card type VISA for productCode = "<productCode>", price = "%{totalPrice}", email = "random", uxdId = "INVALID", locale = "<locale>", and currency = "<currency>"
    And I save the generated JSON at "email" as "email"
    When I send an APIDecorator POST request to "/v2/guestpurchase/" with the generated body
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
    And the JSON response should not include "serviceId"
    When I send a STUB GET request to "/abp/page/aaaActivate.do?gbpsessionid=%{uxdid}"
    Then the response status should be "404"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response should not include "productInfo.serviceId"
    And the JSON response at "uxdId" should be "%{uxdid}"
    Examples:
      | sessionType | airlineCode | tailNumber | productCode | locale | currency |
      | MOBILE      | AAL         | 0AAL2      | AASSAA0001  | en_US  | USD      |

  @Negative
  Scenario Outline: Validate an AAL guest checkout with an invalid zip code format
    When I generate a <sessionType> GBP SessionId with airlineCode = "<airlineCode>", tailNumber = "<tailNumber>", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "<sessionType>"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "macAddress"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ipAddress"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "guestcheckout_user", currency = "<currency>", and uxdId = "%{uxdid}"
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
    Given I generate a guest purchase object with card type VISA for productCode = "<productCode>", price = "%{totalPrice}", email = "random", uxdId = "%{uxdid}", locale = "<locale>", and currency = "<currency>"
    Then I modify the JSON at "addressDetails.postalCode" to be "1"
    When I send an APIDecorator POST request to "/v2/guestpurchase/" with the generated body
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
      | sessionType | airlineCode | tailNumber | productCode | locale | currency |
      | MOBILE      | AAL         | 0AAL2      | AASSAA0001  | en_US  | USD      |

  @Negative
  Scenario Outline: Validate a guest checkout to AAL with an invalid product code
    When I generate a <sessionType> GBP SessionId with airlineCode = "<airlineCode>", tailNumber = "<tailNumber>", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "<sessionType>"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "macAddress"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ipAddress"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "guestcheckout_user", currency = "<currency>", and uxdId = "%{uxdid}"
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
    Given I generate a guest purchase object with card type VISA for productCode = "INVALID", price = "%{totalPrice}", email = "random", uxdId = "%{uxdid}", locale = "<locale>", and currency = "<currency>"
    And I save the generated JSON at "email" as "email"
    When I send an APIDecorator POST request to "/v2/guestpurchase/" with the generated body
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
      | sessionType | airlineCode | tailNumber | productCode | locale | currency |
      | MOBILE      | AAL         | 0AAL2      | AASSAA0001  | en_US  | USD      |


  Scenario Outline: Validate a valid product from a different airline
    When I generate a <sessionType> GBP SessionId with airlineCode = "<airlineCode>", tailNumber = "<tailNumber>", and deviceMacAddress = "random" and store it at "uxdid"
    And I send a CloudDao GET request to "/v2/token/%{uxdid}"
    Then the response status should be "200"
    And the JSON response at "uxdId" should be "%{uxdid}"
    And the JSON response at "simpleDeviceInfo.deviceType" should be "<sessionType>"
    And I save the JSON at "simpleDeviceInfo.macAddress" as "macAddress"
    And I save the JSON at "simpleDeviceInfo.clientIp" as "ipAddress"
    When I send an APIDecorator GET request to "/v2.1/products/%{uxdid}?locale=en_US&currency=USD"
    Then the response status should be "200"
    And I save the position in collection "plans" of "productCode" = "<productCode>" at "position"
    And I save the JSON at "plans[%{position}].title" as "product"
    And I save the JSON at "plans[%{position}].price" as "price"
    Given I generate an calculate order model for productCode = "<productCode>", price = "%{price}", user = "guestcheckout_user", currency = "<currency>", and uxdId = "%{uxdid}"
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
    Given I generate a guest purchase object with card type VISA for productCode = "NUSAAA0001", price = "%{totalPrice}", email = "random", uxdId = "%{uxdid}", locale = "<locale>", and currency = "<currency>"
    And I save the generated JSON at "email" as "email"
    When I send an APIDecorator POST request to "/v2/guestpurchase/" with the generated body
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
      | sessionType | airlineCode | tailNumber | productCode | locale | currency |
      | MOBILE      | AAL         | 0AAL2      | AASSAA0001  | en_US  | USD      |
      | LAPTOP      | AAL         | 0AAL2      | AASSAA0001  | en_US  | USD      |