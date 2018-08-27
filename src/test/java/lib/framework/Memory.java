package lib.framework;

import io.restassured.http.Cookies;
import io.restassured.http.Headers;
import io.restassured.response.Response;

import javax.ws.rs.core.MediaType;
import java.util.HashMap;
import java.util.Map;

/**
 * Simple memory class that will store last response from rest assured for use inside other cucumber steps. Additional
 * storage and items will be kept here such as generated objects and selenium items.
 *
 * @Author Brian DeSimone
 * @Date 12/12/2017
 */
public class Memory {

    // GLOBAL CLASS VARIABLES
    private Response lastResponse;
    private String contentTypeHeader = MediaType.APPLICATION_JSON;                      // DEFAULTS TO JSON
    private String acceptHeader = MediaType.APPLICATION_JSON;                           // DEFAULTS TO JSON
    private Headers customHeaders;
    private Cookies customCookies;
    private Map<String, String> storage = new HashMap<>();
    private Object generatedObject;

    // CONSTRUCTORS FOR MEMORY AND AIRLINE SETUP
    /**
     * Empty constructor from memory with no airline info
     */
    public Memory(){

    }

    /**
     * Constructor with airline info included from main configs of test suite
     * @param airlineCode the airline code
     * @param tailNumber the tail number
     * @param flightNumber the flight number
     */
    public Memory(String airlineCode, String tailNumber, String flightNumber){
        saveValue("airline_code", airlineCode);
        saveValue("tail_number", tailNumber);
        saveValue("flight_number", flightNumber);
    }

    // FUNCTIONS OF MEMORY
    /**
     * saves a value in memory
     * @param key the key to store the value at
     * @param value the value of the storage
     */
    public void saveValue(String key, String value){
        storage.put(key, value);
    }

    /**
     * retreives a value from a key in memory
     * @param key the key of the memory object desired
     * @return the value of the memory object
     */
    public String retrieveValue(String key){
        return storage.get(key);
    }

    // GETTERS AND SETTERS
    public Response getLastResponse() {
        return lastResponse;
    }

    public void setLastResponse(Response lastResponse) {
        this.lastResponse = lastResponse;
    }

    public String getContentTypeHeader() {
        return contentTypeHeader;
    }

    public void setContentTypeHeader(String contentTypeHeader) {
        this.contentTypeHeader = contentTypeHeader;
    }

    public String getAcceptHeader() {
        return acceptHeader;
    }

    public void setAcceptHeader(String acceptHeader) {
        this.acceptHeader = acceptHeader;
    }

    public Object getGeneratedObject() {
        return generatedObject;
    }

    public void setGeneratedObject(Object generatedObject) {
        this.generatedObject = generatedObject;
    }

    public Headers getCustomHeaders() {
        return customHeaders;
    }

    public void setCustomHeaders(Headers customHeaders) {
        this.customHeaders = customHeaders;
    }

    public Cookies getCustomCookies() {
        return customCookies;
    }

    public void setCustomCookies(Cookies customCookies) {
        this.customCookies = customCookies;
    }
} // end class Memory