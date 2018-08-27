package models.gbp.cacheProduct;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * This class will hold the pojo for edge cached product flight information
 *
 * @Author Brian DeSimone
 * @Date 05/30/2018
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class FlightInformation {

    @JsonProperty
    private String aircraft_tail_number;
    @JsonProperty
    private String airline_code;
    @JsonProperty
    private String departure_airport_code;
    @JsonProperty
    private String destination_airport_code;
    @JsonProperty
    private String flight_number;

    public FlightInformation(String aircraft_tail_number){
        this.aircraft_tail_number = aircraft_tail_number;
    }

    public FlightInformation(String airline_code, String aircraft_tail_number, String flight_number){
        this.airline_code = airline_code;
        this.aircraft_tail_number = aircraft_tail_number;
        this.flight_number = flight_number;
        this.departure_airport_code = "LAX";
        this.destination_airport_code = "ORD";
    }

    public FlightInformation(String airline_code, String aircraft_tail_number, String departure_airport_code, String destination_airport_code, String flight_number){
        this.airline_code = airline_code;
        this.aircraft_tail_number = aircraft_tail_number;
        this.departure_airport_code = departure_airport_code;
        this.destination_airport_code = destination_airport_code;
        this.flight_number = flight_number;
    }

}
