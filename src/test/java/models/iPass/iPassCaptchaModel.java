package models.iPass;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * pojo for the ipass captcha validation model. Used when validating captcha for ipass APIs
 *
 * @Author Brian DeSimone
 * @Date 02/09/2018
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class iPassCaptchaModel {

    @JsonProperty
    private String captchaType;
    @JsonProperty
    private String captchaValue;
    @JsonProperty
    private String originatingServer;
    @JsonProperty
    private String userName;
    @JsonProperty
    private String password;
    @JsonProperty
    private String trackingId;
    @JsonProperty
    private iPassDevice device;

    public iPassCaptchaModel(){

    }

    public iPassCaptchaModel(String trackingId, String captchaValue){
        this.captchaType = "VI";
        this.captchaValue = captchaValue;
        this.originatingServer = "http://sniff.gslb.i-pass.com/";
        this.userName = "IPASS:Roaming/0U3OxJq01S/bdb_airlab1@opstesting.com";
        this.password = "airlab101234";
        this.trackingId = trackingId;
        this.device = new iPassDevice();
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

    public String getOriginatingServer() {
        return originatingServer;
    }

    public void setOriginatingServer(String originatingServer) {
        this.originatingServer = originatingServer;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getTrackingId() {
        return trackingId;
    }

    public void setTrackingId(String trackingId) {
        this.trackingId = trackingId;
    }

    public iPassDevice getDevice() {
        return device;
    }

    public void setDevice(iPassDevice device) {
        this.device = device;
    }
}
