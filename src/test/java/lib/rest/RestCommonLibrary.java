package lib.rest;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.restassured.http.Cookies;
import io.restassured.http.Headers;
import io.restassured.response.Response;
import lib.framework.BaseTestCase;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import static io.restassured.RestAssured.given;

/**
 * This class holds all REST common functions that are sent with rest assured
 *
 * @Author Brian DeSimone
 * @Date 11/20/2017
 */
public class RestCommonLibrary extends BaseTestCase {

    // GLOBAL CLASS VARIABLES
    private static Logger logger = LogManager.getLogger(RestCommonLibrary.class);
    
    // VARIABLES
    private static final String LOG_RESPONSE = "REST-ASSURED: The response from the request is: ";
    private static final String LOG_HEADERS = "REST-ASSURED: The request was sent with custom headers: ";
    private static final String LOG_COOKIES = "REST-ASSURED: The request was sent with custom cookies: ";
    private static final String PARSE_ERROR = "JSON PARSE ERROR: ";

    // ================================================================================================================
    // REST ASSURED COMMON GENERIC FUNCTIONS
    // ================================================================================================================

    /**
     * REST ASSURED GET request method
     *
     * @param url destination of the request
     * @return Response object that has the REST response
     */
    public Response GET_REQUEST(String url, String contentHeader, String acceptHeader, Headers headers, Cookies cookies) {
        Response getResponse;
        logger.debug("REST-ASSURED: Sending a GET request to " + url);
        if (headers != null && cookies != null){
            logger.debug(LOG_HEADERS + headers.asList().toString());
            logger.debug(LOG_COOKIES + cookies.asList().toString());
            getResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .headers(headers)
                    .cookies(cookies)
                    .log()
                    .all()
                    .when()
                    .get(url)
                    .then()
                    .extract()
                    .response();
        }
        else if (headers != null && cookies == null){
            logger.debug(LOG_HEADERS + headers.asList().toString());
            getResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .headers(headers)
                    .log()
                    .all()
                    .when()
                    .get(url)
                    .then()
                    .extract()
                    .response();
        }
        else if (headers == null && cookies != null){
            logger.debug(LOG_COOKIES + cookies.asList().toString());
            getResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .cookies(cookies)
                    .log()
                    .all()
                    .when()
                    .get(url)
                    .then()
                    .extract()
                    .response();
        }
        else {
            getResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .log()
                    .all()
                    .when()
                    .get(url)
                    .then()
                    .extract()
                    .response();
        }
        // log then response
        logger.debug(LOG_RESPONSE + getResponse.asString());
        return getResponse;
    } // end GET_REQUEST



    /**
     * REST ASSURED GET request method with body
     *
     * @param body the body of the request
     * @param url destination of the request
     * @return Response object that has the REST response
     */
    public Response GET_REQUEST_BODY(String url, Object body, String contentHeader, String acceptHeader, Headers headers, Cookies cookies) {
        Response getResponse;
        ObjectMapper mapper = new ObjectMapper();
        try {
            String bodyAsString = mapper.writeValueAsString(body);
            logger.debug("REST-ASSURED: Sending a GET request to " + url);
            logger.debug("REST-ASSURED: The GET request is sent with the body: " + bodyAsString);
        }
        catch (JsonProcessingException e) {
            logger.error(PARSE_ERROR + e);
        }
        if (headers != null && cookies != null){
            logger.debug(LOG_HEADERS + headers.asList().toString());
            logger.debug(LOG_COOKIES + cookies.asList().toString());
            getResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .headers(headers)
                    .cookies(cookies)
                    .body(body)
                    .log()
                    .all()
                    .when()
                    .get(url)
                    .then()
                    .extract()
                    .response();
        }
        else if (headers != null && cookies == null){
            logger.debug(LOG_HEADERS + headers.asList().toString());
            getResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .headers(headers)
                    .body(body)
                    .log()
                    .all()
                    .when()
                    .get(url)
                    .then()
                    .extract()
                    .response();
        }
        else if (headers == null && cookies != null){
            logger.debug(LOG_COOKIES + cookies.asList().toString());
            getResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .cookies(cookies)
                    .body(body)
                    .log()
                    .all()
                    .when()
                    .get(url)
                    .then()
                    .extract()
                    .response();
        }
        else {
            getResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .body(body)
                    .log()
                    .all()
                    .when()
                    .get(url)
                    .then()
                    .extract()
                    .response();
        }
        // log then response
        logger.debug(LOG_RESPONSE + getResponse.asString());
        return getResponse;
    } // end GET_REQUEST



