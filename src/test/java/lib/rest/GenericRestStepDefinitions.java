package lib.rest;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import cucumber.api.DataTable;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.When;
import io.restassured.http.Cookie;
import io.restassured.http.Cookies;
import io.restassured.http.Header;
import io.restassured.http.Headers;
import io.restassured.response.Response;
import lib.common.CommonLibrary;
import lib.framework.BaseTestCase;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.ws.rs.core.MediaType;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static lib.rest.ModifyJson.modifyJson;

/**
 * This class will hold all generic rest step definitions that interact with JSON based services
 *
 * @Author Brian DeSimone
 * @Date 11/20/2017
 */
public class GenericRestStepDefinitions extends BaseTestCase {

    // GLOBAL CLASS VARIABLES
    private static Logger logger = LogManager.getLogger(GenericRestStepDefinitions.class);
    private static CommonLibrary commonLibrary = new CommonLibrary();
    private static RestCommonLibrary restCommonLibrary = new RestCommonLibrary();

    // ================================================================================================================
    // GENERIC STEP DEFINITIONS FOR REST SERVICES
    // ================================================================================================================

    @Given("I send and accept (?:JSON|json)$")
    public void SetHeadersJSON() {
        memory.setAcceptHeader(MediaType.APPLICATION_JSON);
        memory.setContentTypeHeader(MediaType.APPLICATION_JSON);
        logger.debug("Content-Type header is set to: " + memory.getContentTypeHeader());
        logger.debug("Accept header is set to: " + memory.getAcceptHeader());
    }

    @Given("^I send \"(.*)\" and accept \"(.*)\"$")
    public void SetHeaders(String send, String accept) {
        memory.setAcceptHeader(accept);
        memory.setContentTypeHeader(send);
        logger.debug("Content-Type header is set to: " + memory.getContentTypeHeader());
        logger.debug("Accept header is set to: " + memory.getAcceptHeader());
    }

    @Given("^I set custom headers:$")
    public void SetCustomHeaders(Map<String, String> map){
        logger.debug("Setting custom headers from the table");
        List<Header> headerList = new ArrayList<>();
        for (Map.Entry<String, String> entry : map.entrySet()){
            String key = commonLibrary.checkForVariables(entry.getKey());
            String value = commonLibrary.checkForVariables(entry.getValue());
            if (value.equalsIgnoreCase("random")){
                value = commonLibrary.generateRandomString(36);
            }
            logger.debug("Setting custom header: " + key + " value: " + value);
            headerList.add(new Header(key, value));
        }
        memory.setCustomHeaders(new Headers(headerList));
    }

    @Given("^I clear custom headers$")
    public void ClearCustomHeaders(){
        logger.debug("Clearing custom headers");
        memory.setCustomHeaders(null);
    }

    // ================================================================================================================
    // COOKIES STEP DEFINITIONS
    // ================================================================================================================

    @Given("^I set custom cookies:$")
    public void setCustomCookies(Map<String, String> map){
        logger.debug("Setting custom cookies from the table");
        List<Cookie> cookieList = new ArrayList<>();
        for (Map.Entry<String, String> entry : map.entrySet()){
            String key = commonLibrary.checkForVariables(entry.getKey());
            String value = commonLibrary.checkForVariables(entry.getValue());
            if (value.equalsIgnoreCase("random")){
                value = commonLibrary.generateRandomString(36);
            }
            logger.debug("Setting custom cookie: " + key + " value " + value);
            cookieList.add(new Cookie.Builder(key, value).build());
        }
        memory.setCustomCookies(new Cookies(cookieList));
    }

    @Given("^I clear custom cookies$")
    public void clearCustomCookies(){
        logger.debug("Clearing custom cookies");
        memory.setCustomCookies(null);
    }

    // ================================================================================================================
    // MEMORY STEP DEFINITIONS
    // ================================================================================================================
    @Given("^I save the position in collection \"(.*)\" of \"(.*)\" = \"(.*)\" at \"(.*)\"$")
    public void SaveJSONPosition(String collectionKey, String key, String value, String storageName) {
        value = commonLibrary.checkForVariables(value);
        logger.debug("Finding the position in the collection: " + collectionKey + " that holds key: " + key + " value: " + value);
        List<Map> plans = memory.getLastResponse().jsonPath().get(collectionKey);
        for (int i = 0; i < plans.size(); i++) {
            try {
                if (plans.get(i).get(key).equals(value)) {
                    memory.saveValue(storageName, Integer.toString(i));
                }
            } catch (NullPointerException e) {
                logger.error("We could not find then key: '" + key + "' value: '" + value + "' pair in the collection. Please check cucumber feature.");
                throw new NullPointerException("We could not find then key: '" + key + "' value: '" + value + "' pair in the collection. Please check cucumber feature.");
            }
        }
    }

