package models.iPass;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * pojo for the ipass device that is nested in the ipass captcha validation model
 *
 * @Author Brian DeSimone
 * @Date 02/09/2018
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class iPassDevice {

    @JsonProperty
    private String name;
    @JsonProperty
    private String deviceType;
    @JsonProperty
    private String osName;
    @JsonProperty
    private String osVersion;

    public iPassDevice(){
        this.name = "iPhone";
        this.deviceType = "Mobile";
        this.osName = "iOS";
        this.osVersion = "11.0";
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDeviceType() {
        return deviceType;
    }

    public void setDeviceType(String deviceType) {
        this.deviceType = deviceType;
    }

    public String getOsName() {
        return osName;
    }

    public void setOsName(String osName) {
        this.osName = osName;
    }

    public String getOsVersion() {
        return osVersion;
    }

    public void setOsVersion(String osVersion) {
        this.osVersion = osVersion;
    }
}
