*** Settings ***
Library         RequestsLibrary
Library         Collections
Resource        common.resource


*** Keywords ***
Create API Session
    Create Session    api    ${BASE_URL}

Health Should Be Ok
    ${resp}=    GET On Session    api    /api/health
    Should Be Equal As Integers    ${resp.status_code}    200
    Should Be Equal    ${resp.json()}[status]    ok

Login
    [Arguments]    ${username}    ${password}
    ${body}=    Create Dictionary    username=${username}    password=${password}
    ${resp}=    POST On Session    api    /api/login    json=${body}    expected_status=any
    RETURN    ${resp}

Get Items
    [Arguments]    ${token}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${resp}=    GET On Session    api    /api/items    headers=${headers}    expected_status=any
    RETURN    ${resp}
