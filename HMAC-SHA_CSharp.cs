/*
##########################################################
##  CONFIDENTIAL & PROPRIETARY
## Copyright (C) 2011 SumTotal Systems, Inc.
## All Rights Reserved.
##########################################################
*/

using System;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace MaestroSilentLogin {
    public class MaestroSilentLogin {

        public static void Main() {
		/*
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
		*/
		
            var msl = new MaestroSilentLogin();
            msl.Launch("geoadmin", 42, "4BDA179E-0BA6-9592-BB07B2CE6688AE3B", "/geonext/MyCompany/trainingandmetricshome.geo?nav=TrainingandMetrics");
        }

        public void Launch(string username, int keyNumber, string secretKey, string originalURL)
        {
            var timeStamp = DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ");

            // If useing sha1 then use the sha1login.geo endpoint
            var launchlink = new StringBuilder();
            launchlink.Append("https://gm1.geolearning.com/geonext/MyCompany/sha256Login.geo");
            launchlink.Append("?username=" + username);
            launchlink.Append("&timestamp=" + HttpUtility.UrlEncode(timeStamp));
            launchlink.Append("&id=" + keyNumber);
            launchlink.Append("&hmac=" + GetHMAC(username,timeStamp,secretKey));
            if(!String.IsNullOrEmpty(originalURL)){
                launchlink.Append("&OriginalURL=" + HttpUtility.UrlEncode(originalURL));
            }


            //launch IE with the link
            Console.WriteLine("**************** Here we Go. Weeeeeeeeee!");
            System.Diagnostics.Process.Start("IExplore.exe", launchlink.ToString());
        }

        private string GetHMAC(string username, string timestamp, string key) {
            
            // put together the HMAC
            var aSourceData = username + timestamp + key;

            // Create a byte array from source data
            var tmpSource = Encoding.ASCII.GetBytes(aSourceData);

            // Compute hash based on source data with either sha-1 or sha-256
            var tmpHash = new SHA256Managed().ComputeHash(tmpSource);
            //var tmpHash = new SHA1CryptoServiceProvider().ComputeHash(tmpSource);

            // convert the hash to hex
            var hmac = BitConverter.ToString(tmpHash).Replace("-", "");
            Console.WriteLine("HMAC Generated: " + hmac);

            return hmac;
        }
    }
}
