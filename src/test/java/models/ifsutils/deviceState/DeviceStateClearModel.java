package models.ifsutils.deviceState;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * This pojo will define the attributes needed to clear device states in ifsutils
 *
 * @Author Brian DeSimone
 * @Date 04/26/2018
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class DeviceStateClearModel {

    @JsonProperty
    private String user;
    @JsonProperty
    private String macaddress;

    public DeviceStateClearModel(){

    }

    public void setMacaddress(String macaddress) {
        this.macaddress = macaddress;
    }

    public void setUser(String user) {
        this.user = user;
    }
}