    @Given("^I save the generated (?:JSON|json) at \"(.*)\" as \"(.*)\"$")
    public void SaveGeneratedJSON(String key, String storageName) throws IOException {
        key = commonLibrary.checkForVariables(key);
        ObjectMapper mapper = new ObjectMapper();
        String jsonAsString = mapper.writeValueAsString(memory.getGeneratedObject());
        JsonNode node = mapper.readTree(jsonAsString);
        try {
            memory.saveValue(storageName, node.get(key).textValue());
            logger.debug("Saving key: " + key + " value: " + node.get(key).textValue() + " as: " + storageName);
        } catch (NullPointerException e) {
            logger.error("We could not find the key: '" + key + "' in the generated body. Please check Cucumber Feature." + e);
            throw new NullPointerException("We could not find the key: '" + key + "' in the body. Please check Cucumber Feature.");
        }
    }

    @Given("^I save the (?:JSON|json) at \"(.*)\" as \"(.*)\"$")
    public void SaveJSON(String key, String storageName) {
        key = commonLibrary.checkForVariables(key);
        logger.debug("Saving key: " + key + " value: " + memory.getLastResponse().jsonPath().get(key).toString() + " as: " + storageName);
        memory.saveValue(storageName, memory.getLastResponse().jsonPath().get(key).toString());
    }

    @Given("^I save the String \"(.*)\" as \"(.*)\"$")
    public void SaveString(String value, String storageName) {
        logger.debug("Saving value: " + value + " as: " + storageName);
        memory.saveValue(storageName, value);
    }

    @Given("^I set the following attributes in memory:$")
    public void saveAttributes(Map<String, String> map){
        logger.debug("Setting some custom attributes in memory for the scenario.");
        for (Map.Entry<String, String> entry : map.entrySet()){
            String key = commonLibrary.checkForVariables(entry.getKey());
            String value = commonLibrary.checkForVariables(entry.getValue());
            if (value.equalsIgnoreCase("random")){
                value = commonLibrary.generateRandomString(36);
            }
            logger.debug("Saving value: " + value + " as: " + key);
            memory.saveValue(key, value);
        }
    }

    @Given("^I print the stored value at \"(.*)\"$")
    public void PrintValue(String key) {
        logger.debug("The value of the stored value at key: " + key + " = " + memory.retrieveValue(key));
    }

    // ================================================================================================================
    // GENERIC CUCUMBER STEP DEFINITIONS FOR REST GENERIC OBJECTS
    // ================================================================================================================

    @Given("^I generate a (?:JSON|json) body from the following:$")
    public void GenerateJSONBody(String body) {
        logger.debug("The JSON body generated is: " + body);
        memory.setGeneratedObject(body);
    }

    @Given("^I generate an object with key: \"(.*)\" value: \"(.*)\"$")
    public void GenerateGenericObject(String key, String value) {
        key = commonLibrary.checkForVariables(key);
        value = commonLibrary.checkForVariables(value);
        logger.debug("Generating a body with key: " + key + " and value: " + value);
        Map<String, Object> body = new HashMap<>();
        body.put(key, value);
        memory.setGeneratedObject(body);
    }

    @Given("^I generate an object with the following attributes:$")
    public void GenerateGenericObjectTable(Map<String, String> map) {
        logger.debug("Generating a body with the following attributes:");
        Map<String, Object> body = new HashMap<>();
        for (Map.Entry<String, String> entry : map.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue();
            key = commonLibrary.checkForVariables(key);
            value = commonLibrary.checkForVariables(value);
            logger.debug("Adding attribute to body as: key:" + key + " value: " + value);
            body.put(key, value);
        }
        memory.setGeneratedObject(body);
    }

    @Given("^I print the generated object$")
    public void PrintGeneratedObject() {
        logger.debug("Printing the last generated object stored in memory");
        commonLibrary.logObject(memory.getGeneratedObject());
    }

    @Given("^I modify the (?:JSON|json) at \"(.*)\" to be \"(.*)\"$")
    public void ModifyJsonAttribute(String key, String value) throws IOException {
        String originalKey = key;
        value = commonLibrary.checkForVariables(value);
        logger.debug("Modifying then JSON attribute at: " + key + " to be: " + value);
        ObjectMapper mapper = new ObjectMapper();
        String jsonAsString = mapper.writeValueAsString(memory.getGeneratedObject());
        JsonNode node = mapper.readTree(jsonAsString);
        String path = "/" + key.replace(".", "/").replace("[", "/").replace("]/", "/").replace("]", "/");
        int nestedLevel = path.length() - path.replace("/", "").length();
        if (nestedLevel == 1) {
            path = "";
        }
        else {
            key = path.substring(path.lastIndexOf('/') + 1);
            path = path.substring((0), path.lastIndexOf('/'));
        }
        if (node.at(path).has(key)) {
            modifyJson(node, key, value);
            Object body = mapper.convertValue(node, Object.class);
            commonLibrary.logObject(body);
            memory.setGeneratedObject(body);
        }
        else {
            logger.error("We could not find the key: " + originalKey + " in the body. Please check Cucumber Feature.");
            throw new NullPointerException("We could not find the key: " + originalKey + " in the body. Please check Cucumber Feature.");
        }
    }

