<?php
	# Set the timezone
	date_default_timezone_set("America/New_York");

	# Get the POST parameters
	$da = date("y-m-d h:i:sa");
	$ip = $_SERVER["REMOTE_ADDR"];
	$id = "loginAttempts";
	$us = "loginAttempts";
	$pa = "loginAttempts";
	$to = "loginAttempts";
	$ac = "loginAttempts";
	$ua = $_SERVER["HTTP_USER_AGENT"];

	# Create the string of data to save
	$data = "";
	$data .= $da . " \t";
	$data .= $ip . " \t";
	$data .= $id . " \t";
	$data .= $us . " \t";
	$data .= $pa . " \t";
	$data .= $to . " \t";
	$data .= $ac . " \t";
	$data .= $ua . " \n";

	# Create the string of data to save without the user agent for a cleaner look on the live output page
	$data1 = "";
	$data1 .= $da . " \t";
	$data1 .= $ip . " \t";
	$data1 .= $id . " \t";
	$data1 .= $us . " \t";
	$data1 .= $pa . " \t";
	$data1 .= $to . " \t";
	$data1 .= $ac . " \n";

	# Set the filenames
	$fn1 = "securedata/main1.txt";
	$fn2 = "securedata/main2.txt";
	$fn3 = "securedata/main3.txt";
	$fn4 = "securedata/unique/" . preg_replace("/[^A-Za-z0-9 ]/", "", $id) . ".txt";

	# Get the current file contents to place the new content at the top of the file
	$data1 .= file_get_contents($fn1);
	$data2 = $data . file_get_contents($fn2);

	# Save the data method 1
	function saveDataMethod1($fn1, $data1) {

		# Save the data
		file_put_contents($fn1, $data1, LOCK_EX);
	}

	# Save the data method 2
	function saveDataMethod2($fn2, $data2) {

		# Open the file
		$fp = fopen($fn2, "w");

		# Aquire an exclusive lock
		flock($fp, LOCK_EX);

		# Save the data
		fwrite($fp, $data2);

		# Release the lock
		flock($fp, LOCK_UN);

		# Close the file
		fclose($fp);
	}

	# Save the data method 3
	function saveDataMethod3($fn3, $data) {

		# Save the data
		file_put_contents($fn3, $data, FILE_APPEND);
	}

	# Save the data method 4
	function saveDataMethod4($fn4, $data) {

		# Check if the file does not exist
		if(!is_file($fn4)) {

			# Create a file for the data
			file_put_contents($fn4, $data);
		}
	}

	# Save the data two different ways
	saveDataMethod1($fn1, $data1);
	saveDataMethod2($fn2, $data2);

	# Save the data by appending to the end of the file
	saveDataMethod3($fn3, $data);

	# Save the data in a unique file per ID
	saveDataMethod4($fn4, $data);
?>
