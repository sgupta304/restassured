package lib.common;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.restassured.response.Response;
import lib.framework.BaseTestCase;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.Calendar;
import java.util.Random;
import java.util.UUID;

/**
 * This class will hold all generic and common functions. This includes generic REST operations from RESTAssured
 *
 * @Author Brian DeSimone
 * @Date 12/12/2017
 */
public class CommonLibrary extends BaseTestCase {

    // GLOBAL CLASS VARIABLES
    private static Logger logger = LogManager.getLogger(CommonLibrary.class);

    // ================================================================================================================
    // GENERIC FUNCTIONS
    // ================================================================================================================

    /**
     * This method will generate a non "valid" uxdid to use in a token
     * @return the string form of the uxdid
     */
    public String genUxdid(){
        return "QE-uxdid_" + UUID.randomUUID().toString() + UUID.randomUUID().toString();
    }

    /**
     * This method will generate a random tracking ID to use
     * @return the trackingId as a string
     */
    public String genTrackingId(){
        return "QE-trackingId_" + UUID.randomUUID().toString();
    }

    /**
     * This method will generate a random string
     */
    public String generateRandomString(int stringLength){
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        StringBuilder stringBuilder = new StringBuilder();
        Random rnd = new Random();
        while (stringBuilder.length() <= stringLength) { // length of the random string.
            int index = (int) (rnd.nextFloat() * chars.length());
            stringBuilder.append(chars.charAt(index));
        }
        return stringBuilder.toString();
    }

    /**
     * This method will create a random IP address as a string
     * @return will return an IP address
     */
    public String genRandomIpAddress(){
        Random rand = new Random();
        return rand.nextInt(256) + "." + rand.nextInt(256) + "."
                + rand.nextInt(256) + "." + rand.nextInt(256);
    }

    /**
     * This method will generate a random mac address and build a string
     * @return random macaddress
     */
    public String genRandomMacAddress(){
        Random rand = new Random();
        byte[] macAddress = new byte[6];
        rand.nextBytes(macAddress);
        macAddress[0] = (byte)(macAddress[0] & (byte)254);
        StringBuilder stringBuilder = new StringBuilder(18);
        for(byte b : macAddress){
            if(stringBuilder.length() > 0)
                stringBuilder.append(":");
            stringBuilder.append(String.format("%02x", b));
        }
        return stringBuilder.toString();
    }

    /**
     * generate a random email address with 14 chars and @qeaeutomail.com
     * @return random email as a string
     */
    public String genRandomEmailAddress(){
        char[] chars = "abcdefghijklmnopqrstuvwxyz".toCharArray();
        Random rand = new Random();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 14; i++) {
            char c = chars[rand.nextInt(chars.length)];
            sb.append(c);
        }
        return sb.toString() + "@qeautomail.com";
    }

    /**
     * generate a epoch time stamp in the future
     * @param hours integer value of hours in the future
     * @return the time in epoch
     */
    public String genFutureEpochTime(int hours){
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.HOUR, hours);
        return Long.toString(calendar.getTimeInMillis());
    }

    /**
     * Generate an epoch time stamp with the current time and add seconds
     * @param seconds the seconds we wish the time to be in the future
     * @return the time in epoch
     */
    public String genFutureEpochTimeSeconds(int seconds){
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.SECOND, seconds);
        return Long.toString(calendar.getTimeInMillis());
    }

    /**
     * This method will get the value of a JSON key and return
     * @return value of json key
     */
    public String getJSONResponseValue(Response response, String key){
        return response.jsonPath().get(key).toString();
    }

    /**
     * Take an input string and change all vars if present to the memory value
     * This method is recursive
     * @param inputStr the string without the actual var
     * @return the string with the vars replaced
     */
    public String checkForVariables(String inputStr){
        String theDestination = inputStr;
        if (!inputStr.isEmpty()) {
            if (inputStr.contains("%{")) {
                int start = inputStr.indexOf('{');
                int end = inputStr.indexOf('}');
                String temp = inputStr.substring(start + 1, end);
                if (memory.retrieveValue(temp) == null){
                    logger.error("We could not find a value stored in memory with the key: " + temp + ". Please check your feature to make sure it was stored properly.");
                    throw new NullPointerException("We could not find a value stored in memory with the key: " + temp + ". Please check your feature to make sure it was stored properly.");
                }
                String theVar = memory.retrieveValue(temp);
                theDestination = inputStr.substring(0, (start - 1)) + theVar + inputStr.substring(end + 1, inputStr.length());
                return checkForVariables(theDestination);
            }
            return theDestination;
        }
        return theDestination;
    }

    /**
     * This method logs the object that is created as a pojo using jackson object mapper.
     * @param rawObject the raw java object that is logged as json
     */
    public void logObject(Object rawObject){
        try {
            ObjectMapper mapper = new ObjectMapper();
            logger.debug("JSON-OBJECT: Logging object we created: " + mapper.writeValueAsString(rawObject));
        }
        catch (JsonProcessingException ex){
            logger.error("Could not parse object: " + ex);
        }
    }

    /**
     * Method to generate the captcha result from the values stored in memory
     * @return the captcha result
     */
    public String GetCaptchaResult(String valuesToValidate){
        logger.debug("Adding/Subtracting the captcha values to get the result to validate: " + valuesToValidate);
        int a = Character.getNumericValue(valuesToValidate.charAt(0));
        int b = Character.getNumericValue(valuesToValidate.charAt(valuesToValidate.length() - 1));
        char operation = valuesToValidate.charAt(2);
        if (operation == '+'){
            return Integer.toString(a + b);
        }
        else{
            return Integer.toString(a - b);
        }
    }

}
