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
    class MaestroSilentLogin {

        static void Main() {
            var msl = new MaestroSilentLogin();
            msl.Launch("MyUserName", 42, "ijZeXCslP1Ou2s8T6bR3sa3Dk3KKtTDvKKEz0UT0x2K0P6qoWlmApK7EgzIe1us", "/geonext/MyCompany/trainingandmetricshome.geo?nav=TrainingandMetrics");
        }

        private void Launch(string username, int keyNumber, string secretKey, string originalURL)
        {
            var timeStamp = DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ");

            var launchlink = new StringBuilder();
            launchlink.Append("https://gm1.geolearning.com/geonext/MyCompany/sha1Login.geo");
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

            // Compute hash based on source data
            var tmpHash = new SHA1CryptoServiceProvider().ComputeHash(tmpSource);

            // convert the hash to hex
            var hmac = BitConverter.ToString(tmpHash).Replace("-", "");
            Console.WriteLine("HMAC Generated: " + hmac);

            return hmac;
        }
    }
}
