<?php

/*
##########################################################
##  CONFIDENTIAL & PROPRIETARY
## Copyright (C) 2011 SumTotal Systems, Inc.
## All Rights Reserved.
##########################################################
*/

	//set the variables that make up our SSO

	//The users username
	$username='MyUser@geolearning.com';

	//The ID of the secret key in the GeoLearning LMS.
	$id = '1000';

	/*
	   The Secret Key
	   Keys should never be written into code like this. Always practice security and good key managemnt.
	   see the NIST recomendations:
	   http://csrc.nist.gov/publications/nistpubs/800-57/SP800-57-Part1.pdf

	   note that this is not a real key you should get your key from Geolearning.
	*/
	$key = 'ijZeXCslP1Ou2s8T6bR3sa3Dk3KKtTDvKKEz0UT0x2K0P6qoWlmApK7EgzIe1us';

	//The domain Folder
	$DomainPath = 'geonext';

	//Optional: the path to forward too after authenticating
	$OriginalURL = '/geonext/mysettingshome.geo?nav=SettingsandPrefsHome';


	//the time needs to be in UTC. grab the UTC time off the server and then format
	$date = gmdate("Y-m-d");
	$time = gmdate("H:i:s");
	$timestamp = $date . "T". $time . "Z";

	//append everything together into the HMAC string
	$hmacstring = $username . $timestamp . $key;

	//hash it with Sha-1
	$hmac = sha1($hmacstring);

	//build the query string
	$QueryString = array('username'=> $username,
	              		 'timestamp'=> $timestamp,
	              		 'id'=> $id,
              	  		 'hmac'=> $hmac,
              	  		 'OriginalURL' => $OriginalURL);

	// URL encode all of the parms
    $QueryStringEncoded = http_build_query($QueryString);

	// Format the link
	$launchlink = 'http://localhost/' . $DomainPath . '/sha1login.geo?' . $QueryStringEncoded;

	//use this if you want auto format
	//header("location:$launchlink");
?>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
	<meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
	<title>My PHP SSO</title>
	<meta name="generator" content="BBEdit 7.0" />
</head>
<body>


Click Here to Sign On: <a href="<?php echo $launchlink ?>"><?php echo $launchlink ?></a>


</body>
</html>