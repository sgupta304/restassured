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
public class ProductModel {

    @JsonProperty
    private String productCode;
    @JsonProperty
    private String price;
    @JsonProperty
    private Integer quantity;
    @JsonProperty
    private Boolean taxIncluded;

    public ProductModel(String productCode, String price) {
        this.productCode = productCode;
        this.price = price;
        this.quantity = 1;
        this.taxIncluded = false;
    }
}