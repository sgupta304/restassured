package lib.xml;

import cucumber.api.java.en.Then;
import lib.common.CommonLibrary;
import lib.framework.BaseTestCase;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.List;
import java.util.Map;

import static org.hamcrest.CoreMatchers.not;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;

/**
 * This class will be where all asserts for the test framework are held. These will be generic
 * re-usable methods that will assert based on XML input. See the standard assert lib for commons and JSON.
 *
 * @Author Brian DeSimone
 * @Date 05/16/2017
 */
public class XMLAssertStepDefinitions extends BaseTestCase {

    // GLOBAL CLASS VARIABLES
    private static Logger logger = LogManager.getLogger(XMLAssertStepDefinitions.class);
    private static CommonLibrary commonLibrary = new CommonLibrary();

    // ================================================================================================================
    // COMMON ASSERTION XML STEP DEFINITIONS
    // ================================================================================================================

    @Then("^the (?:XML|xml) response at \"(.*)\" should( not|) be \"(.*)\"$")
    public void AssertXMLAttribute(String key, String negate, String value){
        key = commonLibrary.checkForVariables(key);
        value = commonLibrary.checkForVariables(value);
        try {
            if (negate.isEmpty()) {
                logger.debug("Asserting that the XML response at: " + key + " is: " + value);
                assertThat(
                        "Expected XML response at: " + key + " to be: " + value + ", but found " + memory.getLastResponse().xmlPath().get(key),
                        memory.getLastResponse().xmlPath().get(key).toString(),
                        equalTo(value)
                );
            }
            else if (!negate.isEmpty()) {
                logger.debug("Asserting that the JSON response at: " + key + " is not: " + value);
                assertThat(
                        "Expected XML response at: " + key + " to not be: " + value + ", but found " + memory.getLastResponse().xmlPath().get(key),
                        memory.getLastResponse().xmlPath().get(key).toString(),
                        not(equalTo(value))
                );
            }
        }
        catch (NullPointerException e) {
            logger.error("We could not find the key in the XML response at '" + key + "'. Please check your cucumber feature file." + e);
            throw new NullPointerException("We could not find the key in the XML response at '" + key + "'. Please check your cucumber feature file.");
        }
    }

    @Then("^the (?:XML|xml) response should(| not) be the following:$")
    public void AssertXMLAttributeTable(String negate, Map<String,String> map){
        for (Map.Entry<String, String> entry : map.entrySet()) {
            String key = commonLibrary.checkForVariables(entry.getKey());
            String value = commonLibrary.checkForVariables(entry.getValue());
            try {
                if (negate.isEmpty()) {
                    logger.debug("Asserting that the XML response at: " + key + " is expected value: " + value);
                    assertThat(
                            "Expected XML response at: " + key + " to be: " + value + ", but found " + memory.getLastResponse().xmlPath().get(key),
                            memory.getLastResponse().xmlPath().get(key).toString(),
                            equalTo(value)
                    );
                }
                else if (!negate.isEmpty()){
                    logger.debug("Asserting that the JSON response at: " + key + " is not value: " + value);
                    assertThat(
                            "Expected XML response at: " + key + " to not be: " + value + ", but found " + memory.getLastResponse().xmlPath().get(key),
                            memory.getLastResponse().xmlPath().get(key).toString(),
                            not(equalTo(value))
                    );
                }
            }
            catch (NullPointerException e) {
                logger.error("We could not find the key in the XML response at '" + key + "'. Please check your cucumber feature file." + e);
                throw new NullPointerException("We could not find the key in the XML response at '" + key + "'. Please check your cucumber feature file.");
            }
        }
    }

    @Then("^the (?:XML|xml) response should (|not )include \"(.*)\"$")
    public void AssertXMLSchema(String negate, String key){
        // TODO
    }

    @Then("^the (?:XML|xml) response should (|not )include the following:$")
    public void AssertXMLSchemaTable(String negate, List<String> keys){
        // TODO
    }

    @Then("^the (?:XML|xml) response at \"(.*)\" should( not|) have data type \"(.*)\"$")
    public void AssertXMLDataType(String key, String negate, String dataType){
        // TODO
    }

    @Then("^the (?:XML|xml) response should(| not) have the following data types:$")
    public void AssertXMLDataTypeTable(String negate, Map<String,String> map){
        // TODO
    }

}
