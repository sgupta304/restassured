package models.gbp.captcha;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * This class will hold the captchaValidate object model used in API Decorator
 *
 * @Author Brian DeSimone
 * @Date 05/15/0217
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class CaptchaModel {

    @JsonProperty
    private String captchaType;
    @JsonProperty
    private String captchaValue;
    @JsonProperty
    private String uxdId;

    public CaptchaModel(){

    }

    public CaptchaModel(String captchaType, String captchaValue, String uxdId){
        this.captchaType = captchaType;
        this.captchaValue = captchaValue;
        this.uxdId = uxdId;
    }

    public String getCaptchaType() {
        return captchaType;
    }

    public void setCaptchaType(String captchaType) {
        this.captchaType = captchaType;
    }

    public String getCaptchaValue() {
        return captchaValue;
    }

    public void setCaptchaValue(String captchaValue) {
        this.captchaValue = captchaValue;
    }

    public String getUxdId() {
        return uxdId;
    }

    public void setUxdId(String uxdId) {
        this.uxdId = uxdId;
    }
}