    /**
     * REST ASSURED POST request method
     *
     * @param url destination of the request
     * @return Response object that has the REST response
     */
    public Response POST_REQUEST(String url, String contentHeader, String acceptHeader, Headers headers, Cookies cookies) {
        Response postResponse;
        logger.debug("REST-ASSURED: Sending a POST request to " + url);
        if (headers != null && cookies != null){
            logger.debug(LOG_HEADERS + headers.asList().toString());
            logger.debug(LOG_COOKIES + cookies.asList().toString());
            postResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .headers(headers)
                    .cookies(cookies)
                    .log()
                    .all()
                    .when()
                    .post(url)
                    .then()
                    .extract()
                    .response();
        }
        else if (headers != null && cookies == null){
            logger.debug(LOG_HEADERS + headers.asList().toString());
            postResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .headers(headers)
                    .log()
                    .all()
                    .when()
                    .post(url)
                    .then()
                    .extract()
                    .response();
        }
        else if (headers == null && cookies != null){
            logger.debug(LOG_COOKIES + cookies.asList().toString());
            postResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .cookies(cookies)
                    .log()
                    .all()
                    .when()
                    .post(url)
                    .then()
                    .extract()
                    .response();
        }
        else {
            postResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .log()
                    .all()
                    .when()
                    .post(url)
                    .then()
                    .extract()
                    .response();
        }
        // log then response
        logger.debug(LOG_RESPONSE + postResponse.asString());
        return postResponse;
    } // end POST_REQUEST



    /**
     * REST ASSURED POST request method with body
     *
     * @param url destination of the request
     * @param body the body we wish to post with the request
     * @return Response object that has the REST response
     */
    public Response POST_REQUEST_BODY(String url, Object body, String contentHeader, String acceptHeader, Headers headers, Cookies cookies) {
        Response postResponse;
        ObjectMapper mapper = new ObjectMapper();
        try {
            String bodyAsString = mapper.writeValueAsString(body);
            logger.debug("REST-ASSURED: Sending a POST request to " + url);
            logger.debug("REST-ASSURED: The POST request is sent with the body: " + bodyAsString);
        }
        catch (JsonProcessingException e) {
            logger.error(PARSE_ERROR + e);
        }
        if (headers != null && cookies != null){
            logger.debug(LOG_HEADERS + headers.asList().toString());
            logger.debug(LOG_COOKIES + cookies.asList().toString());
            postResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .headers(headers)
                    .cookies(cookies)
                    .body(body)
                    .log()
                    .all()
                    .when()
                    .post(url)
                    .then()
                    .extract()
                    .response();
        }
        else if (headers != null && cookies == null){
            logger.debug(LOG_HEADERS + headers.asList().toString());
            postResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .headers(headers)
                    .body(body)
                    .log()
                    .all()
                    .when()
                    .post(url)
                    .then()
                    .extract()
                    .response();
        }
        else if (headers == null && cookies != null){
            logger.debug(LOG_COOKIES + cookies.asList().toString());
            postResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .cookies(cookies)
                    .body(body)
                    .log()
                    .all()
                    .when()
                    .post(url)
                    .then()
                    .extract()
                    .response();
        }
        else {
            postResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .body(body)
                    .log()
                    .all()
                    .when()
                    .post(url)
                    .then()
                    .extract()
                    .response();
        }
        // log then response
        logger.debug(LOG_RESPONSE + postResponse.asString());
        return postResponse;
    } // end POST_REQUEST



    /**
     * REST ASSURED PUT request method
     *
     * @param url destination of the request
     * @return Response object that has the REST response
     */
    public Response PUT_REQUEST(String url, String contentHeader, String acceptHeader, Headers headers, Cookies cookies) {
        Response putResponse;
        logger.debug("REST-ASSURED: Sending a PUT request to " + url);
        if (headers != null && cookies != null){
            logger.debug(LOG_HEADERS + headers.asList().toString());
            logger.debug(LOG_COOKIES + cookies.asList().toString());
            putResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .headers(headers)
                    .cookies(cookies)
                    .log()
                    .all()
                    .when()
                    .put(url)
                    .then()
                    .extract()
                    .response();
        }
        else if (headers != null && cookies == null){
            logger.debug(LOG_HEADERS + headers.asList().toString());
            putResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .headers(headers)
                    .log()
                    .all()
                    .when()
                    .put(url)
                    .then()
                    .extract()
                    .response();
        }
        else if (headers == null && cookies != null){
            logger.debug(LOG_COOKIES + cookies.asList().toString());
            putResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .cookies(cookies)
                    .log()
                    .all()
                    .when()
                    .put(url)
                    .then()
                    .extract()
                    .response();
        }
        else {
            putResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .log()
                    .all()
                    .when()
                    .put(url)
                    .then()
                    .extract()
                    .response();
        }
        // log then response
        logger.debug(LOG_RESPONSE + putResponse.asString());
        return putResponse;
    } // end PUT_REQUEST



