package models.gbp.flightInfo;

/**
 * This class will hold the GBP flight info object model used for generating sessionIds in GBP
 *
 * @Author Brian DeSimone
 * @Date 05/04/0217
 */
public class FlightInfoModel {

    private String flightInformation;

    public FlightInfoModel(String airline, String tail, String flight){
        this.flightInformation = "<?xml version=\"1.0\" encoding=\"UTF-8\"?"
                + "><object class=\"com.aircell.abp.model.FlightInformation\">"
                + "<void property=\"abpVersionNo\">"
                + "<string>4.0.5</string></void>						 "
                + " <void property=\"aircraftTailNumber\">"
                + "<string>" + tail + "</string></void>"
                + "<void property=\"airlineCode\">"
                + "<string>" + airline + "</string></void>"
                + "<void property=\"airlineCodeIata\">"
                + "<string>AS</string>"
                + "</void>"
                + "<void property=\"airlineName\">"
                + "<string>Alaska Airlines</string></void>"
                + "<void property=\"departureAirportCode\">"
                + "<string>KSEA</string></void>"
                + " <void property=\"departureAirportCodeFaa\">"
                + " <string>SEA</string></void>"
                + " <void property=\"departureAirportCodeIata\">"
                + "<string>SEA</string></void>"
                + "<void property=\"departureCity\">"
                + "<string>Seattle, Washington</string></void>"
                + "<void property=\"destinationAirportCode\">"
                + "<string>KFLL</string></void>"
                + "<void property=\"destinationAirportCodeFaa\">"
                + "<string>FLL</string></void>"
                + "<void property=\"destinationAirportCodeIata\">"
                + "<string>FLL</string></void>"
                + "<void property=\"destinationCity\">"
                + "<string>Fort Lauderdale, Florida</string></void>"
                + "<void property=\"expectedArrival\">"
                + "<object class=\"java.util.Date\"><long>1477617499790</long></object></void>"
                + "<void property=\"figCallEnabled\">"
                + "<string>true</string></void>"
                + "<void property=\"flightNumber\">"
                + "<string>" + flight + "</string></void>"
                + "<void property=\"flightNumberAlpha\">"
                + "<string>AS</string></void>"
                + "<void property=\"flightNumberNumeric\"><string>513</string></void>"
                + "<void property=\"flightStatus\">"
                + "<object class=\"com.aircell.abp.model.FlightStatus\">"
                + "<void property=\"HSpeed\">"
                + "<float>320.0</float></void>"
                + "<void property=\"VSpeed\">"
                + "<float>200.0</float></void>"
                + "<void property=\"altitude\">"
                + "<float>30000.0</float></void>"
                + "<void property=\"latitude\">"
                + "<float>44.5659</float></void>"
                + "<void property=\"localTime\">"
                + "<string>02:18:32</string></void>"
                + "<void property=\"longitude\">"
                + "<float>-103.5541</float></void>"
                + "<void property=\"utcTime\">"
                + "<object class=\"java.util.Date\">"
                + "<long>1477606699790</long></object></void></object></void>"
                + "<void property=\"flightType\">"
                + "<string>TWO_KU</string></void>"
                + "<void property=\"mediaCount\">"
                + "<string>0</string></void>"
                + "<void property=\"mediaTrailerCount\">"
                + "<string>0</string></void>"
                + "<void property=\"noOfActiveSubscribers\">"
                + "<string>0</string></void>"
                + "<void property=\"videoServiceAvailability\">"
                + "<string>false</string></void></object>";
    }

    public String getFlightInformation() {
        return flightInformation;
    }

    public void setFlightInformation(String flightInformation) {
        this.flightInformation = flightInformation;
    }
}
