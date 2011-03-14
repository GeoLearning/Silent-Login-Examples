/*
##########################################################
## CONFIDENTIAL & PROPRIETARY
##
## Copyright (C) 2011 SumTotal Systems, Inc.
## All Rights Reserved.
##########################################################
*/

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.*;
import java.text.*;
import java.net.URLEncoder;

public class HMAC_SHA_Java
{
        public static void main(String args[])
        {
        	// set the variables that make up our SSO
        	// The users username
        	String username = "MyUser@geolearning.com";

        	// the ID of the secret key in the GeoLearning LMS.
        	String id = "1000";

        	/*
		   The Secret Key
		   Keys should never be written into code like this. Always practice security and good key managemnt.
		   see the NIST recomendations:
		   http://csrc.nist.gov/publications/nistpubs/800-57/SP800-57-Part1.pdf

		   note that this is not a real key you should get your key from Geolearning.
		*/
        	String key = "ijZeXCslP1Ou2s8T6bR3sa3Dk3KKtTDvKKEz0UT0x2K0P6qoWlmApK7EgzIe1us";

        	// The domain Folder
        	String domainPath = "geonext";

        	// Optional: the path to forward too after authenticating
        	String originalURL = "/geonext/mysettingshome.geo?nav=SettingsandPrefsHome";

        	// the time needs to be in UTC. grab the UTC time off the server and then format
        	//get a date object
        	Date now = new Date();
        	// create a simple date format object
        	SimpleDateFormat myISOFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
        	//set the formatter to return us UTC
        	myISOFormat.setTimeZone(TimeZone.getTimeZone("GMT"));
        	//Parse the date
        	String timestamp = myISOFormat.format(now);



        	//append everything together into the HMAC string
        	String hmacstring = username + timestamp + key;

        	String hmac = "";

        	//hash it with sha256. for some reason sun never thought you would need a hash in hex??!
        	// you would probably want to wrap this into some kind of utility class for re-use. Its very handy.
		// to use SHA-1 use the "SHA-1" constant in MessageDigest.getInstance
        	 byte[] defaultBytes = hmacstring.getBytes();
        	 try{
				 MessageDigest algorithm = MessageDigest.getInstance("SHA-256");
				 algorithm.reset();
				 algorithm.update(defaultBytes);
				 byte messageDigest[] = algorithm.digest();
				 StringBuffer hexString = new StringBuffer();

				 for (int i=0;i<messageDigest.length;i++) {
					String hex = Integer.toHexString(0xFF & messageDigest[i]);
					if(hex.length()==1)
						hexString.append('0');
						hexString.append(hex);
					}

				hmac = hexString.toString();
			 }catch(NoSuchAlgorithmException nsae){

 			 }

			 // now append everything into a URL, making sure to urlencode the values
			 // if using sha-1 change the endpoint to "sha1login.geo"
			 String launchlink = "http://gm1.geolearning.com/geonext/myCompany/sha256login.geo?";
			 try{
				 launchlink = launchlink + "username=" + URLEncoder.encode(username, "UTF-8");
				 launchlink = launchlink + "&timestamp=" + URLEncoder.encode(timestamp, "UTF-8");
				 launchlink = launchlink + "&id=" + URLEncoder.encode(id, "UTF-8");
				 launchlink = launchlink + "&hmac=" + URLEncoder.encode(hmac, "UTF-8");
				 launchlink = launchlink + "&OriginalURL=" + URLEncoder.encode(originalURL, "UTF-8");
			 }catch(java.io.UnsupportedEncodingException uee){

			 }

			//return the link, if this were being called in JSP you would want to pop this link into a header redirect.
           	System.out.println(launchlink);
        }
}