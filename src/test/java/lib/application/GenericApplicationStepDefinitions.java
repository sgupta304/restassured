package lib.application;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import io.restassured.RestAssured;
import io.restassured.response.Response;
import io.restassured.specification.ProxySpecification;
import lib.common.CommonLibrary;
import lib.framework.BaseTestCase;
import lib.rest.RestCommonLibrary;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * This class will hold specific generic step definitions that are tailed for the specific apps in test.
 *
 * @Author Brian DeSimone
 * @Date 12/12/2017
 */
public class GenericApplicationStepDefinitions extends BaseTestCase {

    // GLOBAL CLASS VARIABLES
    private static Logger logger = LogManager.getLogger(GenericApplicationStepDefinitions.class);
    private static CommonLibrary commonLibrary = new CommonLibrary();
    private static RestCommonLibrary restCommonLibrary = new RestCommonLibrary();

    // ================================================================================================================
    // GENERIC CUCUMBER STEP DEFINITIONS FOR APPLICATION SPECIFIC REST ASSURED FUNCTIONS
    // ================================================================================================================

    @Given("^I generate a uxdid and store it as \"(.*)\"$")
    public void GenerateUxdid(String storedName){
        logger.debug("Generating a uxdId and storing it for later use at: " + storedName);
        String uxdId = commonLibrary.genUxdid();
        memory.saveValue(storedName, uxdId);
        logger.debug("Storing: " + uxdId + " at: " + storedName);
    }

    @When("^I send (?:a|an) (ABP|APIDecorator|CloudDao|CPAPI|FIG|FlightInfo|GBP Edge|GBP Lite|GroundGateway|IFSGateway|IFSUTILS|RUPP|SCEMS|SessionManagement) (GET|POST|PUT|DELETE|PATCH) request to \"(.*)\"$")
    public void SendBasicRest(String application, String requestType, String destination) {
        if (application.equalsIgnoreCase("ABP")){
            // Temporarily set this to stub all the time... we will create logic to handle abp based on configs later
            RestAssured.proxy = ProxySpecification.host(configManager.getSTUB_URI()).withPort(3128);
            //RestAssured.proxy = ProxySpecification.host("maul.virtual.lru.gogoair.com").withPort(4301);
        }
        application = getServiceURI(application);
        destination = commonLibrary.checkForVariables(destination);
        Response response;
        switch(requestType.toLowerCase()) {
            case "get":
                response = restCommonLibrary.GET_REQUEST(
                        application + destination,
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "post":
                response = restCommonLibrary.POST_REQUEST(
                        application + destination,
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "put":
                response = restCommonLibrary.PUT_REQUEST(
                        application + destination,
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "delete":
                response = restCommonLibrary.DELETE_REQUEST(
                        application + destination,
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "patch":
                response = restCommonLibrary.PATCH_REQUEST(
                        application + destination,
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            default:
                // we should never get here!
                logger.error("Invalid type of REST request: " + requestType + "Please check cucumber feature.");
                throw new IllegalArgumentException("Invalid type of REST request: " + requestType);
        } // end switch of request type
        memory.setLastResponse(response);
        RestAssured.reset();
    }

    @When("^I send (?:a|an) (ABP|APIDecorator|CloudDao|CPAPI|FIG|FlightInfo|GBP Edge|GBP Lite|GroundGateway|IFSGateway|IFSUTILS|RUPP|SCEMS|SessionManagement) (GET|POST|PUT|DELETE|PATCH) request to \"(.*)\" with (?:JSON|json) body:$")
    public void SendBasicRestBody(String application, String requestType, String destination, String body) {
        application = getServiceURI(application);
        Response response;
        destination = commonLibrary.checkForVariables(destination);
        switch(requestType.toLowerCase()) {
            case "get":
                response = restCommonLibrary.GET_REQUEST_BODY(
                        application + destination,
                        body,
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "post":
                response = restCommonLibrary.POST_REQUEST_BODY(
                        application + destination,
                        body,
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "put":
                response = restCommonLibrary.PUT_REQUEST_BODY(
                        application + destination,
                        body,
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "delete":
                response = restCommonLibrary.DELETE_REQUEST_BODY(
                        application + destination,
                        body,
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "patch":
                response = restCommonLibrary.PATCH_REQUEST_BODY(
                        application + destination,
                        body,
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            default:
                // we should never get here!
                logger.error("Invalid type of REST request: " + requestType + "Please check cucumber feature.");
                throw new IllegalArgumentException("Invalid type of REST request: " + requestType);
        } // end switch of request type
        memory.setLastResponse(response);
    }

    @When("^I send (?:a|an) (ABP|APIDecorator|CloudDao|CPAPI|FIG|FlightInfo|GBP Edge|GBP Lite|GroundGateway|IFSGateway|IFSUTILS|RUPP|SCEMS|SessionManagement) (GET|POST|PUT|DELETE|PATCH) request to \"(.*)\" with the generated body$")
    public void SendRestGenBody(String application, String requestType, String destination){
        application = getServiceURI(application);
        Response response;
        destination = commonLibrary.checkForVariables(destination);
        switch(requestType.toLowerCase()) {
            case "get":
                response = restCommonLibrary.GET_REQUEST_BODY(
                        application + destination,
                        memory.getGeneratedObject(),
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "post":
                response = restCommonLibrary.POST_REQUEST_BODY(
                        application + destination,
                        memory.getGeneratedObject(),
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "put":
                response = restCommonLibrary.PUT_REQUEST_BODY(
                        application + destination,
                        memory.getGeneratedObject(),
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "delete":
                response = restCommonLibrary.DELETE_REQUEST_BODY(
                        application + destination,
                        memory.getGeneratedObject(),
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "patch":
                response = restCommonLibrary.PATCH_REQUEST_BODY(
                        application + destination,
                        memory.getGeneratedObject(),
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            default:
                // we should never get here!
                logger.error("Invalid type of REST request: " + requestType + "Please check cucumber feature.");
                throw new IllegalArgumentException("Invalid type of REST request: " + requestType);
        } // end switch of request type
        memory.setLastResponse(response);
    }

    /**
     * This method will get the service URI for specific services that are in test so we can call them in cucumber
     * in a nice english format that is clean for people to read and understand
     */
    private String getServiceURI(String service){
        switch (service.toUpperCase()){
            case "ABP":
                return configManager.getABP_URI();
            case "APIDECORATOR":
                return configManager.getAPIDECORATOR_URI();
            case "CLOUDDAO":
                return configManager.getCLOUDDAO_URI();
            case "CPAPI":
                return configManager.getCPAPI_URI();
            case "FIG":
                return configManager.getFIG_URI();
            case "FLIGHTINFO":
                return configManager.getFLIGHTINFO_URI();
            case "GBP EDGE":
                return configManager.getGBPEDGE_URI();
            case "GBP LITE":
                return configManager.getGBPLITE_URI();
            case "GROUNDGATEWAY":
                return configManager.getGROUNDGATEWAY_URI();
            case "IFSGATEWAY":
                return configManager.getIFSGATEWAY_URI();
            case "IFSUTILS":
                return configManager.getIFSUTILS_URI();
            case "RUPP":
                return configManager.getRUPP_URI();
            case "SCEMS":
                return configManager.getSCEMS_URI();
            case "SESSIONMANAGEMENT":
                return configManager.getSESSIONMANAGEMENT_URI();
            default:
                // we should never get here!
                logger.error("Invalid type of service to test: The framework does not know what " + service + " is. Please check cucumber feature file.");
                throw new IllegalArgumentException("Invalid type of service to test: The framework does not know what " + service + " is. Please check cucumber feature file.");
        }
    }

}
