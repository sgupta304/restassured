package lib.framework;

import cucumber.api.Scenario;
import cucumber.api.java.After;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * This class will link all of the common functions to cucumber step definitions.
 * This is where all before and after hooks are executed.
 *
 * @Author Brian DeSimone
 * @Date 12/12/2017
 */
public class GenericStepDefinitions extends BaseTestCase {

    // GLOBAL CLASS VARIABLES
    private static Logger logger = LogManager.getLogger(GenericStepDefinitions.class);

    // ================================================================================================================
    // BEFORE AND AFTER HOOKS AT TEST LEVEL
    // ================================================================================================================

    @Before
    public void onTestBoot(Scenario scenario) {
        // Reset the cucumber scenario memory with each scenario execution. Make sure we keep flight info from configs
        memory = new Memory(
                configManager.getAirlineCode(),
                configManager.getTailNumber(),
                configManager.getFlightNumber()
        );
        logger.debug("\n\n######################################################################################################################");
        logger.debug("TESTING: " + scenario.getName() + "\n######################################################################################################################\n\n");
    }

    @After
    public void onTestComplete(Scenario scenario) {
        logger.debug("TEST STATUS: " + scenario.getStatus());
        logger.debug("\n\n");
    }

    // ================================================================================================================
    // FRAMEWORK LEVEL STEP DEFINITIONS
    // ================================================================================================================

    @Given("^I wait for (\\d+) (?:seconds|second)$")
    public void waitSeconds(int seconds) throws InterruptedException {
        logger.debug("Sleeping the framework for " + seconds + " seconds.");
        Thread.sleep(seconds * 1000);
    }

}