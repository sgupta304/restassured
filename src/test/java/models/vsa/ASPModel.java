package models.vsa;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * This is a pojo that creates the ASP model for VSA services
 *
 * @Author Brian DeSimone
 * @Date 04/03/2018
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class ASPModel {

    @JsonProperty
    private String locale;
    @JsonProperty
    private String flag;
    @JsonProperty
    private String tailNum;

    public ASPModel(String flag, String tailNum){
        this.locale = "en_US";
        this.flag = flag;
        this.tailNum = tailNum;
    }

}