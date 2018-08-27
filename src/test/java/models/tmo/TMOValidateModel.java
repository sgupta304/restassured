package models.tmo;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * This class will hold the tmo validate model from GBP
 *
 * @Author Brian DeSimone
 * @Date 04/26/2018
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class TMOValidateModel {

    @JsonProperty
    private String captchaType;
    @JsonProperty
    private String captchaValue;
    @JsonProperty
    private String phoneNumber;
    @JsonProperty
    private String uxdId;
    @JsonProperty
    private String zipCode;

    public TMOValidateModel(String uxdId, String captchaValue){
        this.captchaType = "VI";
        this.captchaValue = captchaValue;
        this.uxdId = uxdId;
    }

    public TMOValidateModel(String uxdId, String phoneNumber, String zipCode, String captchaValue){
        this.captchaType = "VI";
        this.captchaValue = captchaValue;
        this.phoneNumber = phoneNumber;
        this.uxdId = uxdId;
        this.zipCode = zipCode;
    }
}
