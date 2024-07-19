*** Settings ***
Documentation  API Testing in Robot Framework,
...  To install Selenium Library => pip3 install --upgrade robotframework-seleniumlibrary
...  https://pypi.org/project/robotframework-seleniumlibrary/
...  To install RequestsLibrary => pip3 install robotframework-requests.
...  to install JSONLibrary => pip3 install robotframework-jsonlibrary.
...  After all libraries are installed, you need to disable Robocorp extension, restart extension and, enable it back on again
...  so visual studio can recognise those libraries.
    
Library  SeleniumLibrary
Library  RequestsLibrary
Library  JSONLibrary
Library  Collections

*** Variables ***

*** Test Cases ***
Testcase1 Do a GET Request and validate the response code and response body
    [documentation]  This test case verifies that the response code of the GET Request should be 200,
    ...  the response body contains the [name] with value as 'Zurich Airport',
    ...  and the response body contains [id] element.
    ...  and the header [Content-Type] = "application/json"
    [tags]  Smoke
    Create Session  mysession  https://freetestapi.com   verify=true
    ${response}=  GET On Session  mysession  /api/v1/airports  params=search=Zurich
    Status Should Be  200  ${response}  #Check Status as 200

    #Check if [name] = "Zurich Airport" from Response Body
    ${name}=  Get Value From Json  ${response.json()}[0]  name
    Log To Console    response.json is ${response.json()}[0]
    Log To Console    name value is ${name}
    ${nameFromList}=  Get From List   ${name}  0
    Should be equal  ${nameFromList}  Zurich Airport

    #Check if [id] is present in the response body
    ${body}=  Convert To String  ${response.content}
    Should Contain  ${body}  id

    #Check if the value of the header Content-Type = "application/json"
    ${getHeaderValue}=  Get From Dictionary  ${response.headers}  Content-Type
    Log To Console    get header value is ${getHeaderValue}
    Should be equal  ${getHeaderValue}  application/json

Testcase2 Do a POST Request and validate the response code, response body, and response headers
    [documentation]  This test case verifies that the response code of the POST Request should be 201,
    ...  the response body contains the 'id' key with value '101',
    ...  and the response header 'Content-Type' has the value 'application/json; charset=utf-8'.
    [tags]  Regression
    Create Session  mysession  https://jsonplaceholder.typicode.com  verify=true
    &{body}=  Create Dictionary  title=foo  body=bar  userId=9000
    &{header}=  Create Dictionary  Cache-Control=no-cache
    ${response}=  POST On Session  mysession  /posts  data=${body}  headers=${header}
    Status Should Be  201  ${response}  #Check Status as 201

    #Check id as 101 from Response Body
    ${id}=  Get Value From Json  ${response.json()}  id
    ${idFromList}=  Get From List   ${id}  0
    ${idFromListAsString}=  Convert To String  ${idFromList}
    Should be equal As Strings  ${idFromListAsString}  101

    #Check the value of the header Content-Type
    ${getHeaderValue}=  Get From Dictionary  ${response.headers}  Content-Type
    Should be equal  ${getHeaderValue}  application/json; charset=utf-8

*** Keywords ***