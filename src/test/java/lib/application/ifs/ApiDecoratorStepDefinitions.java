package lib.application.ifs;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import lib.common.CommonLibrary;
import lib.framework.BaseTestCase;
import lib.rest.GenericRestStepDefinitions;
import models.apiDecorator.AuthenticateModel;
import models.gbp.captcha.CaptchaModel;
import models.payment.CalculateOrderModel;
import models.payment.CustomerModel;
import models.payment.ProcessOrderModel;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * This class is an application library that holds all step definitions for API Decorator specific functions
 *
 * @Author Brian DeSimone
 * @Date 04/03/2018
 */
public class ApiDecoratorStepDefinitions extends BaseTestCase {

    // GLOBAL CLASS VARIABLES
    private static Logger logger = LogManager.getLogger(ApiDecoratorStepDefinitions.class);
    private static CommonLibrary commonLibrary = new CommonLibrary();
    private static GenericRestStepDefinitions genericRestStepDefinitions = new GenericRestStepDefinitions();

    @Given("^I generate a (Math|Image) captcha object with captchaValue: \"(.*)\" for uxdId: \"(.*)\"$")
    public void GenerateCaptchaValidation(String type, String captchaValue, String uxdid) {
        captchaValue = commonLibrary.checkForVariables(captchaValue);
        uxdid = commonLibrary.checkForVariables(uxdid);
        logger.debug("Generating a " + type + " object with the validated value: " + captchaValue + " for uxdId: " + uxdid);
        if (type.equalsIgnoreCase("math")) {
            type = "VI";
        }
        else if (type.equalsIgnoreCase("image")) {
            type = "CI";
        }
        CaptchaModel captchaModel = new CaptchaModel(type, captchaValue, uxdid);
        memory.setGeneratedObject(captchaModel);
    }

    @Given("^I generate a customer$")
    public void generateCustomerObject() {
        logger.debug("Generating a Customer object");
        CustomerModel customerModel;
        try {
            customerModel = new CustomerModel(memory.retrieveValue("uxdid"));

        }
        catch (NullPointerException ex) {
            logger.error("We could not find a uxdid in memory. Please check your feature file.");
            throw new NullPointerException("We could not find a uxdid in memory. Please check your feature file.");
        }
        commonLibrary.logObject(customerModel);
        memory.setGeneratedObject(customerModel);
    }

    @Given("^I generate a customer for uxdId: \"(.*)\"$")
    public void generateCustomerObjectUxdid(String uxdid) {
        uxdid = commonLibrary.checkForVariables(uxdid);
        logger.debug("Generating a Customer object for uxdid: " + uxdid);
        CustomerModel customerModel = new CustomerModel(uxdid);
        commonLibrary.logObject(customerModel);
        memory.setGeneratedObject(customerModel);
    }

    @Given("^I generate a customer authentication object with username: \"(.*)\" and password: \"(.*)\"$")
    public void generateCustomerAuthenticationObject(String username, String password){
        username = commonLibrary.checkForVariables(username);
        password = commonLibrary.checkForVariables(password);
        logger.debug("Generating an authenticate user object for existing username: " + username + " and password: " + password);
        logger.debug("The uxdid for the existing customer is: " + memory.retrieveValue("uxdid"));
        AuthenticateModel authenticateModel = new AuthenticateModel(
                username,
                password,
                memory.retrieveValue("uxdid")
        );
        memory.setGeneratedObject(authenticateModel);
    }

    @Given("^I generate a calculate order object for productCode: \"(.*)\"$")
    public void generateCalculateOrderModel(String productCode) {
        productCode = commonLibrary.checkForVariables(productCode);
        try {
            String price = memory.retrieveValue("price");
            String userId = memory.retrieveValue("user_id");
            String locale = memory.retrieveValue("locale");
            String currency = memory.retrieveValue("currency");
            String uxdid = memory.retrieveValue("uxdid");
            logger.debug("Generating a calculate order object for productCode: " + productCode);
            logger.debug("Calculate order attributes set: \n" +
                    "price: " + price + "\n" +
                    "user: " + userId + "\n" +
                    "uxdid: " + uxdid + "\n" +
                    "locale: " + locale + "\n" +
                    "currency: " + currency);
            CalculateOrderModel calculateOrderModel = new CalculateOrderModel(
                    productCode,
                    price,
                    userId,
                    locale,
                    currency,
                    uxdid
            );
            memory.setGeneratedObject(calculateOrderModel);
        } catch (NullPointerException ex) {
            logger.error("Could not find the value in memory. Please check cucumber feature file.");
            throw new NullPointerException("Could not find the value in memory. Please check cucumber feature file.");
        }
    }

