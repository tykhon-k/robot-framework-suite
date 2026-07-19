*** Settings ***
Documentation       UI-layer checks with SeleniumLibrary (headless Chrome) against the local app.
Resource            ../resources/ui_keywords.resource


*** Test Cases ***
Valid login reaches the secure area
    [Teardown]    Close All Browsers
    Open Login Page
    Submit Login    ${USERNAME}    ${PASSWORD}
    Wait Until Location Contains    secure.html
    Page Title Should Be    Secure Area

Invalid login is rejected
    [Template]    Rejected Login Shows Error
    [Teardown]    Close All Browsers
    admin    wrong-password
    nobody    admin123
    ${EMPTY}    ${EMPTY}
