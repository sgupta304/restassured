package models.payment;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * This class will hold the object model used for processing an order
 *
 * @Author Brian DeSimone
 * @Date 05/03/2018
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class AddressModel {

    @JsonProperty
    private String address1;
    @JsonProperty
    private String address2;
    @JsonProperty
    private String city;
    @JsonProperty
    private String stateCode;
    @JsonProperty
    private String postalCode;
    @JsonProperty
    private String countryCode;

    public AddressModel() {
        this.address1 = "111 N Canal St";
        this.address2 = "Suite 1500";
        this.city = "Chicago";
        this.stateCode = "IL";
        this.postalCode = "60601";
        this.countryCode = "US";
    }
}