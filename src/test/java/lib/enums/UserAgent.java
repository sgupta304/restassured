package lib.enums;

/**
 * This is an enum that holds user agent config elements. Creates a user agent based on the type desired.
 *
 * @Author Brian DeSimone
 * @Date 04/02/2018
 */
public enum UserAgent {

    MOBILE("Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_4 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10B350 Safari/8536.25"),
    LAPTOP(""),
    ANDROID("Mozilla/5.0 (Linux; Android 6.0.1; SM-G920V Build/MMB29K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.98 Mobile Safari/537.36"),
    IOS("Mozilla/5.0 (iPhone; CPU iPhone OS 6_1_4 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10B350 Safari/8536.25");

    /**
     * Variable that holds the data of the agaent
     */
    private String agent;

    UserAgent(final String agent){
        this.agent = agent;
    }

    public String getAgent() {
        return agent;
    }
}
