*** Settings ***
Documentation  Use Selenium WebDriver and Applitools Eyes.
...  to install SeleniumLibrary => pip3 install --upgrade robotframework-seleniumlibrary
...  to install EyesLibrary => pip3 install eyes-robotframework
...  then Then, generate the Applitools configuration file => python3 -m EyesLibrary init-config
...  inside applitools.yaml, make sure to add API key!
...  After all libraries are installed, you need to disable Robocorp extension, restart extension and, enable it back on again
...  so visual studio can recognise those libraries.
...  Next, create applitools.yaml file. Inside this .yaml file set api_key: <your-api-key>
...  https://applitools.com/tutorials/quickstart/web/robot-framework
Library     SeleniumLibrary
Library     EyesLibrary       runner=web_ufg    config=applitools.yaml

# Declare setup and teardown routines.
Test Setup        Setup
Test Teardown     Teardown


*** Keywords ***
# For setup, load the demo site's login page and open Eyes to start visual testing.
Setup
    Open Browser    https://demo.applitools.com    headlesschrome
    Eyes Open

# For teardown, close Eyes and the browser.
Teardown
    Eyes Close Async
    Close All Browsers


*** Test Cases ***
# This test covers login for the Applitools demo site, which is a dummy banking app.
# The interactions use typical Selenium WebDriver calls,
# but the verifications use one-line snapshot calls with Applitools Eyes.
# If the page ever changes, then Applitools will detect the changes and highlight them in the Eyes Test Manager.
# Traditional assertions that scrape the page for text values are not needed here.
Log into bank account

    # Verify the full login page loaded correctly.
    Eyes Check Window    Login Page     Fully

    # Perform login.
    Input Text        id:username    applibot
    Input Text        id:password    I<3VisualTests
    Click Element     id:log-in

    # Verify the full main page loaded correctly.
    # This snapshot uses LAYOUT match level to avoid differences in closing time text.
    Eyes Check Window    Main Page    Fully    Match Level  LAYOUT