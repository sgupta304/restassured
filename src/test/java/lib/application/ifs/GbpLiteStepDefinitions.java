package lib.application.ifs;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import io.restassured.http.Cookie;
import io.restassured.http.Cookies;
import io.restassured.http.Header;
import io.restassured.http.Headers;
import io.restassured.response.Response;
import lib.common.CommonLibrary;
import lib.enums.UserAgent;
import lib.framework.BaseTestCase;
import lib.rest.RestCommonLibrary;
import models.gbp.cacheProduct.ProductModel;
import models.gbp.eapUserInfo.EAPUserInfoModel;
import models.gbp.flightInfo.FlightInfoModel;
import models.gbp.messageBypass.MessageBypassModel;
import models.iPass.iPassCaptchaModel;
import models.tmo.TMOValidateModel;
import models.vsa.ASPModel;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.ws.rs.core.MediaType;

import static io.restassured.RestAssured.delete;
import static io.restassured.RestAssured.given;

/**
 * This class is an application library that holds cucumber step definitions for all GBP specific operations
 *
 * @Author Brian DeSimone
 * @Date 03/30/2018
 */
public class GbpLiteStepDefinitions extends BaseTestCase {

    // GLOBAL CLASS CONFIGS
    private static Logger logger = LogManager.getLogger(GbpLiteStepDefinitions.class);
    private static RestCommonLibrary restCommonLibrary = new RestCommonLibrary();
    private static CommonLibrary commonLibrary = new CommonLibrary();

