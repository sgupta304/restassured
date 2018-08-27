package lib.application.ifs;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import cucumber.api.java.en.Then;
import lib.framework.BaseTestCase;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.IOException;
import java.util.List;

import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.CoreMatchers.not;
import static org.hamcrest.MatcherAssert.assertThat;

/**
 * This class holds all CPAPI specific function and operational step definitions
 *
 * @Author Brian DeSimone
 * @Date 05/02/2018
 */
public class CpApiStepDefinitions extends BaseTestCase {

    // GLOBAL CLASS VARIABLES
    private static Logger logger = LogManager.getLogger(CpApiStepDefinitions.class);

    @Then("^the fsCallback (?:JSON|json) response should (|not )include the following:$")
    public void ModifiedSchemaValidationTable(String negate, List<String> keys) throws IOException {
        // parse JSON from response
        String responseString = memory.getLastResponse().asString();
        Integer responseLength = responseString.length();
        String jsonResponse = responseString.substring(11, responseLength - 3);
        jsonResponse = jsonResponse.replaceAll("\\n", "");  // remove carriage returns
        ObjectMapper mapper = new ObjectMapper();
        JsonNode theJson = mapper.readTree(jsonResponse);
        for (String key : keys) {
            String path = "/" + key.replace(".", "/").replace("[", "/").replace("]/", "/").replace("]", "/");
            int nestedLevel = path.length() - path.replace("/", "").length();
            if (nestedLevel == 1) {
                path = "";
            } else {
                key = path.substring(path.lastIndexOf("/") + 1);
                path = path.substring((0), path.lastIndexOf("/"));
            }
            if (negate.isEmpty()) {
                if (key.equals("")) { // if hash inside of array occurs ex path[0]
                    logger.debug("Asserting that the keys provided in the cucumber scenario are present in the response.");
                    logger.debug("Asserting key: " + key);
                    assertThat("Asserting " + path + " is present, but it was not found in the response", theJson.at(path).getClass().getName(), is("com.fasterxml.jackson.databind.node.ObjectNode"));
                } else {
                    logger.debug("Asserting that the keys provided in the cucumber scenario are present in the response.");
                    logger.debug("Asserting key: " + key);
                    assertThat("Asserting key: " + key + " is present at " + path + ", but it was not found in the response", theJson.at(path).has(key));
                }
            } else if (!negate.isEmpty()) {
                if (key.equals("")) { // if hash inside of array occurs ex path[0]
                    logger.debug("Asserting that the keys provided in the cucumber scenario are present in the response.");
                    logger.debug("Asserting key: " + key);
                    assertThat("Asserting " + path + " is not present, but it was found in the response", theJson.at(path).getClass().getName(), not(is("com.fasterxml.jackson.databind.node.ObjectNode")));
                } else {
                    logger.debug("Asserting that the keys provided in the cucumber scenario are not present in the response.");
                    assertThat("Asserting key: " + key + " is not present at " + path + ", but it was found in the response", not(theJson.at(path).has(key)));
                }
            }
        }
    }
}
