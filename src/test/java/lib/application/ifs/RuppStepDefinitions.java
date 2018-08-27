package lib.application.ifs;

import cucumber.api.java.en.Given;
import lib.common.CommonLibrary;
import lib.framework.BaseTestCase;
import models.unitedMileage.UnitedMileagePlusLoginModel;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * This class is an application library that will hold all cucumber step definitions and specific functions for RUPP
 *
 * @Author Brian DeSimone
 * @Date 04/25/2018
 */
public class RuppStepDefinitions extends BaseTestCase {

    // GLOBAL CLASS VARIABLES
    private static Logger logger = LogManager.getLogger(RuppStepDefinitions.class);
    private static CommonLibrary commonLibrary = new CommonLibrary();

    @Given("^I generate a United Mileage Plus Login object with key_id: \"(.*)\"$")
    public void GenerateUnitedMileagePlusLogin(String keyId){
        keyId = commonLibrary.checkForVariables(keyId);
        logger.debug("Generating a login object for the United Mileage Plus Promotion from key_id: " + keyId);
        UnitedMileagePlusLoginModel unitedModel = new UnitedMileagePlusLoginModel(
                memory.retrieveValue("airline_code"),
                memory.retrieveValue("tail_number"),
                memory.retrieveValue("flight_number"),
                keyId
        );
        memory.setGeneratedObject(unitedModel);
    }

}
