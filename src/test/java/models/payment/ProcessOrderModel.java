package models.payment;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * This class will hold the object model used for processing an order
 *
 * @Author Brian DeSimone
 * @Date 05/03/2018
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class ProcessOrderModel {

    @JsonProperty
    private String locale;
    @JsonProperty
    private String currency;
    @JsonProperty
    private String userName;
    @JsonProperty
    private String uxdId;
    @JsonProperty
    private CardModel cardDetails;
    @JsonProperty
    private ProductModel product;
    @JsonProperty
    private AddressModel addressDetails;

    public ProcessOrderModel(String productCode, String price, String user, String uxdId, String type, String locale, String currency) {
        this.locale = locale;
        this.currency = currency;
        this.userName = user;
        this.uxdId = uxdId;
        this.cardDetails = new CardModel(type);
        this.product = new ProductModel(productCode, price);
        this.addressDetails = new AddressModel();
    }

    public ProcessOrderModel(String productCode, String price, String user, String uxdId, String type, String locale, String currency, boolean saveCard) {
        this.locale = locale;
        this.currency = currency;
        this.userName = user;
        this.uxdId = uxdId;
        this.cardDetails = new CardModel(type, saveCard);
        this.product = new ProductModel(productCode, price);
        this.addressDetails = new AddressModel();
    }

    public ProcessOrderModel(int cardId, String productCode, String price, String user, String uxdId, String locale, String currency) {
        this.cardDetails = new CardModel(cardId);
        this.locale = locale;
        this.currency = currency;
        this.userName = user;
        this.uxdId = uxdId;
        this.product = new ProductModel(productCode, price);
    }

}