    @Given("^I generate a process order object for (VISA|AMEX|DISCOVER|MC|INVALID) purchase with productCode: \"(.*)\"( and store as saved card|)$")
    public void generateProcessOrderModel(String cardType, String productCode, String savedCard) {
        productCode = commonLibrary.checkForVariables(productCode);
        try {
            String price = memory.retrieveValue("price");
            String userId = memory.retrieveValue("user_id");
            String locale = memory.retrieveValue("locale");
            String currency = memory.retrieveValue("currency");
            String uxdid = memory.retrieveValue("uxdid");
            ProcessOrderModel processOrderModel;
            logger.debug("Generating a process order object for " + cardType + " purchase with productCode: " + productCode + savedCard);
            logger.debug("Process order attributes set: \n" +
                    "price: " + price + "\n" +
                    "user: " + userId + "\n" +
                    "uxdid: " + uxdid + "\n" +
                    "locale: " + locale + "\n" +
                    "currency: " + currency);
            if (savedCard.isEmpty()) {
                processOrderModel = new ProcessOrderModel(
                        productCode,
                        price,
                        userId,
                        uxdid,
                        cardType,
                        locale,
                        currency
                );
            }
            else {
                processOrderModel = new ProcessOrderModel(
                        productCode,
                        price,
                        userId,
                        uxdid,
                        cardType,
                        locale,
                        currency,
                        true
                );
            }
            memory.setGeneratedObject(processOrderModel);
        } catch (NullPointerException ex) {
            logger.error("Could not find the value in memory. Please check cucumber feature file.");
            throw new NullPointerException("Could not find the value in memory. Please check cucumber feature file.");
        }
    }

    @Given("^I generate a process order object using my saved card with ID: \"(.*)\" for productCode: \"(.*)\"$")
    public void GenerateProcessOrderModelSaveCard(String cardId, String productCode) {
        productCode = commonLibrary.checkForVariables(productCode);
        cardId = commonLibrary.checkForVariables(cardId);
        try {
            String price = memory.retrieveValue("price");
            String userId = memory.retrieveValue("user_id");
            String locale = memory.retrieveValue("locale");
            String currency = memory.retrieveValue("currency");
            String uxdid = memory.retrieveValue("uxdid");
            logger.debug("Generating a process order object using my saved card with ID " + cardId + " for productCode: " + productCode);
            logger.debug("Process order attributes set: \n" +
                    "price: " + price + "\n" +
                    "user: " + userId + "\n" +
                    "uxdid: " + uxdid + "\n" +
                    "locale: " + locale + "\n" +
                    "currency: " + currency);
            ProcessOrderModel processOrderModel = new ProcessOrderModel(
                    Integer.getInteger(cardId),
                    productCode,
                    price,
                    userId,
                    uxdid,
                    locale,
                    currency
            );
            memory.setGeneratedObject(processOrderModel);
        } catch (NullPointerException ex) {
            logger.error("Could not find the value in memory. Please check cucumber feature file.");
            throw new NullPointerException("Could not find the value in memory. Please check cucumber feature file.");
        }
    }

    @Given("^I save product information for (product code|product title): \"(.*)\"$")
    public void SaveProductInformation(String productType, String productInfo) {
        logger.debug("Saving productType, product, and price for " + productType + ": " + productInfo);
        if (productType.equalsIgnoreCase("PRODUCT CODE")){
            genericRestStepDefinitions.SaveJSONPosition("plans","productCode", productInfo,"position");
        }
        else if (productType.equalsIgnoreCase("PRODUCT TITLE")){
            genericRestStepDefinitions.SaveJSONPosition("plans","title", productInfo,"position");
        }
        genericRestStepDefinitions.SaveJSON("plans[" + memory.retrieveValue("position") + "].productType","product_type");
        genericRestStepDefinitions.SaveJSON("plans[" + memory.retrieveValue("position") + "].productCode","product_code");
        genericRestStepDefinitions.SaveJSON("plans[" + memory.retrieveValue("position") + "].title","product");
        genericRestStepDefinitions.SaveJSON("plans[" + memory.retrieveValue("position") + "].price","price");
    }

    // TODO: Leaving this for Eric as he is using it... I am going to take a different direction with my scripts
    @When("^I send an (APIDecorator) GAP call with the session uxdid$")
    public void getAvailableProducts(){
        genericRestStepDefinitions.SendBasicRest(
                "get",
                configManager.getAPIDECORATOR_URI() +
                        "/v2/products/" +
                        memory.retrieveValue("uxdid") + "?locale=" +
                        memory.retrieveValue("locale") + "&currency=" +
                        memory.retrieveValue("currency")
        );
    }

}