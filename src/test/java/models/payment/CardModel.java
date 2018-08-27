package models.payment;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * This class will hold the object model used for processing an order
 *
 * @Author Brian DeSimone
 * @Date 05/03/2018
 */
@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class CardModel {

    @JsonProperty
    private String cardNumber;
    @JsonProperty
    private String expiryMonth;
    @JsonProperty
    private String expiryYear;
    @JsonProperty
    private String cvvNumber;
    @JsonProperty
    private String nameOnCard;
    @JsonProperty
    private Boolean storeCard;
    @JsonProperty
    private String cardId;

    public CardModel(String type){
        switch (type.toUpperCase()){
            case ("VISA"):
                this.cardNumber = "4400000000000008";
                this.expiryMonth = "08";
                this.expiryYear = "18";
                this.cvvNumber = "737";
                this.nameOnCard = "QE TEST";
                this.storeCard = false;
                break;
            case ("AMEX"):
                this.cardNumber = "370000000000002";
                this.expiryMonth = "08";
                this.expiryYear = "18";
                this.cvvNumber = "7373";
                this.nameOnCard = "QE TEST";
                this.storeCard = false;
                break;
            case ("DISCOVER"):
                this.cardNumber = "6011000995500000";
                this.expiryMonth = "08";
                this.expiryYear = "18";
                this.cvvNumber = "737";
                this.nameOnCard = "QE TEST";
                this.storeCard = false;
                break;
            case ("MC"):
                this.cardNumber = "5424000000000015";
                this.expiryMonth = "08";
                this.expiryYear = "18";
                this.cvvNumber = "737";
                this.nameOnCard = "QE TEST";
                this.storeCard = false;
                break;
            case ("INVALID"):
                this.cardNumber = "00000000000";
                this.expiryMonth = "08";
                this.expiryYear = "18";
                this.cvvNumber = "737";
                this.nameOnCard = "QE TEST";
                this.storeCard = false;
                break;
        }
    }

    public CardModel(String type, boolean storeCard){
        switch (type.toUpperCase()){
            case ("VISA"):
                this.cardNumber = "4400000000000008";
                this.expiryMonth = "08";
                this.expiryYear = "18";
                this.cvvNumber = "737";
                this.nameOnCard = "QE TEST";
                this.storeCard = storeCard;
                break;
            case ("AMEX"):
                this.cardNumber = "370000000000002";
                this.expiryMonth = "08";
                this.expiryYear = "18";
                this.cvvNumber = "7373";
                this.nameOnCard = "QE TEST";
                this.storeCard = storeCard;
                break;
            case ("DISCOVER"):
                this.cardNumber = "6011000995500000";
                this.expiryMonth = "08";
                this.expiryYear = "18";
                this.cvvNumber = "737";
                this.nameOnCard = "QE TEST";
                this.storeCard = storeCard;
                break;
            case ("MC"):
                this.cardNumber = "5424000000000015";
                this.expiryMonth = "08";
                this.expiryYear = "18";
                this.cvvNumber = "737";
                this.nameOnCard = "QE TEST";
                this.storeCard = storeCard;
                break;
            case ("INVALID"):
                this.cardNumber = "00000000000";
                this.expiryMonth = "08";
                this.expiryYear = "18";
                this.cvvNumber = "737";
                this.nameOnCard = "QE TEST";
                this.storeCard = storeCard;
                break;
        }
    }

    public CardModel(int cardId){
        this.cardId = Integer.toString(cardId);
    }
}