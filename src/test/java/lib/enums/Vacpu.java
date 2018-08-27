package lib.enums;

/**
 * This is an enum that holds the vacpu config elements. Creates simple implementation in the automation framework
 *
 * @Author Brian DeSimone
 * @Date 03/30/2018
 */
public enum Vacpu {

    TEST("", "", "", 0, 0, "", "", "", "", "");

    /**
     * Variable that holds airline
     */
    private String airline;

    /**
     * Variable that holds the tail number of that airline
     */
    private String tailNumber;

    /**
     * Variable that holds the vACPU name
     */
    private String name;

    /**
     * Variable that holds the vLan ID
     */
    private int vlanId;

    /**
     * Variable that holds the stack number
     */
    private int stackNumber;

    /**
     * Variable that holds the hostname of the stack
     */
    private String host;

    /**
     * Variable that holds the username of the stack
     */
    private String user;

    /**
     * Variable that holds the password of the user
     */
    private String password;

    /**
     * variable that holds the currency of a specific airline
     */
    private String currency;

    /**
     *
     */
    private String locale;

    Vacpu(
            final String airline,
            final String tailNumber,
            final String name,
            final int vlanId,
            final int stackNumber,
            final String host,
            final String user,
            final String password,
            final String currency,
            final String locale
    ){
        this.airline = airline;
        this.tailNumber = tailNumber;
        this.name = name;
        this.vlanId = vlanId;
        this.stackNumber = stackNumber;
        this.host = host;
        this.user = user;
        this.password = password;
        this.currency = currency;
        this.locale = locale;
    }

    public String getAirline() {
        return airline;
    }

    public String getTailNumber() {
        return tailNumber;
    }

    public String getName() {
        return name;
    }

    public int getVlanId() {
        return vlanId;
    }

    public int getStackNumber() {
        return stackNumber;
    }

    public String getHost() {
        return host;
    }

    public String getUser() {
        return user;
    }

    public String getPassword() {
        return password;
    }

    public String getCurrency() {
        return currency;
    }

    public String getLocale() {
        return locale;
    }
}
