*** Settings ***
Library         SeleniumLibrary
Resource        common.resource


*** Variables ***
${BROWSER}          chrome
${CHROME_OPTIONS}   add_argument("--headless=new"); add_argument("--no-sandbox"); add_argument("--disable-dev-shm-usage"); add_argument("--window-size=1280,900")


*** Keywords ***
Open Login Page
    Open Browser    ${BASE_URL}/index.html    browser=${BROWSER}    options=${CHROME_OPTIONS}
    Wait Until Element Is Visible    id:page-title

Submit Login
    [Arguments]    ${username}    ${password}
    Input Text    id:username    ${username}
    Input Text    id:password    ${password}
    Click Button    id:submit

Page Title Should Be
    [Arguments]    ${expected}
    Wait Until Element Is Visible    id:page-title
    ${text}=    Get Text    id:page-title
    Should Be Equal    ${text}    ${expected}

Flash Message Should Be
    [Arguments]    ${expected}
    Wait Until Element Is Visible    id:flash
    ${text}=    Get Text    id:flash
    Should Be Equal    ${text}    ${expected}

Rejected Login Shows Error
    [Arguments]    ${username}    ${password}
    Open Login Page
    Submit Login    ${username}    ${password}
    Flash Message Should Be    Your username or password is invalid.
    Close Browser
