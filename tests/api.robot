*** Settings ***
Documentation       API-layer checks with RequestsLibrary against the local /api surface.
Resource            ../resources/api_keywords.resource
Suite Setup         Create API Session


*** Test Cases ***
Health endpoint reports ok
    Health Should Be Ok

Valid login returns a token
    ${resp}=    Login    ${USERNAME}    ${PASSWORD}
    Should Be Equal As Integers    ${resp.status_code}    200
    Should Not Be Empty    ${resp.json()}[token]

Invalid login is rejected
    ${resp}=    Login    ${USERNAME}    wrong-password
    Should Be Equal As Integers    ${resp.status_code}    401

Items require authentication
    ${resp}=    Get Items    ${EMPTY}
    Should Be Equal As Integers    ${resp.status_code}    401

Items are returned with a valid token
    ${login}=    Login    ${USERNAME}    ${PASSWORD}
    ${token}=    Set Variable    ${login.json()}[token]
    ${resp}=    Get Items    ${token}
    Should Be Equal As Integers    ${resp.status_code}    200
    Length Should Be    ${resp.json()}    3
