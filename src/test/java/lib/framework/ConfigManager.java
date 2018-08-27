package lib.framework;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.testng.Assert;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * This is a config loader class that will read in config files for the tests and allocate them correctly
 * You will be able to get and set configs from this manager
 *
 * @Author Brian DeSimone
 * @Date 01/08/2018
 */
public class ConfigManager {

    // GLOBAL CLASS VARIABLES
    private static Logger logger = LogManager.getLogger(ConfigManager.class);
    private Properties prop;

    // CONFIG VARIABLES
    private String testEnvironment;
    private String airlineCode;
    private String tailNumber;
    private String flightNumber;

    // LRU & vACPU CONFIG VARIABLES
    private String environmentSource;
    private String abpSource;
    private String lru;

    // TMO LEGACY VARIABLES
    private String tmoPhoneNumber;
    private String tmoOnePlusPhoneNumber;
    private String tmoNoZipPhoneNumber;
    private String tmoZipCode;
    private String tmoOnePlusZipCode;

    // TMO EAP VARIABLES
    private String tmoEapServiceCode;
    private String tmoEapOnePlusServiceCode;

    // APPLICATION URIs
    private String ABP_URI;
    private String APIDECORATOR_URI;
    private String CLOUDDAO_URI;
    private String CPAPI_URI;
    private String FIG_URI;
    private String FLIGHTINFO_URI;
    private String GBPEDGE_URI;
    private String GBPLITE_URI;
    private String GROUNDGATEWAY_URI;
    private String IFSGATEWAY_URI;
    private String IFSUTILS_URI;
    private String RUPP_URI;
    private String SCEMS_URI;
    private String SESSIONMANAGEMENT_URI;
    private String STUB_URI;

    /**
     * Constructor for the ConfigManger. Loads the properties file and logs its location. Also does a generic config setup
     */
    public ConfigManager() {
        try {
            logger.info("We have created a Config Manager. Beginning to read properties!");
            prop = new Properties();
            InputStream inputStream = new FileInputStream(System.getProperty("user.dir") + "//src//config//test.properties");
            prop.load(inputStream);
            logger.info("Setting test configs from " + System.getProperty("user.dir") + "/src/config/test.properties");
            setConfigs();
            validateConfigs();
            setupTestEnvironment();
            setupTestSource();
        }
        catch(IOException e) {
            logger.error("Could not find the properties file.\n" + e);
        }
    } // end constructor

    /**
     * sets all of the configs in the file to the proper global variables so we can use them later
     */
    private void setConfigs(){
        // Set up the environment configs
        this.testEnvironment = prop.getProperty("testEnvironment");
        this.airlineCode = prop.getProperty("airlineCode");
        this.tailNumber = prop.getProperty("tailNumber");
        this.flightNumber = prop.getProperty("flightNumber");
        // Set up the LRU/VACPU/AWS configs
        this.environmentSource = prop.getProperty("environmentSource");
        this.abpSource = prop.getProperty("abpSource");
        this.lru = prop.getProperty("lru");
        // Set up the TMO and EAP configs
        this.tmoPhoneNumber = prop.getProperty("tmoPhoneNumber");
        this.tmoNoZipPhoneNumber = prop.getProperty("tmoNoZipPhoneNumber");
        this.tmoOnePlusPhoneNumber = prop.getProperty("tmoOnePlusPhoneNumber");
        this.tmoZipCode = prop.getProperty("tmoZipCode");
        this.tmoOnePlusZipCode = prop.getProperty("tmoOnePlusZipCode");
        this.tmoEapServiceCode = prop.getProperty("tmoEapServiceCode");
        this.tmoEapOnePlusServiceCode = prop.getProperty("tmoEapOnePlusServiceCode");
        logger.info("Configs from properties file are set.");
    }

    /**
     * Validate configuration values in the properties file are not null or empty.
     */
    private void validateConfigs(){
        logger.info("We have found the following configs: ");
        for (String key : prop.stringPropertyNames()){
            String value = prop.getProperty(key);
            logger.info(key + ": " + value);
            if (key.isEmpty()){
                logger.error("Missing property from the test.properties file at: " + key);
                Assert.fail("See error logs and fix the missing test property.");
            }
        }
    }

