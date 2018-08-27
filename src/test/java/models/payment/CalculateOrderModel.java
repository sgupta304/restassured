package models.payment;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * This class will hold the object model used for calculating an order
 *
 * @Author Eric Disrud
 * @Date 04/28/0217
 */

@JsonIgnoreProperties(ignoreUnknown = true)
public class CalculateOrderModel {

    @JsonProperty
    private String locale;
    @JsonProperty
    private String currency;
    @JsonProperty
    private String uxdId;
    @JsonProperty
    private String userName;
    @JsonProperty
    private ProductModel product;

    public CalculateOrderModel(String productCode, String price, String user, String locale, String currency, String uxdId) {
        this.product = new ProductModel(productCode, price);
        this.userName = user;
        this.locale = locale;
        this.currency = currency;
        this.uxdId = uxdId;
    }
}
