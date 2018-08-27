package lib.application.ifs;

import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import io.restassured.response.Response;
import lib.framework.BaseTestCase;
import lib.rest.RestCommonLibrary;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * This class will hold all step definitions and functions related to fig
 *
 * @Author Brian DeSimone
 * @Date 05/02/2018
 */
public class FigStepDefinitions extends BaseTestCase {

    // GLOBAL CLASS VARIABLES
    private static Logger logger = LogManager.getLogger(FigStepDefinitions.class);
    private static RestCommonLibrary restCommonLibrary = new RestCommonLibrary();

    @Then("^I retrieve the departure time$")
    public void retrieveDepartureTime(){
        logger.debug("Retrieving departure time from the FIG response");
        String departureTime;
        try {
            departureTime = memory.getLastResponse().jsonPath().get("[0].departure.time.scheduled").toString();
        } catch (NullPointerException ex) {
            departureTime = memory.getLastResponse().jsonPath().get("[0].departure.time.actual").toString();
            logger.debug("The scheduled departure time was null so we took time from the actual. Flight did not take off on schedule.");
        }
        logger.debug("Departure time found and saved as: " + departureTime);
        memory.saveValue("departure_time", departureTime);
    }

    @Given("^I format the departure time$")
    public void formatDepartureTime(){
        try {
            logger.debug("Formatting the departure time: " + memory.retrieveValue("departure_time"));
            String date = memory.retrieveValue("departure_time").substring(0,10);
            memory.saveValue("date", date);
            logger.debug("Formatted departure time now stored at 'date' as: " + date);
        }
        catch (NullPointerException ex){
            logger.error("We could not find a variable stored in memory for 'departure_time'. Please check cucumber feature.");
        }
    }

    @When("^I retrieve (in_air) flights and verify the airline partner$")
    public void specialFigAndVerify(String flightStatus){
        String airline = memory.retrieveValue("airline_code");
        logger.debug("We are sending a FIG request to get in-air " + airline + " flights that are not a partner flight.");
        boolean foundFlight = false;
        int page = 1;
        while (!foundFlight){
            Response response = restCommonLibrary.GET_REQUEST(
                    configManager.getFIG_URI() + "/v1/flights?status=" + flightStatus +"&airline-icao=" + airline +"&page-size=1&page=" + page +"&detail=true",
                    memory.getContentTypeHeader(),
                    memory.getAcceptHeader(),
                    memory.getCustomHeaders(),
                    memory.getCustomCookies()
            );
            memory.setLastResponse(response);
            String partner = response.jsonPath().get("[0].aircraft.airline_icao.partner").toString();
            if (partner.equals(airline)){
                logger.debug("We found a valid flight where partner: " + partner + " and airline: " + airline);
                foundFlight = true;
            }
            else {
                logger.debug("The partner: " + partner + " was not the airline: " + airline+ ". Searching for next 'in-air' flight number for " + airline);
                page++;
            }
        }
    }

}