    /**
     * Method to set up the test environment. This comes from system property first and defaults to the
     * test.properties file second as set in the setConfigs method in this class.
     */
    private void setupTestEnvironment(){
        // Set the test env
        if (getSystemProperty("test.environment") == null || getSystemProperty("test.environment").isEmpty()) {
            setSystemProperty("test.environment", this.testEnvironment);
            logger.info("There was no system testEnvironment property set. Setting from test.properties.");
            logger.info("Test environment: " + this.testEnvironment);
        }
        else {
            // Override the test environment in the config file with the system parameter
            this.testEnvironment = getSystemProperty("test.environment");
            logger.info("The test environment is set: " + this.testEnvironment);
        }
    }

    /**
     * Method to set up the environment source. This comes from the system property first and defaults to the
     * test.properties file second as set in the setConfigs method in this class.
     * This is where we decide if we are testing on the vACPU, LRU, or SSID to run tests against
     */
    private void setupTestSource(){
        if (getSystemProperty("environment.source") == null || getSystemProperty("environment.source").isEmpty()){
            setSystemProperty("environment.source", this.environmentSource);
            logger.info("There was no system environment source property set. Setting from test.properties.");
            logger.info("Test environment source: " + this.environmentSource);
        }
        else {
            this.environmentSource = getSystemProperty("environment.source");
            logger.info("System property for test environment source was found. Setting to: " + this.environmentSource);
        }
        if (getSystemProperty("abp.source") == null || getSystemProperty("abp.source").isEmpty()){
            setSystemProperty("abp.source", this.abpSource);
            logger.info("There was no system abp source property set. Setting from test.properties.");
            logger.info("Test abp source: " + this.abpSource);
        }
        else {
            this.abpSource = getSystemProperty("abp.source");
            logger.info("System property for test abp source was found. Setting to: " + this.abpSource);
        }
        if (getSystemProperty("lru") == null || getSystemProperty("lru").isEmpty()){
            setSystemProperty("lru", this.lru);
            logger.info("There was no lru property set. Setting from test.properties.");
            logger.info("LRU: " + this.lru);
        }
        else {
            this.lru = getSystemProperty("lru");
            logger.info("System property for LRU was found. Setting to: " + this.lru);
        }
    }

    /**
     * Method to get a system property and return its value
     */
    public String getSystemProperty(String key) {
        return System.getProperty(key);
    }

    /**
     * Method to set a system property by key value pair
     */
    public void setSystemProperty(String key, String value){
        System.setProperty(key, value);
    }

    // GETTERS AND SETTERS FOR ENVIRONMENT
    
    public String getTestEnvironment() {
        return testEnvironment;
    }

    public void setTestEnvironment(String testEnvironment) {
        this.testEnvironment = testEnvironment;
    }

    public String getEnvironmentSource() {
        return environmentSource;
    }

    public void setEnvironmentSource(String environmentSource) {
        this.environmentSource = environmentSource;
    }

    public String getAbpSource() {
        return abpSource;
    }

    public void setAbpSource(String abpSource) {
        this.abpSource = abpSource;
    }

    public String getLru() {
        return lru;
    }

    public void setLru(String lru) {
        this.lru = lru;
    }

    public String getAirlineCode() {
        return airlineCode;
    }

    public void setAirlineCode(String airlineCode) {
        this.airlineCode = airlineCode;
    }

    public String getTailNumber() {
        return tailNumber;
    }

    public void setTailNumber(String tailNumber) {
        this.tailNumber = tailNumber;
    }

    public String getFlightNumber() {
        return flightNumber;
    }

    public void setFlightNumber(String flightNumber) {
        this.flightNumber = flightNumber;
    }

    // GETTERS FOR TMO

    public String getTmoPhoneNumber() {
        return tmoPhoneNumber;
    }

