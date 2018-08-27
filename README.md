# QE IFS API Automated Integration Test Suite #

## Overview: ##
This is the automated test repository that will hold the automation test framework and tests for all things IFS and API related.
This test suite will cover all API level testing for the following integration between services:

1) ABP
2) GBPEdge
3) GBPLite
4) APIDecorator
5) RUPP
6) CloudDao
7) Session Management
8) IFSUtils
9) CPAPI
10) SCEMS
11) GroundGateway
12) FlightInfo
13) IFSGateway
14) CloudSync

Author: Brian DeSimone  
Date of Creation: 03/28/2018
Date of Last Update: 03/28/2018

## Framework: ##
- Cucumber
- TestNG
- RestAssured
- Gradle

## List of TODO Features: ##
Project Still in DEV!

## Features Added: ##
Project Still in DEV!

## TestNG Groups: ##
- cucumber

## Cucumber Test TAGS: ##
The following are the cucumber test levels that are used by providing tags in the cucumber.options environment variable

- HealthCheck
- Regression
- Positive
- Negative

## Environments: ##
This test suite can work with all test environments such as AWS or local. If running in AWS or against AWS services the following test. environment must be set to one of then below environments:

- dev
- stage
- prod

## Bug Tracking: ##
All bugs will be reported and tracked in JIRA. There is a test automation wrapper listener included in this project that can automatically post bugs to a JIRA board. See src/config directory to configure this feature.

## Tests Included: ##
For a detailed test plan and test coverage click [here]().
For a detailed doc on the service itself click [here]().
All of the below services are tested with the following types of tests:

- HealthCheck (Smoke)
- Feature Testing
- Positive Scenarios
- Negative Scenarios
- Error Message and Error Code Validation
- Edge Test Scenarios
- Regression (All of the Above)

#### APIs Tested: ####
Coming Soon!

## Project Structure: ##
This project contains the testing for multiple APIs. The structure is built to be very modular with the following implementation:

1. Lib Package - Contains all of the common generic classes, methods, and functions.
  - Framework Package
    - BaseTestCase
    - ConfigManager
    - Memory
  - Rest Package
    - RestCommonLibrary
    - GenericStepDefinitions
    - RestAssertStepDefinitions
  - Application Package
    - ApplicationSpecificStepDefinitions
  - Common Package
    - CommonLibrary
  - Enum Package
    - DataType
2. Pojo Package
  - Holds all POJOS for object generation from within cucumber step definitions
3. Scripts Package (Only used if TestNG tests are written without cucumber)
  - All scripts are placed here in seperate JAVA files per feature or API. This makes things modular and easier to keep track of and organize
4. Resources for Feature Files (Cucumber)
  - All feature files are stored as resources in the test package

## Logging: ##
All logs are output to the console and to a file via Log4j2. The log file is located at /src/logs

## Local Workstation Setup: ##
Local setup instructions coming soon!! Talk to Brian if you want this prioritized or need more info on this. As of now this is a backlog item.

## Running the Project: ##
Using Gradle the project can be run from the command line. There are two variables that can be set from the run command.

1. test.environment - Environment we want to run the tests on
2. cucumber.options - cucumber tag that we want to run (test level)

```bash
gradle test Dtest.environment={value} -Dcucumber.options={value}
```

**EXAMPLE:** The below example would run the healcheck test cases in the stage environment.

```bash
gradle test -Dtest.environment=stage -Dcucumber.options="--tags @HealthCheck"
```

**EXAMPLE2:** The below example would run the regression and healcheck test cases in the stage environment. This shows how to give multiple tags in the test argument from command line

```bash
gradle test -Dtest.environment=stage -Dcucumber.options="--tags @HealthCheck --tags @Regression"
```