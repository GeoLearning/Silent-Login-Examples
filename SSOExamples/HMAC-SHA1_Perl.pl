##########################################################
## GeoNext Project 
##
## CONFIDENTIAL & PROPRIETARY
##
## Copyright (C) 2004 - 2007 by Geolearning, Inc.
## All Rights Reserved.
##
## Written by Utpal Patel, Ryan Bergman
##
## $Header: /GeoNext/GeoNext/Public/Geolearning/Security/Authen/Examples/HMAC-SHA1_Perl.pl ,v 5.10.0 2008/04/29 18:47:49Z upatel Exp $
##########################################################

#!/usr/bin/perl 
use HTTP::Date;
use Digest::SHA1  qw(sha1 sha1_hex sha1_base64);

print "HTTP/1.0 200 OK\n";
print "Content-Type: text/html\n\n\n";

######set the variables that make up our SSO 
# the username
$username = 'user@jim.org';

# the ID of the secret key in the geolearning LMS.
$id = '1000';

##########################################################
## The Secret Key
##  The Secret Key
##   Keys should never be written into code like this. Always practice security and good key managemnt.
##   see the NIST recomendations:
##   http://csrc.nist.gov/publications/nistpubs/800-57/SP800-57-Part1.pdf
##
##   note that this is not a real key you should get your key from Geolearning.
##   note also that CF uses pounds to signify output. So we need two punds here to escape the pound and produce only one.
###########################################################
$key = 'ijZeXCslP1Ou2s8T6bR3sa3Dk3KKtTDvKKEz0UT0x2K0P6qoWlmApK7EgzIe1us';


# the domain folder
$domainPath = 'geonext';

# Optional: the path to forward too after authenticating
$originalURL = '/geonext/mysettingshome.geo?nav=SettingsandPrefsHome';

# the time needs to be in UTC. get the time of request and then format
$timeStamp = HTTP::Date::time2isoz();
my ($date,$time) = split(" ",HTTP::Date::time2isoz());
$timeStamp = $date."T".$time;


# Now its time to hash all the required variables together using  SHA1 algorithum
# first appent all required variables i.e username+timestamp+key
$hmacString = $username.$timeStamp.$key;

# now hash it
$hmac = sha1_hex($hmacString);

#print "<br>";
#print $hmac;
#print "<br>";

#Format the link
$launchLink = "http://localhost/".$domainPath."/sha1login.geo?username=".$username."&timestamp=".$timeStamp."&id=".$id."&hmac=".$hmac."&originalURL=".$originalURL;


print "<br><p>";
print "Click Here to Sign On: <a href=$launchLink>$launchLink</a>" ;
print "<br>";
