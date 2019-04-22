# Phishing Keylogger v2 (PhishLog)

PhishLog is a penetration testing and red teaming tool that automates the setup of a live keylogger that could be used with phishing campaigns to capture credentials and bypass two-factor authentication (2FA).

## Main Features

 - A keylogger that displays keystrokes in real time
 - Customizable audio tones that play as keystrokes are detected
 - All keystrokes are stored in log files
 - An additional file, per unique ID, is created to log the first time each phishing link is clicked
 - The JavaScript keylogger ("main.js") creates POST requests to "data/main.php"
 - The message "The username, password, or token was incorrect. Please try again." is displayed upon a login attempt
 - After three login attempts, the target is redirected to the real login page

## Main Files

 - index.html
   - Displays a message of "Access Denied. Please use the secure link provided."
 - main.js
   - Logs keystrokes by making POST requests to "data/main.php"
   - Contains a honeypot link to "data/loginAttempts.php"
 - data/loginAttempts.php
   - Honeypot page that records hits to the log files which can indicate that the security team is investigating
 - data/main.php
   - Writes the keystrokes and phishing data to log files
 - data/securedata/main[1|2|3].html
   - Displays the live keystrokes in real time
   - A customizable audio tone is played upon each keystroke
 - data/securedata/main1.html
   - The newest keystrokes are shown at the top of the page
   - The user-agent is not displayed, allowing more focus on the username, password, and token	
 - data/securedata/main2.html
   - The newest keystrokes are shown at the top of the page
   - The user-agent is displayed along with all other log data
 - data/securedata/main3.html
   - The newest keystrokes are shown at the bottom of the page
   - The user-agent is displayed along with all other log data
 - data/securedata/main4.php
   - Displays details of the first click logged for each unique ID in real time
 - data/securedata/unique/*.txt
   - Logs the first click details for each unique ID

## Installation

Clone the GitHub repository
```
git clone https://github.com/jamesm0rr1s/Phishing-Keylogger-v2 /opt/jamesm0rr1s/Phishing-Keylogger-v2
```

## Usage

 - Clone the real login page
   - Update the id of the input fields to `id="user"`, `id="pass"`, and `id="token"`
   - Add `<script src="main.js?ver=0"></script>` to the html code
 - Configure the web server by running the follow commands:
```
chmod +x /opt/jamesm0rr1s/Phishing-Keylogger-v2/setupWebServerForPhishing.sh
/opt/jamesm0rr1s/Phishing-Keylogger-v2/setupWebServerForPhishing.sh
```

## Example Screenshot of Live Keystrokes

![ExampleOutput-LiveKeystrokes](screenshot.png?raw=true "ExampleOutput-LiveKeystrokes")
