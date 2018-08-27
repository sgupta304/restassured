package models.ifsutils.deviceState;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * This class is a pojo for retrieving device state check in ifsutils
 *
 * @Author Brian DeSimone
 * @Date 05/15/2018
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class DeviceStateCheckModel {

    @JsonProperty
    private String productCode;
    @JsonProperty
    private String user;
    @JsonProperty
    private String ipaddress;
    @JsonProperty
    private FlightInformation flightInformation;

    public DeviceStateCheckModel(String figUrl, String tailNumber, String productCode, String user, String ipaddress){
        this.productCode = productCode;
        this.user = user;
        this.ipaddress = ipaddress;
        this.flightInformation = new FlightInformation(figUrl, tailNumber);
    }

}
