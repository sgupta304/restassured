package models.unitedMileage;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lib.common.CommonLibrary;

/**
 * This class is a pojo for the united mileage plus model. This will be used for logins through rupp
 *
 * @Author Brian DeSimone
 * @Date 04/25/2018
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class UnitedMileagePlusLoginModel {

    @JsonIgnore
    private static CommonLibrary commonLibrary = new CommonLibrary();
    @JsonProperty
    private String username;
    @JsonProperty
    private String password;
    @JsonProperty
    private int user_type ;
    @JsonProperty
    private String airline_code;
    @JsonProperty
    private String key_id;
    @JsonProperty
    private String flight_number;
    @JsonProperty
    private String aircraft_tail_number;
    @JsonProperty
    private String arrival_airport_code;
    @JsonProperty
    private String departure_airport_code;
    @JsonProperty
    private String departure_time;
    @JsonProperty
    private String vendor_id;
    @JsonProperty
    private String mac_address;

    public UnitedMileagePlusLoginModel(String airline_code, String aircraft_tail_number, String flight_number, String key_id){
        this.username = "REzPCWM8Nw4mPQi22V77hQXCMSUJeO+YCXfrunMtCS9RxS8a7rHfTIMNL7EJhwtWn1bX1/orYOAaEnepFvcnzr6lRQfICQQqZZb5+9iqrJqwsg5KrPP9BwLHs/pDCW4eX0M5oMr8gU8TYrGhUG6TCvOxRxfC+coEdEKcx09G/JgfH2jfWQH5oL6KMFcKu4EKGPXRnX4OEVFYnlwmb7m4bK5RIi9H/ITepFqHuQsRurdaZSaHw6tH0rP3kMgc4pcWdo5DR6HpBd+JQOaHg92YjFrXSBSC6Bw7THQY3st65ulcPdpDtaA5DQDIg+X1hBDJmj4vwXsMh2h0q8kLKYzOGg==";
        this.password = "hBBK/cGoebos6jmLv50nYt2lUq5jFJh+rTUGUAYZiEQhmXXPtaTh0hETOjf8w+heosHcQxBxuTFANnz1b8kNKNayFEPF/ACyrImPEPY3E1b+W5CFQR8qIP0sh3/+cQiNHAQx+zRThHBMipsyZI7F5NihJ2DdbGsLGUUGGH/X62iBpikRa1PHHjoFnz5Mo1uFrsCHoAb061PKlVKAU+9m9AMOqu28jODZYvCTIh7H/Br0jGd5/TMuCAT5vJO6O9WW+Ubp+hrbdjVWW5Jv+vXQSBeCAz1xH6IM9sj2MWJtN4f7JIi32m0XHapz0181SPnjfO6F87BwGjWyUiCGKod5yA==";
        this.user_type = 3;
        this.airline_code = airline_code;
        this.key_id = key_id;
        this.flight_number = flight_number;
        this.aircraft_tail_number = aircraft_tail_number;
        this.arrival_airport_code = "LAX";
        this.departure_airport_code = "JFK";
        this.departure_time = "2017-10-25T21:04:23+0000";
        this.vendor_id = "GOGO";
        this.mac_address = commonLibrary.genRandomMacAddress();
    }

}