    /**
     * REST ASSURED PUT request method
     *
     * @param body the body of the request
     * @param url destination of the request
     * @return Response object that has the REST response
     */
    public Response PUT_REQUEST_BODY(String url, Object body, String contentHeader, String acceptHeader, Headers headers, Cookies cookies) {
        Response putResponse;
        ObjectMapper mapper = new ObjectMapper();
        try {
            String bodyAsString = mapper.writeValueAsString(body);
            logger.debug("REST-ASSURED: Sending a PUT request to " + url);
            logger.debug("REST-ASSURED: The PUT request is sent with the body: " + bodyAsString);
        }
        catch (JsonProcessingException e) {
            logger.error(PARSE_ERROR + e);
        }
        if (headers != null && cookies != null){
            logger.debug(LOG_HEADERS + headers.asList().toString());
            logger.debug(LOG_COOKIES + cookies.asList().toString());
            putResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .headers(headers)
                    .cookies(cookies)
                    .body(body)
                    .log()
                    .all()
                    .when()
                    .put(url)
                    .then()
                    .extract()
                    .response();
        }
        else if (headers != null && cookies == null){
            logger.debug(LOG_HEADERS + headers.asList().toString());
            putResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .headers(headers)
                    .body(body)
                    .log()
                    .all()
                    .when()
                    .put(url)
                    .then()
                    .extract()
                    .response();
        }
        else if (headers == null && cookies != null){
            logger.debug(LOG_COOKIES + cookies.asList().toString());
            putResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .cookies(cookies)
                    .body(body)
                    .log()
                    .all()
                    .when()
                    .put(url)
                    .then()
                    .extract()
                    .response();
        }
        else {
            putResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .body(body)
                    .log()
                    .all()
                    .when()
                    .put(url)
                    .then()
                    .extract()
                    .response();
        }
        // log then response
        logger.debug(LOG_RESPONSE + putResponse.asString());
        return putResponse;
    } // end PUT_REQUEST



    /**
     * REST ASSURED DELETE request method
     *
     * @param url destination of the request
     * @return Response object that has the REST response
     */
    public Response DELETE_REQUEST(String url, String contentHeader, String acceptHeader, Headers headers, Cookies cookies) {
        Response deleteResponse;
        logger.debug("REST-ASSURED: Sending a DELETE request to " + url);
        if (headers != null && cookies != null){
            logger.debug(LOG_HEADERS + headers.asList().toString());
            logger.debug(LOG_COOKIES + cookies.asList().toString());
            deleteResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .headers(headers)
                    .cookies(cookies)
                    .log()
                    .all()
                    .when()
                    .delete(url)
                    .then()
                    .extract()
                    .response();
        }
        else if (headers != null && cookies == null){
            logger.debug(LOG_HEADERS + headers.asList().toString());
            deleteResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .headers(headers)
                    .log()
                    .all()
                    .when()
                    .delete(url)
                    .then()
                    .extract()
                    .response();
        }
        else if (headers == null && cookies != null){
            logger.debug(LOG_COOKIES + cookies.asList().toString());
            deleteResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .cookies(cookies)
                    .log()
                    .all()
                    .when()
                    .delete(url)
                    .then()
                    .extract()
                    .response();
        }
        else {
            deleteResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .log()
                    .all()
                    .when()
                    .delete(url)
                    .then()
                    .extract()
                    .response();
        }
        // log then response
        logger.debug(LOG_RESPONSE + deleteResponse.asString());
        return deleteResponse;
    } // end DELETE_REQUEST



