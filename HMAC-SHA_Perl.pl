##########################################################
##  CONFIDENTIAL & PROPRIETARY
## Copyright (C) 2011 SumTotal Systems, Inc.
## All Rights Reserved.
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

# can be sha-1 or sha-256. Note that when doing sha-256 you must use a different endpoint from the default in this example
# $hmac = sha256_hex($hmacString);
$hmac = sha1_hex($hmacString);

#print "<br>";
#print $hmac;
#print "<br>";

#Format the link, when useing SHA-256 change the file endpoint to 'sha256login.geo'
$launchLink = "http://localhost/".$domainPath."/sha1login.geo?username=".$username."&timestamp=".$timeStamp."&id=".$id."&hmac=".$hmac."&originalURL=".$originalURL;


print "<br><p>";
print "Click Here to Sign On: <a href=$launchLink>$launchLink</a>" ;
print "<br>";
