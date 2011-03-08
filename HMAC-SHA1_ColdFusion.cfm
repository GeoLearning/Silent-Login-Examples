<!---
##########################################################
##  CONFIDENTIAL & PROPRIETARY
##
## Copyright (C) 2011 SumTotal Systems, Inc.
## All Rights Reserved.
##########################################################
--->

<!--- set the variables that make up our SSO --->
<!--- The users username --->
<cfset variables.username = 'MyUser@geolearning.com' />

<!--- he ID of the secret key in the GeoLearning LMS.--->
<cfset variables.id = '1000' />

<!--- The secret Key --->
<!---
   The Secret Key
   Keys should never be written into code like this. Always practice security and good key managemnt.
   see the NIST recomendations:
   http://csrc.nist.gov/publications/nistpubs/800-57/SP800-57-Part1.pdf

   note that this is not a real key you should get your key from Geolearning.
   note also that CF uses pounds to signify output. So we need two punds here to escape the pound and produce only one.
--->
<cfset variables.key = 'ijZeXCslP1Ou2s8T6bR3sa3Dk3KKtTDvKKEz0UT0x2K0P6qoWlmApK7EgzIe1us' />

<!--- The domain Folder --->
<cfset variables.DomainPath = 'geonext' />

<!--- Optional: the path to forward too after authenticating --->
<cfset variables.OriginalURL = '/geonext/mysettingshome.geo?nav=SettingsandPrefsHome' />

<!--- the time needs to be in UTC. grab the UTC time off the server and then format --->
<cfset variables.utc = DateConvert("local2Utc", now()) />
<cfset variables.timestamp = dateformat(variables.utc,'yyyy-mm-dd') & "T" & timeformat(variables.utc,'HH:MM:SS') & "Z" />

<!--- append everything together into the HMAC string --->
<cfset variables.hmacstring = variables.username & variables.timestamp & variables.key />

<!--- hash it with MD5 --->
<cfset variables.hmac = lcase(hash(variables.hmacstring,'SHA1')) />

<!--- format the link --->
<cfset variables.launchlink = "http://localhost/" & variables.DomainPath & "/sha1login.geo?"
							   & "username=" & urlencodedformat(variables.username)
							   & "&timestamp=" & urlencodedformat(variables.timestamp)
							   & "&id=" & variables.id
							   & "&hmac=" & variables.hmac
							   & "&OriginalURL=" & urlencodedformat(variables.OriginalURL) />


<!--- If you wish to forward directly do it now --->
<!--- <cflocation addtoken="no" URL="#variables.launchlink#" /> --->




<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
	<meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
	<title>My ColdFusion SSO</title>
	<meta name="generator" content="BBEdit 7.0" />
</head>
<body>

<cfoutput>
	Click Here to Sign On: <a href="#variables.launchlink#">#variables.launchlink#</a>
</cfoutput>

</body>
</html>



