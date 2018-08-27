package lib.framework;

import cucumber.api.CucumberOptions;
import cucumber.api.testng.CucumberFeatureWrapper;
import cucumber.api.testng.PickleEventWrapper;
import cucumber.api.testng.TestNGCucumberRunner;
import io.restassured.RestAssured;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.testng.annotations.*;

/**
 * Class for all test framework utilities. Also contains all before and after setup steps.
 * This class will act as a test runner for cucumber from within testNG.
 * Dynamic data allocation from each feature file or scenario is done here.
 *
 * @Author Brian DeSimone
 * @Date 12/12/2017
 */
@CucumberOptions(
        plugin = {"pretty"},
        format = {"html:test-reports/cucumber-features.html", "json:test-reports/cucumber.json"},
        features = "src/test/resources",
        glue = {"lib.framework", "lib.rest", "lib.application", "lib.xml"}
)
public class BaseTestCase {

    // GLOBAL CLASS VARIABLES
    private static TestNGCucumberRunner testNGCucumberRunner;
    private static Logger logger = LogManager.getLogger(BaseTestCase.class);
    public static ConfigManager configManager;
    public static Memory memory;

    /**
     * Method to initialize all configs from properties files and logging
     */
    private void initialize() {
        // Setup the Config Manager
        configManager = new ConfigManager();
        // Set the base URIs depending on environment source and test environment if AWS
        switch (configManager.getEnvironmentSource().toUpperCase()){
            case "LRU":
                // handle lru setup of base URIs
                break;
            case "SSID":
                // handle ssid setup of base URIs
                break;
            case "AWS":
                // Standard Base URI setup with dev, stage, and prod
                configManager.setAPIDECORATOR_URI("http://apidecorator.ifs." + configManager.getTestEnvironment() +".gogoair.com");
                configManager.setCLOUDDAO_URI("http://ifsgateway.ifs." + configManager.getTestEnvironment() + ".gogoair.com/api/session");
                configManager.setCPAPI_URI("http://cpapi.ifs." + configManager.getTestEnvironment() + ".gogoair.com");
                configManager.setFIG_URI("http://dataservices.fig." + configManager.getTestEnvironment() + ".gogoair.com");
                configManager.setFLIGHTINFO_URI("http://flightinfo.ifs." + configManager.getTestEnvironment() + ".gogoair.com");
                configManager.setGBPEDGE_URI("http://gbp-1." + configManager.getTestEnvironment() + ".gogoair.com");
                configManager.setGBPLITE_URI("http://gbplite.ifs." + configManager.getTestEnvironment() + ".gogoair.com");
                configManager.setGROUNDGATEWAY_URI("http://groundgateway.ifs." + configManager.getTestEnvironment() + ".gogoair.com");
                configManager.setIFSGATEWAY_URI("http://ifsgateway.ifs." + configManager.getTestEnvironment() + ".gogoair.com/api/session");
                configManager.setIFSUTILS_URI("http://ifsutils.ifs." + configManager.getTestEnvironment() + ".gogoair.com");
                configManager.setRUPP_URI("http://rupp.ifs." + configManager.getTestEnvironment() + ".gogoair.com");
                configManager.setSCEMS_URI("http://scems.ifs." + configManager.getTestEnvironment() + ".gogoair.com");
                configManager.setSESSIONMANAGEMENT_URI("http://sessionmanagement.ifs." + configManager.getTestEnvironment() + ".gogoair.com");
                configManager.setSTUB_URI("gogo-stub." + configManager.getTestEnvironment() + ".gogoair.com");
                // Make sure we check to see if we are in prod... if so handle env properly
                if (configManager.getTestEnvironment().equalsIgnoreCase("PROD")){
                    // handle prod, prods, prodp environments with base URIs
                    configManager.setAPIDECORATOR_URI("http://apidecorator.ifs.prodp.gogoair.com");
                    configManager.setFIG_URI("http://dataservices.fig.prods.gogoair.com");
                    configManager.setIFSUTILS_URI("http://ifsutils.ifs.prods.gogoair.com");
                    configManager.setRUPP_URI("http://rupp.ifs.prodp.gogoair.com");
                }
                break;
            default:
                logger.error("Invalid type test environment source: " + configManager.getEnvironmentSource() + "Please check configs.");
                throw new IllegalArgumentException("Invalid type test environment source: " + configManager.getEnvironmentSource() + "Please check configs.");
        }
        // Set up the abp source.. this is where the vacpu magic happens if we are aiming at a vacpu
        switch (configManager.getAbpSource().toUpperCase()){
            case "VACPU":
                // Handle VACPU proxy setup for ABP etc
                configManager.setABP_URI("http://airborne.gogoinflight.com");
                break;
            case "LRU":
                // handle setup of ABP when on a real LRU from SSID etc
                configManager.setABP_URI("http://airborne.gogoinflight.com");
                break;
            case "STUB":
                // handle the setup of ABP when we are using stubs
                configManager.setABP_URI("http://airborne.gogoinflight.com");
                break;
            default:
                logger.error("Invalid type of abp source: " + configManager.getAbpSource() + ". Please check configs.");
                throw new IllegalArgumentException("Invalid type of abp source: " + configManager.getAbpSource() + ". Please check configs.");
        }
    }

    // ================================================================================================================
    // TESTNG ANNOTATIONS & CUCUMBER SETUP
    // ================================================================================================================

    /**
     * Before entire test suite we need to setup everything we will need.
     */
    @BeforeSuite(alwaysRun = true)
    public void setupSuite() {
        logger.info("Cucumber Test Framework for QE-SM-SMAC-TESTS initialized!");
        logger.info("Logging initialized: All logs are located at " + System.getProperty("user.dir") + "/src/logs/qe-api-tests.log");
        initialize();
        logger.info("Done with BeforeSuite setup! TESTS BEGINNING!\n\n");
    } // End TestSetup

    /**
     * Before class setup to initialize the cucumber runner.
     */
    @BeforeClass(alwaysRun = true)
    public void setupClass() {
        testNGCucumberRunner = new TestNGCucumberRunner(this.getClass());
    }

    /**
     * After class to tear down the runner for cucumber.
     */
    @AfterClass(alwaysRun = true)
    public void tearDownClass() {
        testNGCucumberRunner.finish();
    }

    /**
     * After the entire test suite clean up rest assured
     */
    @AfterSuite(alwaysRun = true)
    public void cleanUp() {
        RestAssured.reset();
        logger.info("\n\n");
        logger.info("QE Cucumber framework has been reset because all tests have been executed.");
        logger.info("TESTING COMPLETE: SHUTTING DOWN FRAMEWORK!!");
    } // end cleanUp

    /**
     * The main test that will kick off each scenario as a TestNG test case.
     */
    @Test(groups = {"cucumber", "regression"}, description = "Runs Cucumber Scenarios!", dataProvider = "scenarios")
    public void scenario(PickleEventWrapper pickleWrapper, CucumberFeatureWrapper featureWrapper) throws Throwable {
        testNGCucumberRunner.runScenario(pickleWrapper.getPickleEvent());
    }

    /**
     * The data provider that goes and gets all feature files as testNG tests
     * DEPRECIATED FEATURE
     */
    @DataProvider
    public Object[][] features() {
        return testNGCucumberRunner.provideFeatures();
    }

    /**
     * The data provider that goes and gets all the scenarios from the feature files and injects them into each TestNG test.
     */
    @DataProvider
    public Object[][] scenarios() {
        return testNGCucumberRunner.provideScenarios();
    }

}