    /**
     * REST ASSURED DELETE request method
     *
     * @param body the body of the request
     * @param url destination of the request
     * @return Response object that has the REST response
     */
    public Response DELETE_REQUEST_BODY(String url, Object body, String  contentHeader, String acceptHeader, Headers headers, Cookies cookies) {
        Response deleteResponse;
        ObjectMapper mapper = new ObjectMapper();
        try {
            String bodyAsString = mapper.writeValueAsString(body);
            logger.debug("REST-ASSURED: Sending a DELETE request to " + url);
            logger.debug("REST-ASSURED: The DELETE request is sent with the body: " + bodyAsString);
        }
        catch (JsonProcessingException e) {
            logger.error(PARSE_ERROR + e);
        }
        if (headers != null && cookies != null){
            logger.debug(LOG_HEADERS + headers.asList().toString());
            logger.debug(LOG_COOKIES + cookies.asList().toString());
            deleteResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .headers(headers)
                    .cookies(cookies)
                    .body(body)
                    .log()
                    .all()
                    .when()
                    .delete(url)
                    .then()
                    .extract()
                    .response();
        }
        else if (headers != null && cookies == null){
            logger.debug(LOG_HEADERS + headers.asList().toString());
            deleteResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .headers(headers)
                    .body(body)
                    .log()
                    .all()
                    .when()
                    .delete(url)
                    .then()
                    .extract()
                    .response();
        }
        else if (headers == null && cookies != null){
            logger.debug(LOG_COOKIES + cookies.asList().toString());
            deleteResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .cookies(cookies)
                    .body(body)
                    .log()
                    .all()
                    .when()
                    .delete(url)
                    .then()
                    .extract()
                    .response();
        }
        else {
            deleteResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .body(body)
                    .log()
                    .all()
                    .when()
                    .delete(url)
                    .then()
                    .extract()
                    .response();
        }
        // log then response
        logger.debug(LOG_RESPONSE + deleteResponse.asString());
        return deleteResponse;
    } // end DELETE_REQUEST



    /**
     * REST ASSURED PATCH request method
     *
     * @param url destination of the request
     * @return Response object that has the REST response
     */
    public Response PATCH_REQUEST(String url, String contentHeader, String acceptHeader, Headers headers, Cookies cookies) {
        Response patchResponse;
        logger.debug("REST-ASSURED: Sending a PATCH request to " + url);
        if (headers != null && cookies != null){
            logger.debug(LOG_HEADERS + headers.asList().toString());
            logger.debug(LOG_COOKIES + cookies.asList().toString());
            patchResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .headers(headers)
                    .cookies(cookies)
                    .log()
                    .all()
                    .when()
                    .patch(url)
                    .then()
                    .extract()
                    .response();
        }
        else if (headers != null && cookies == null){
            logger.debug(LOG_HEADERS + headers.asList().toString());
            patchResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .headers(headers)
                    .log()
                    .all()
                    .when()
                    .patch(url)
                    .then()
                    .extract()
                    .response();
        }
        else if (headers == null && cookies != null){
            logger.debug(LOG_COOKIES + cookies.asList().toString());
            patchResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .cookies(cookies)
                    .log()
                    .all()
                    .when()
                    .patch(url)
                    .then()
                    .extract()
                    .response();
        }
        else {
            patchResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .log()
                    .all()
                    .when()
                    .patch(url)
                    .then()
                    .extract()
                    .response();
        }
        // log then response
        logger.debug(LOG_RESPONSE + patchResponse.asString());
        return patchResponse;
    } // end PATCH_REQUEST



    /**
     * REST ASSURED PATCH request method
     *
     * @param body the body of the request
     * @param url destination of the request
     * @return Response object that has the REST response
     */
    public Response PATCH_REQUEST_BODY(String url, Object body, String  contentHeader, String acceptHeader, Headers headers, Cookies cookies) {
        Response patchResponse;
        ObjectMapper mapper = new ObjectMapper();
        try {
            String bodyAsString = mapper.writeValueAsString(body);
            logger.debug("REST-ASSURED: Sending a PATCH request to " + url);
            logger.debug("REST-ASSURED: The PATCH request is sent with the body: " + bodyAsString);
        }
        catch (JsonProcessingException e) {
            logger.error(PARSE_ERROR + e);
        }
        if (headers != null && cookies != null){
            logger.debug(LOG_HEADERS + headers.asList().toString());
            logger.debug(LOG_COOKIES + cookies.asList().toString());
            patchResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .headers(headers)
                    .cookies(cookies)
                    .body(body)
                    .log()
                    .all()
                    .when()
                    .patch(url)
                    .then()
                    .extract()
                    .response();
        }
        else if (headers != null && cookies == null){
            logger.debug(LOG_HEADERS + headers.asList().toString());
            patchResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .headers(headers)
                    .body(body)
                    .log()
                    .all()
                    .when()
                    .patch(url)
                    .then()
                    .extract()
                    .response();
        }
        else if (headers == null && cookies != null){
            logger.debug(LOG_COOKIES + cookies.asList().toString());
            patchResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .cookies(cookies)
                    .body(body)
                    .log()
                    .all()
                    .when()
                    .patch(url)
                    .then()
                    .extract()
                    .response();
        }
        else {
            patchResponse = given()
                    .contentType(contentHeader)
                    .accept(acceptHeader)
                    .body(body)
                    .log()
                    .all()
                    .when()
                    .patch(url)
                    .then()
                    .extract()
                    .response();
        }
        // log then response
        logger.debug(LOG_RESPONSE + patchResponse.asString());
        return patchResponse;
    } // end PATCH_REQUEST

}