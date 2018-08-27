package models.vsa;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lib.common.CommonLibrary;

/**
 * This pojo will build the vsa request to change the video availability status for a tail on a specific airline
 *
 * @Author Brian DeSimone
 * @Date 04/25/2018
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class TailModel {

    @JsonIgnore
    private static CommonLibrary commonLibrary = new CommonLibrary();
    @JsonProperty
    private boolean activeStatus;
    @JsonProperty
    private String airlineCode;
    @JsonProperty
    private String auditLog;
    @JsonProperty
    private String createdDate;
    @JsonProperty
    private String invalidDate;
    @JsonProperty
    private String locale;
    @JsonProperty
    private String modifiedBy;
    @JsonProperty
    private String modifiedDate;
    @JsonProperty
    private String source;
    @JsonProperty
    private String tailNumber;
    @JsonProperty
    private String trackingId;

    public TailModel(boolean activeStatus, String airlineCode, String tailNumber){
        this.activeStatus = activeStatus;
        this.airlineCode = airlineCode;
        this.locale = "en_US";
        this.modifiedBy = "QE-Auto";
        this.source = "MANUAL";
        this.tailNumber = tailNumber;
        this.trackingId = commonLibrary.genTrackingId();
    }
}
