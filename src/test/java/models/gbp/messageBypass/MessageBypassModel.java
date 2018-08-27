package models.gbp.messageBypass;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public class MessageBypassModel {

    @JsonProperty
    private String uxdId;
    @JsonProperty
    private String userType;
    @JsonProperty
    private String captchaType;
    @JsonProperty
    private String captchaValue;

    public MessageBypassModel(String uxdId, String captchaValue) {
        this.uxdId = uxdId;
        this.userType = "BYPASSMSG";
        this.captchaType = "VI";
        this.captchaValue = captchaValue;
    }

}