    @When("^I send a GBP POST request to generate a (MOBILE|LAPTOP|1HR EAP|8HR EAP) session$")
    public void generateGBPSessionId(String requestType) {
        logger.debug("Generating a " + requestType + " sessionId from GBP");
        logger.debug("The session was created for airline: " + memory.retrieveValue("airline_code"));
        logger.debug("The session was created on tail: " + memory.retrieveValue("tail_number"));
        String macAddress;
        Response response;
        if (memory.retrieveValue("mac_address") != null) {
            macAddress = memory.retrieveValue("mac_address");
        } else {
            macAddress = commonLibrary.genRandomMacAddress();
            memory.saveValue("mac_address", macAddress);
        }
        switch (requestType.toUpperCase()) {
            case "MOBILE":
                response = restCommonLibrary.GET_REQUEST(
                        configManager.getGBPLITE_URI() +
                                "/page/gbpBackChannel.do" +
                                "?method=retrieveGbpSessionId" +
                                "&abpuserip=" +
                                commonLibrary.genRandomIpAddress() +
                                "&abp_user_mac_address=" +
                                macAddress +
                                "&flghtinf=" + new FlightInfoModel(
                                memory.retrieveValue("airline_code"),
                                memory.retrieveValue("tail_number"),
                                memory.retrieveValue("flight_number")
                        ).getFlightInformation(),
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        new Headers(new Header("User-Agent", UserAgent.MOBILE.getAgent())),
                        memory.getCustomCookies()
                );
                break;
            case "LAPTOP":
                response = restCommonLibrary.GET_REQUEST(
                        configManager.getGBPLITE_URI() +
                                "/page/gbpBackChannel.do" +
                                "?method=retrieveGbpSessionId" +
                                "&abpuserip=" +
                                commonLibrary.genRandomIpAddress() +
                                "&abp_user_mac_address=" +
                                macAddress +
                                "&flghtinf=" + new FlightInfoModel(
                                memory.retrieveValue("airline_code"),
                                memory.retrieveValue("tail_number"),
                                memory.retrieveValue("flight_number")
                        ).getFlightInformation(),
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "1HR EAP":
                EAPUserInfoModel eapUserInfoModel = new EAPUserInfoModel("1001", commonLibrary.genRandomEmailAddress());
                response = restCommonLibrary.GET_REQUEST(
                        configManager.getGBPLITE_URI() +
                                "/page/gbpBackChannel.do" +
                                "?method=retrieveGbpSessionId" +
                                "&abpuserip=" +
                                commonLibrary.genRandomIpAddress() +
                                "&abp_user_mac_address=" +
                                macAddress +
                                "&flghtinf=" + new FlightInfoModel(
                                memory.retrieveValue("airline_code"),
                                memory.retrieveValue("tail_number"),
                                memory.retrieveValue("flight_number")
                        ).getFlightInformation() +
                                "&eap_user_info=" + eapUserInfoModel.getEapUserInformation(),
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        new Headers(new Header("User-Agent", UserAgent.MOBILE.getAgent())),
                        memory.getCustomCookies()
                );
                memory.saveValue("eap_user_name", eapUserInfoModel.getEapUserName());
                break;
            case "8HR EAP":
                EAPUserInfoModel eapUserInfoModelOnePlus = new EAPUserInfoModel("1002", commonLibrary.genRandomEmailAddress());
                response = restCommonLibrary.GET_REQUEST(
                        configManager.getGBPLITE_URI() +
                                "/page/gbpBackChannel.do" +
                                "?method=retrieveGbpSessionId" +
                                "&abpuserip=" +
                                commonLibrary.genRandomIpAddress() +
                                "&abp_user_mac_address=" +
                                macAddress +
                                "&flghtinf=" + new FlightInfoModel(
                                memory.retrieveValue("airline_code"),
                                memory.retrieveValue("tail_number"),
                                memory.retrieveValue("flight_number")
                        ).getFlightInformation() +
                                "&eap_user_info=" + eapUserInfoModelOnePlus.getEapUserInformation(),
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        new Headers(new Header("User-Agent", UserAgent.MOBILE.getAgent())),
                        memory.getCustomCookies()
                );
                memory.saveValue("eap_user_name", eapUserInfoModelOnePlus.getEapUserName());
                break;
            default:
                // we should never get here!
                logger.error("Invalid type of GBP session: " + requestType + "Please check cucumber feature.");
                throw new IllegalArgumentException("Invalid type of GBP session: " + requestType + "Please check cucumber feature.");
        }
        memory.setLastResponse(response);
        memory.saveValue("uxdid", response.asString());
    }

    @When("^I retrieve user session info for uxdId: \"(.*)\"$")
    public void SendGBPRetrieveSessionInfo(String uxdId) {
        uxdId = commonLibrary.checkForVariables(uxdId);
        logger.debug("Attempting to retrieve user session info for uxdid: " + uxdId);
        Response response = restCommonLibrary.POST_REQUEST(
                configManager.getGBPLITE_URI() + "/page/gbpBackChannel.do?method=retrieveUserInfo",
                MediaType.APPLICATION_XML,
                MediaType.APPLICATION_XML,
                memory.getCustomHeaders(),
                new Cookies(new Cookie.Builder(
                        "uxdId", uxdId).build(),
                        new Cookie.Builder("JSESSIONID", uxdId).build()
                )
        );
        memory.setLastResponse(response);
    }

    @Given("^I validate captcha stored at \"(.*)\" and store the result at \"(.*)\"$")
    public void ValidateStoreCaptcha(String captchaLocation, String storageKey) {
        commonLibrary.checkForVariables(captchaLocation);
        logger.debug("We are validating the captcha value and storing the result at '" + storageKey + "' in memory");
        String captchaResult = commonLibrary.GetCaptchaResult(memory.retrieveValue(captchaLocation));
        memory.saveValue(storageKey, captchaResult);
    }

    @Given("^I generate an iPass captcha validation object for uxdId: \"(.*)\" with captcha result: \"(.*)\"$")
    public void generateIpassCaptchaObject(String uxdid, String captchaResult) {
        uxdid = commonLibrary.checkForVariables(uxdid);
        captchaResult = commonLibrary.checkForVariables(captchaResult);
        logger.debug("Generating an iPass captcha validation object for uxdId: " + uxdid + " with captcha result: " + captchaResult);
        iPassCaptchaModel iPassCaptchaModel = new iPassCaptchaModel(
                uxdid,
                captchaResult
        );
        memory.setGeneratedObject(iPassCaptchaModel);
    }

    @Given("^I generate an ASP object to (enable|disable) video service$")
    public void generateASPObject(String videoStatus) {
        logger.debug("Generating an ASP object that will " + videoStatus + " video service");
        ASPModel aspModel;
        if (videoStatus.equalsIgnoreCase("ENABLE")) {
            aspModel = new ASPModel(
                    "Y",
                    memory.retrieveValue("tail_number")
            );
        } else {
            aspModel = new ASPModel(
                    "N",
                    memory.retrieveValue("tail_number")
            );
        }
        memory.setGeneratedObject(aspModel);
    }

    @When("^I send a GBP Lite VSA request to \"(.*)\"$")
    public void sendVSAPromotionRequest(String url) throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        logger.debug("REST-ASSURED: Sending a GET request to " + url);
        Response response = given()
                .queryParam("res", "T")
                .queryParam("data", mapper.writeValueAsString(memory.getGeneratedObject()))
                .queryParam("type", "json")
                .queryParam("url", "/puts/vsa/aspPut/setVSA")
                .when()
                .log()
                .all()
                .post(configManager.getGBPLITE_URI() + url)
                .then()
                .extract()
                .response();
        logger.debug("REST-ASSURED: The response from the request is: " + response.asString());
        memory.setLastResponse(response);
    }

