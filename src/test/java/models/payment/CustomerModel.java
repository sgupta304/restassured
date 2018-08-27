package models.payment;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lib.common.CommonLibrary;

import java.util.Random;

/**
 * This class will hold the customer object model used for crud operations on a customer
 *
 * @Author Brian DeSimone
 * @Date 04/26/0217
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class CustomerModel {

    @JsonIgnore
    private static CommonLibrary commonLibrary = new CommonLibrary();
    @JsonProperty
    private String email;
    @JsonProperty
    private String password;
    @JsonProperty
    private String firstname;
    @JsonProperty
    private String lastname;
    @JsonProperty
    private String pwdReminderQueId;
    @JsonProperty
    private String pwdReminderAnswer;
    @JsonProperty
    private Boolean signupForMarketing;
    @JsonProperty
    private String uxdId;

    public CustomerModel(String uxdId) {
        this.email = commonLibrary.genRandomEmailAddress();
        this.password = "Password123";
        this.firstname = "QETest";
        this.lastname = "QETest";
        this.pwdReminderQueId = "51";
        this.pwdReminderAnswer = "QETest";
        this.signupForMarketing = true;
        this.uxdId = uxdId;
    }
}
