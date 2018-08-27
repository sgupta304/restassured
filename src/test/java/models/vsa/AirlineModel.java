package models.vsa;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * This pojo will build the vsa airline request to change the video availability status
 *
 * @Author Brian DeSimone
 * @Date 04/25/2018
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class AirlineModel {

    @JsonProperty
    private boolean activeStatus;
    @JsonProperty
    private String airlineCode;
    @JsonProperty
    private String airlineName;
    @JsonProperty
    private String auditLog;
    @JsonProperty
    private String insertionDate;
    @JsonProperty
    private String modifiedBy;
    @JsonProperty
    private String modifiedDate;

    public AirlineModel(boolean activeStatus, String airlineCode){
        this.activeStatus = activeStatus;
        this.airlineCode = airlineCode;
        this.airlineName = "QE-Air";
        this.modifiedBy = "QE-Auto";
    }

}
