package lib.xml;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import lib.common.CommonLibrary;
import lib.framework.BaseTestCase;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPathExpressionException;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import static org.hamcrest.CoreMatchers.not;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.equalTo;

/**
 * This class will be where all parsing step definitions are held. If a certain portion of text/html/etc needs to be
 * parsed and stored for later use this is where that magic will happen
 *
 * @Author Brian DeSimone
 * @Date 01/12/2018
 */
public class ParseStepDefinitions extends BaseTestCase {

    // GLOBAL CLASS VARIABLES
    private static Logger logger = LogManager.getLogger(ParseStepDefinitions.class);
    private static CommonLibrary commonLibrary = new CommonLibrary();

    // ================================================================================================================
    // GENERIC PARSE STEP DEFINITIONS
    // ================================================================================================================

    @Given("^I parse the last response to get \"(.*)\" and store it at \"(.*)\"$")
    public void parseResponseGetXML(String xmlToFind, String storageName) throws Exception {
        logger.debug("Parsing the last response to get " + xmlToFind + " and storing them at the variable: "  + storageName);
        String xml = parseXml(memory.getLastResponse().asString(), xmlToFind);
        logger.info("Storing XML: " + xml);
        memory.saveValue(storageName, xml);
    }

    @Then("^the (?:XML|xml) stored at \"(.*)\" should( not|) be key: \"(.*)\" value: \"(.*)\"$")
    public void AssertXML(String storedXML, String negate, String key, String value) throws ParserConfigurationException, IOException, SAXException, XPathExpressionException {
        HashMap<String, String> values = new HashMap<>();
        key = commonLibrary.checkForVariables(key);
        value = commonLibrary.checkForVariables(value);
        storedXML = commonLibrary.checkForVariables(storedXML);
        Document document = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(
                new InputSource(new ByteArrayInputStream(storedXML.getBytes("utf-8")))
        );
        Node parentNode = checkChildren(document.getDocumentElement());
        NodeList children = parentNode.getChildNodes();
        for (int i = 1; i < children.getLength(); i++) {
            Node child = children.item(i);
            values.put(child.getNodeName(), child.getTextContent());
            i++;
        }
        try {
            if (negate.isEmpty()) {
                logger.debug("Asserting that the XML at: " + key + " is: " + value + " in the table.");
                assertThat(
                        "Expected XML at: " + key + " to be: " + value + ", but found " + values.get(key),
                        values.get(key),
                        equalTo(value)
                );
            }
            else if (!negate.isEmpty()) {
                logger.debug("Asserting that the XML at: " + key + " is not: " + value);
                assertThat(
                        "Expected XML response at: " + key + " to not be: " + value + ", but found " + values.get(key),
                        values.get(key),
                        not(equalTo(value))
                );
            }
        }
        catch (NullPointerException e) {
            logger.error("We could not find the key in the stored XML at '" + key + "'. Please check your cucumber feature file." + e);
            throw new NullPointerException("We could not find the key in the stored XML at '" + key + "'. Please check your cucumber feature file.");
        }
    }

    @Then("^the (?:XML|xml) stored at \"(.*)\" should( not|) be the following:$")
    public void AssertXMLTable(String storedXML, String negate, Map<String,String> map) throws ParserConfigurationException, IOException, SAXException, XPathExpressionException {
        for (Map.Entry<String, String> entry : map.entrySet()) {
            HashMap<String, String> values = new HashMap<>();
            String key = commonLibrary.checkForVariables(entry.getKey());
            String value = commonLibrary.checkForVariables(entry.getValue());
            storedXML = commonLibrary.checkForVariables(storedXML);
            Document document = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(
                    new InputSource(new ByteArrayInputStream(storedXML.getBytes("utf-8")))
            );
            Node parentNode = checkChildren(document.getDocumentElement());
            NodeList children = parentNode.getChildNodes();
            for (int i = 1; i < children.getLength(); i++) {
                Node child = children.item(i);
                values.put(child.getNodeName(), child.getTextContent());
                i++;
            }
            try {
                if (negate.isEmpty()) {
                    logger.debug("Asserting that the XML at: " + key + " is: " + value);
                    assertThat(
                            "Expected XML at: " + key + " to be: " + value + ", but found " + values.get(key),
                            values.get(key),
                            equalTo(value)
                    );
                }
                else if (!negate.isEmpty()) {
                    logger.debug("Asserting that the XML at: " + key + " is not: " + value);
                    assertThat(
                            "Expected XML response at: " + key + " to not be: " + value + ", but found " + values.get(key),
                            values.get(key),
                            not(equalTo(value))
                    );
                }
            }
            catch (NullPointerException e) {
                logger.error("We could not find the key in the stored XML at '" + key + "'. Please check your cucumber feature file." + e);
                throw new NullPointerException("We could not find the key in the stored XML at '" + key + "'. Please check your cucumber feature file.");
            }
        }
    }

    // ================================================================================================================
    // PARSE HELPER FUNCTIONS
    // ================================================================================================================

    private String parseXml(String response, String xmlToFind) throws Exception {
        logger.debug("Parsing the text to find the XML: " + xmlToFind);
        if (!response.isEmpty()){
            if (response.contains("<?xml version")){
                if (response.contains(xmlToFind)){
                    // add xml then append the string with the following
                    int start = response.indexOf("<" + xmlToFind);
                    int end = response.indexOf("</" + xmlToFind + ">", start);
                    return response.substring(start, end + (xmlToFind.length() + 3));
                }
                else {
                    logger.error("There was no XML with the TAG: " + xmlToFind + ". Please check the cucumber feature.");
                    throw new Exception("There was no XML with the TAG: " + xmlToFind + ". Please check the cucumber feature.");
                }
            }
            else {
                logger.error("There was no XML found in the response.");
                throw new Exception("There was no XML found in the response.");
            }
        }
        else {
            logger.error("The response was empty when trying to parse.");
            throw new Exception("The response was empty when trying to parse.");
        }
    }

    private Node checkChildren(Node currentNode){
        // check if we have the right child, if not get the next one's sibling to account for xml issue
        if (currentNode.getChildNodes().getLength() <= 3){
            return checkChildren(currentNode.getFirstChild().getNextSibling());
        }
        // else we have the right one return it
        else {
            return currentNode;
        }
    }

}
