package lib.application.ifs;

import cucumber.api.java.en.Given;
import lib.common.CommonLibrary;
import lib.framework.BaseTestCase;
import models.ifsutils.deviceState.DeviceStateCheckModel;
import models.ifsutils.deviceState.DeviceStateClearModel;
import models.vsa.AirlineModel;
import models.vsa.TailModel;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * This class is an application library that holds cucumber step definitions for all IFSUTILS specific operations
 *
 * @Author Brian DeSimone
 * @Date 04/25/2018
 */
public class IfsUtilsStepDefinitions extends BaseTestCase {

    // GLOBAL CLASS VARIABLES
    private static Logger logger = LogManager.getLogger(IfsUtilsStepDefinitions.configManager);
    private static CommonLibrary commonLibrary = new CommonLibrary();

    @Given("^I generate a VSA Airline Object to (enable|disable) video service$")
    public void generateAirlineVSAObject(String videoStatus) {
        logger.debug("Generating a VSA airline object to " + videoStatus + " video service for airline: " + memory.retrieveValue("airline_code"));
        AirlineModel airlineModel;
        if (videoStatus.equalsIgnoreCase("ENABLE")) {
            airlineModel = new AirlineModel(
                    true,
                    memory.retrieveValue("airline_code")
            );
        }
        else {
            airlineModel = new AirlineModel(
                    false,
                    memory.retrieveValue("airline_code")
            );
        }
        memory.setGeneratedObject(airlineModel);
    }

    @Given("^I generate a VSA Tail Object to (enable|disable) video service$")
    public void generateTailVSAObject(String videoStatus){
        logger.debug("Generating a VSA tail object to " + videoStatus + " video service for tail number: " + memory.retrieveValue("tail_number"));
        TailModel tailModel;
        if (videoStatus.equalsIgnoreCase("ENABLE")) {
            tailModel = new TailModel(
                    true,
                    memory.retrieveValue("airline_code"),
                    memory.retrieveValue("tail_number")
            );
        }
        else {
            tailModel = new TailModel(
                    false,
                    memory.retrieveValue("airline_code"),
                    memory.retrieveValue("tail_number")
            );
        }
        memory.setGeneratedObject(tailModel);
    }

    @Given("^I generate a device state object to clear (?:a|an) (1HR|NOZIP|ONE-PLUS|LUP|EAP) session$")
    public void GenerateTMODeviceStateClear(String type){
        logger.debug("Generating an object to clear TMO phone number of type: " + type);
        DeviceStateClearModel deviceStateClearModel = new DeviceStateClearModel();
        switch (type.toUpperCase()){
            case "1HR":
                deviceStateClearModel.setUser(configManager.getTmoPhoneNumber());
                break;
            case "NOZIP":
                deviceStateClearModel.setUser(configManager.getTmoNoZipPhoneNumber());
                break;
            case "ONE-PLUS":
                deviceStateClearModel.setUser(configManager.getTmoOnePlusPhoneNumber());
                break;
            case "LUP":
                deviceStateClearModel.setUser(configManager.getTmoPhoneNumber());
                break;
            default:
                // we should never get here!
                logger.error("Invalid type of TMO object: " + type + "Please check cucumber feature.");
                throw new IllegalArgumentException("Invalid type of TMO object: " + type);
        }
        commonLibrary.logObject(deviceStateClearModel);
        memory.setGeneratedObject(deviceStateClearModel);
    }

    @Given("^I generate a device state object to check multi-device session status$")
    public void generateDeviceStateCheckObject(){
        try {
            String tailNumber = memory.retrieveValue("tail_number");
            String userId = memory.retrieveValue("user_id");
            String ipAddress = memory.retrieveValue("ip_address");
            String productCode = memory.retrieveValue("product_code");
            logger.debug("Generating a device state check object to check session status");
            logger.debug("Device state check attributes set: \n" +
                    "tailNumber: " + tailNumber + "\n" +
                    "userId: " + userId + "\n" +
                    "ipAddress: " + ipAddress + "\n" +
                    "productCode: " + productCode + "\n"
            );
            DeviceStateCheckModel deviceStateCheckModel = new DeviceStateCheckModel(
                    configManager.getFLIGHTINFO_URI(),
                    tailNumber,
                    productCode,
                    userId,
                    ipAddress
            );
            memory.setGeneratedObject(deviceStateCheckModel);
        }
        catch (NullPointerException ex){
            logger.error("Could not find the value in memory. Please check cucumber feature file.");
            throw new NullPointerException("Could not find the value in memory. Please check cucumber feature file.");
        }
    }

    @Given("^I generate a device state object to clear mac address: \"(.*)\"$")
    public void generateDeviceStateClearMac(String macAddress){
        macAddress = commonLibrary.checkForVariables(macAddress);
        logger.debug("Generating an object to clear TMO EAP session with MAC address: " + macAddress);
        DeviceStateClearModel deviceStateClearModel = new DeviceStateClearModel();
        deviceStateClearModel.setMacaddress(macAddress);
        commonLibrary.logObject(deviceStateClearModel);
        memory.setGeneratedObject(deviceStateClearModel);
    }

}
