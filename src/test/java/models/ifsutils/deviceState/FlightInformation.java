package models.ifsutils.deviceState;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import io.restassured.response.Response;
import lib.rest.RestCommonLibrary;

import javax.ws.rs.core.MediaType;

/**
 * This class will hold then pojo object for the flight information object. This is received from FlightInfo API.
 *
 * @Author Brian DeSimone
 * @Date 05/17/2017
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class FlightInformation {

    @JsonIgnore
    private static RestCommonLibrary restCommonLibrary = new RestCommonLibrary();
    @JsonProperty
    private String airlineCode;
    @JsonProperty
    private String aircraftTailNumber;
    @JsonProperty
    private String departureAirportCode;
    @JsonProperty
    private String destinationAirportCode;

    public FlightInformation(String figUrl, String tail){
        Response response = restCommonLibrary.GET_REQUEST(
                figUrl + "/v1/tail/" + tail,
                MediaType.APPLICATION_JSON,
                MediaType.APPLICATION_JSON,
                null,
                null
        );
        this.airlineCode = response.jsonPath().get("airline.codes.icao");
        this.aircraftTailNumber = response.jsonPath().get("tailNumber");
        this.departureAirportCode = response.jsonPath().get("departure.icaoCode");
        this.destinationAirportCode = response.jsonPath().get("destination.icaoCode");
    }

}
