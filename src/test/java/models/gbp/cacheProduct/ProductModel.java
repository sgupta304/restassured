package models.gbp.cacheProduct;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import lib.common.CommonLibrary;

/**
 * This class will hold the pojo for the edge cached product call in GBPLite
 *
 * @Author Brian DeSimone
 * @Date 05/30/2018
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ProductModel {

    @JsonIgnore
    private static CommonLibrary commonLibrary = new CommonLibrary();
    @JsonProperty
    private String version;
    @JsonProperty
    private boolean pre_fetch_flag;
    @JsonProperty
    private String currency;
    @JsonProperty
    private String region;
    @JsonProperty
    private String locale;
    @JsonProperty
    private String device_type;
    @JsonProperty
    private String uxd_id;
    @JsonProperty
    private String connectivity_type;
    @JsonProperty
    private FlightInformation flight_information;

    public ProductModel(String airline_code, String tail_number, String flight_number, String version, boolean pre_fetch_flag, boolean allAttributes){
        if (allAttributes){
            this.version = version;
            this.pre_fetch_flag = pre_fetch_flag;
            this.currency = "USD";
            this.region = "USA";
            this.locale = "en_US";
            this.device_type = "MOBILE";
            this.uxd_id = commonLibrary.genUxdid();
            this.connectivity_type = "ATG4";
            this.flight_information = new FlightInformation(airline_code, tail_number, flight_number);
        }
        else {
            this.version = version;
            this.pre_fetch_flag = pre_fetch_flag;
            this.flight_information = new FlightInformation(tail_number);
        }
    }

}