    @Given("^I generate a TMO object for (ONE-PLUS|1HR|LUP|NOZIP|LEGACY|EAP) with uxdid: \"(.*)\" and captcha: \"(.*)\"$")
    public void GenerateGBPTmoValidate(String type, String uxdid, String captcha) {
        uxdid = commonLibrary.checkForVariables(uxdid);
        captcha = commonLibrary.checkForVariables(captcha);
        logger.debug("Creating a TMO object using the model for: " + type + " with uxdId: " + uxdid + " and captchaValue: " + captcha);
        TMOValidateModel tmoValidateModel;
        switch (type.toUpperCase()) {
            case "ONE-PLUS":
                tmoValidateModel = new TMOValidateModel(
                        uxdid,
                        configManager.getTmoOnePlusPhoneNumber(),
                        configManager.getTmoOnePlusZipCode(),
                        captcha
                );
                break;
            case "1HR":
                tmoValidateModel = new TMOValidateModel(
                        uxdid,
                        configManager.getTmoPhoneNumber(),
                        configManager.getTmoZipCode(),
                        captcha
                );
                break;
            case "LUP":
                tmoValidateModel = new TMOValidateModel(
                        uxdid,
                        configManager.getTmoPhoneNumber(),
                        configManager.getTmoZipCode(),
                        captcha
                );
                break;
            case "NOZIP":
                tmoValidateModel = new TMOValidateModel(
                        uxdid,
                        configManager.getTmoNoZipPhoneNumber(),
                        "00000",
                        captcha
                );
                break;
            case "LEGACY":
                tmoValidateModel = new TMOValidateModel(
                        uxdid,
                        configManager.getTmoPhoneNumber(),
                        null,
                        captcha
                );
                break;
            case "EAP":
                tmoValidateModel = new TMOValidateModel(
                        uxdid,
                        captcha
                );
                break;
            default:
                // we should never get here!
                logger.error("Invalid type of TMO object: " + type + "Please check cucumber feature.");
                throw new IllegalArgumentException("Invalid type of TMO object: " + type);
        }
        memory.setGeneratedObject(tmoValidateModel);
    }

    @Given("^I generate a message bypass object with uxdid: \"(.*)\" and captcha: \"(.*)\"$")
    public void generateMessageBypassObject(String uxdid, String captchaValue) {
        uxdid = commonLibrary.checkForVariables(uxdid);
        captchaValue = commonLibrary.checkForVariables(captchaValue);
        logger.debug("Generating a bypass message object for uxdid: " + uxdid + " with captchaValue: " + captchaValue);
        MessageBypassModel messageBypassModel = new MessageBypassModel(
                uxdid,
                captchaValue
        );
        memory.setGeneratedObject(messageBypassModel);
    }

    @Given("^I generate a product object with the (required|maximum) attributes and caching (enabled|disabled)$")
    public void generateProductCache(String type, String cache) {
        boolean cacheFlag = false;
        logger.debug("Generating a product object with the " + type + " attributes and caching " + cache);
        if (cache.equalsIgnoreCase("ENABLED")) {
            cacheFlag = true;
        }
        try {
            ProductModel productModel;
            String airlineCode = memory.retrieveValue("airline_code");
            String tailNumber = memory.retrieveValue("tail_number");
            String flightNumber = memory.retrieveValue("flight_number");
            String version = memory.retrieveValue("version");
            switch (type.toUpperCase()) {
                case "REQUIRED":
                    logger.debug("Product attributes set: \n" +
                            "tail_number: " + tailNumber);
                    productModel = new ProductModel(airlineCode, tailNumber, flightNumber, version, cacheFlag, false);
                    break;
                case "MAXIMUM":
                    logger.debug("Product attributes set: \n" +
                            "airline_code: " + airlineCode + "\n" +
                            "tail_number: " + tailNumber + "\n" +
                            "flight_number: " + flightNumber);
                    productModel = new ProductModel(airlineCode, tailNumber, flightNumber, version, cacheFlag, true);
                    break;
                default:
                    logger.error("Invalid type of attributes in request: " + type + "Please check cucumber feature.");
                    throw new IllegalArgumentException("Invalid type of attributes in request: " + type + "Please check cucumber feature.");
            }
            memory.setGeneratedObject(productModel);
        } catch (NullPointerException ex) {
            logger.error("Could not find the value in memory. Please check cucumber feature file.");
            throw new NullPointerException("Could not find the value in memory. Please check cucumber feature file.");
        }
    }

}