    public String getTmoOnePlusPhoneNumber() {
        return tmoOnePlusPhoneNumber;
    }

    public String getTmoNoZipPhoneNumber() {
        return tmoNoZipPhoneNumber;
    }

    public String getTmoZipCode() {
        return tmoZipCode;
    }

    public String getTmoOnePlusZipCode() {
        return tmoOnePlusZipCode;
    }

    public String getTmoEapServiceCode() {
        return tmoEapServiceCode;
    }

    public String getTmoEapOnePlusServiceCode() {
        return tmoEapOnePlusServiceCode;
    }


    // GETTERS AND SETTERS FOR URIs

    public String getABP_URI() {
        return ABP_URI;
    }

    public void setABP_URI(String ABP_URI) {
        this.ABP_URI = ABP_URI;
    }

    public String getAPIDECORATOR_URI() {
        return APIDECORATOR_URI;
    }

    public void setAPIDECORATOR_URI(String APIDECORATOR_URI) {
        this.APIDECORATOR_URI = APIDECORATOR_URI;
    }

    public String getCLOUDDAO_URI() {
        return CLOUDDAO_URI;
    }

    public void setCLOUDDAO_URI(String CLOUDDAO_URI) {
        this.CLOUDDAO_URI = CLOUDDAO_URI;
    }

    public String getCPAPI_URI() {
        return CPAPI_URI;
    }

    public void setCPAPI_URI(String CPAPI_URI) {
        this.CPAPI_URI = CPAPI_URI;
    }

    public String getFIG_URI() {
        return FIG_URI;
    }

    public void setFIG_URI(String FIG_URI) {
        this.FIG_URI = FIG_URI;
    }

    public String getFLIGHTINFO_URI() {
        return FLIGHTINFO_URI;
    }

    public void setFLIGHTINFO_URI(String FLIGHTINFO_URI) {
        this.FLIGHTINFO_URI = FLIGHTINFO_URI;
    }

    public String getGBPEDGE_URI() {
        return GBPEDGE_URI;
    }

    public void setGBPEDGE_URI(String GBPEDGE_URI) {
        this.GBPEDGE_URI = GBPEDGE_URI;
    }

    public String getGBPLITE_URI() {
        return GBPLITE_URI;
    }

    public void setGBPLITE_URI(String GBPLITE_URI) {
        this.GBPLITE_URI = GBPLITE_URI;
    }

    public String getGROUNDGATEWAY_URI() {
        return GROUNDGATEWAY_URI;
    }

    public void setGROUNDGATEWAY_URI(String GROUNDGATEWAY_URI) {
        this.GROUNDGATEWAY_URI = GROUNDGATEWAY_URI;
    }

    public String getIFSGATEWAY_URI() {
        return IFSGATEWAY_URI;
    }

    public void setIFSGATEWAY_URI(String IFSGATEWAY_URI) {
        this.IFSGATEWAY_URI = IFSGATEWAY_URI;
    }

    public String getIFSUTILS_URI() {
        return IFSUTILS_URI;
    }

    public void setIFSUTILS_URI(String IFSUTILS_URI) {
        this.IFSUTILS_URI = IFSUTILS_URI;
    }

    public String getRUPP_URI() {
        return RUPP_URI;
    }

    public void setRUPP_URI(String RUPP_URI) {
        this.RUPP_URI = RUPP_URI;
    }

    public String getSCEMS_URI() {
        return SCEMS_URI;
    }

    public void setSCEMS_URI(String SCEMS_URI) {
        this.SCEMS_URI = SCEMS_URI;
    }

    public String getSESSIONMANAGEMENT_URI() {
        return SESSIONMANAGEMENT_URI;
    }

    public void setSESSIONMANAGEMENT_URI(String SESSIONMANAGEMENT_URI) {
        this.SESSIONMANAGEMENT_URI = SESSIONMANAGEMENT_URI;
    }

    public String getSTUB_URI() {
        return STUB_URI;
    }

    public void setSTUB_URI(String STUB_URI) {
        this.STUB_URI = STUB_URI;
    }
}
