package models.apiDecorator;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Arrays;
import java.util.List;

/**
 * This class will hold the authenticate customer object models used for authentication of existing customer
 *
 * @Author Brian DeSimone
 * @Date 05/15/0217
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class AuthenticateModel {

    @JsonProperty
    private String user;
    @JsonProperty
    private String password;
    @JsonProperty
    private List<String> dataTypes = null;
    @JsonProperty
    private String uxdId;

    public AuthenticateModel(String user, String password, String uxdId){
        this.user = user;
        this.password = password;
        this.uxdId = uxdId;
        this.dataTypes = Arrays.asList("PERSONAL", "PMTINSTRUMENTS");
    }

}
