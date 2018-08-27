package models.gbp.eapUserInfo;

/**
 * This class will hold the EAP User Info XML that will be sent inside GBP back channel request for an EAP session.
 *
 * @Author Brian DeSimone
 * @Date 06/28/0217
 */
public class EAPUserInfoModel {

    private String eapUserInformation;
    private String eapUserName;
    private String serviceCode;

    public EAPUserInfoModel(String serviceCode, String emailAddress) {
        this.eapUserName = emailAddress;
        this.serviceCode = serviceCode;
        this.eapUserInformation = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                + "<java version=\"1.8.0_65\" class=\"java.beans.XMLDecoder\">"
                + "<object class=\"com.aircell.abp.model.EapUserInfo\">"
                + "<void property=\"eap_user_name\">"
                + "<string>" + eapUserName + "</string>"
                + "</void>"
                + "<void property=\"service_code\">"
                + "<string>" + serviceCode + "</string>"
                + "</void>"
                + "</object>"
                + "</java>";
    }

    public String getEapUserInformation() {
        return eapUserInformation;
    }

    public String getEapUserName() {
        return eapUserName;
    }

    public String getServiceCode() {
        return serviceCode;
    }
}
