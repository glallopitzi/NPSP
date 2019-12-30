*** Settings ***

Resource        robot/Cumulus/resources/NPSP.robot
Library         cumulusci.robotframework.PageObjects
...             robot/Cumulus/resources/ContactPageObject.py
...             robot/Cumulus/resources/AccountPageObject.py
...             robot/Cumulus/resources/ManageHouseHoldPageObject.py
Suite Setup     Run keywords
...             Open Test Browser
...             Setup Test Data
Suite Teardown  Delete Records and Close Browser

*** Keywords ***

Setup Test Data
    &{contact} =         API Create Contact                    Email=${EMAIL1}
    Store Session Record  Account                               &{contact}[AccountId]
    Set suite variable    &{contact}
    ${first_name} =       Generate Random String
    Set suite variable    ${first_name}
    ${last_name} =        Generate Random String
    Set suite variable    ${last_name}

*** Variables ***
${EMAIL1}       user1@automation.com

*** Test Cases ***

Add New Contact to Existing Household 

    Go To Page                          Details
    ...                                 Account
    ...                                 object_id=&{contact}[AccountId]

    Click Link                          link=Manage Household
    Go To Page                          Custom                            ManageHousehold

    Add contact                         New                               ${first_name} ${last_name}
    Current Page Should Be              Details                           Account
    Wait Until Page Contains            Account Owner
    Wait For Record To Update           &{contact}[AccountId]             &{contact}[LastName] and ${last_name} Household
    Select Tab                          Related
    Load Related List                   Contacts
    Verify Related List Items           Contacts                          ${first_name} ${last_name}