    @Given("^I modify the (?:JSON|json) attributes to be the following:$")
    public void ModifyJsonAttributeTable(Map<String, String> map) throws IOException {
        for (Map.Entry<String, String> entry : map.entrySet()) {
            String key = commonLibrary.checkForVariables(entry.getKey());
            String value = commonLibrary.checkForVariables(entry.getValue());
            logger.debug("Modifying then JSON attribute at: " + key + " to be: " + value);
            String originalKey = key;
            ObjectMapper mapper = new ObjectMapper();
            String jsonAsString = mapper.writeValueAsString(memory.getGeneratedObject());
            JsonNode node = mapper.readTree(jsonAsString);
            String path = "/" + key.replace(".", "/").replace("[", "/").replace("]/", "/").replace("]", "/");
            int nestedLevel = path.length() - path.replace("/", "").length();
            if (nestedLevel == 1) {
                path = "";
            }
            else {
                key = path.substring(path.lastIndexOf('/') + 1);
                path = path.substring((0), path.lastIndexOf('/'));
            }
            if (node.at(path).has(key)) {
                modifyJson(node, key, value);
                Object body = mapper.convertValue(node, Object.class);
                memory.setGeneratedObject(body);
            }
            else {
                logger.error("We could not find the key: " + originalKey + " in the json body. Please check Cucumber Feature.");
                throw new NullPointerException("We could not find the key: " + originalKey + " in the json body. Please check Cucumber Feature.");
            }
        }
    }

    // ================================================================================================================
    // GENERIC CUCUMBER STEP DEFINITIONS FOR REST ASSURED FUNCTIONS
    // ================================================================================================================

    @When("^I send a (GET|POST|PUT|DELETE|PATCH) request to \"(.*)\"$")
    public void SendBasicRest(String requestType, String destination) {
        destination = commonLibrary.checkForVariables(destination);
        Response response;
        switch(requestType.toLowerCase()) {
            case "get":
                response = restCommonLibrary.GET_REQUEST(
                        destination,
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "post":
                response = restCommonLibrary.POST_REQUEST(
                        destination,
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "put":
                response = restCommonLibrary.PUT_REQUEST(
                        destination,
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "delete":
                response = restCommonLibrary.DELETE_REQUEST(
                        destination,
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "patch":
                response = restCommonLibrary.PATCH_REQUEST(
                        destination,
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

    @When("^I send a (GET|POST|PUT|DELETE|PATCH) request to \"(.*)\" with (?:JSON|json) body:$")
    public void SendBasicRestBody(String requestType, String destination, String body) {
        Response response;
        destination = commonLibrary.checkForVariables(destination);
        switch(requestType.toLowerCase()) {
            case "get":
                response = restCommonLibrary.GET_REQUEST_BODY(
                        destination,
                        body,
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "post":
                response = restCommonLibrary.POST_REQUEST_BODY(
                        destination,
                        body,
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "put":
                response = restCommonLibrary.PUT_REQUEST_BODY(
                        destination,
                        body,
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "delete":
                response = restCommonLibrary.DELETE_REQUEST_BODY(
                        destination,
                        body,
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "patch":
                response = restCommonLibrary.PATCH_REQUEST_BODY(
                        destination,
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

    @When("^I send a (GET|POST|PUT|DELETE|PATCH) request to \"(.*)\" with the generated body$")
    public void SendRestGenBody(String requestType, String destination){
        Response response;
        destination = commonLibrary.checkForVariables(destination);
        switch(requestType.toLowerCase()) {
            case "get":
                response = restCommonLibrary.GET_REQUEST_BODY(
                        destination,
                        memory.getGeneratedObject(),
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "post":
                response = restCommonLibrary.POST_REQUEST_BODY(
                        destination,
                        memory.getGeneratedObject(),
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "put":
                response = restCommonLibrary.PUT_REQUEST_BODY(
                        destination,
                        memory.getGeneratedObject(),
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "delete":
                response = restCommonLibrary.DELETE_REQUEST_BODY(
                        destination,
                        memory.getGeneratedObject(),
                        memory.getContentTypeHeader(),
                        memory.getAcceptHeader(),
                        memory.getCustomHeaders(),
                        memory.getCustomCookies()
                );
                break;
            case "patch":
                response = restCommonLibrary.PATCH_REQUEST_BODY(
                        destination,
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

}
