using System;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Xml;

namespace MaestroSilentLogin {
    class MaestroSilentLogin {
        readonly XmlDocument config = new XmlDocument();
        private readonly string username;
        private readonly string URL;
        private readonly string keyID;
        private readonly string key;
        private readonly StringBuilder launchlink = new StringBuilder();
        private readonly string timestamp;
        private readonly string originalURL;

        public MaestroSilentLogin() {
            config.Load("Settings.xml");
            username = config.SelectSingleNode("/Settings/username").InnerText;
            URL = config.SelectSingleNode("/Settings/url").InnerText;
            keyID = config.SelectSingleNode("/Settings/keyID").InnerText;
            key = config.SelectSingleNode("/Settings/key").InnerText;
            originalURL = config.SelectSingleNode("/Settings/originalURL").InnerText;

            // the time needs to be in UTC. grab the UTC time off the server and then format
            timestamp = DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ");

            Console.WriteLine("**************** BEGIN SHA-1 SILENT LOGIN TESTER ***************");
            Console.WriteLine("USERNAME: " + username);
            Console.WriteLine("DOMAIN URL: " + URL);
            Console.WriteLine("KeyID: " + keyID);
            Console.WriteLine("KEY: " + key);
            Console.WriteLine("ORIGINAL URL (optional): " + originalURL);
        }

        static void Main() {
            MaestroSilentLogin msl = new MaestroSilentLogin();
            msl.Launch();
        }

        private void Launch() {
            
            launchlink.Append(URL);
            launchlink.Append("?username=" + HttpUtility.UrlEncode(username));
            launchlink.Append("&timestamp=" + HttpUtility.UrlEncode(timestamp));
            launchlink.Append("&id=" + keyID);
            launchlink.Append("&hmac=" + GetHMAC());
            if(!String.IsNullOrEmpty(originalURL)){
                launchlink.Append("&OriginalURL=" + HttpUtility.UrlEncode(originalURL));
            }
            //launch IE with the link
            Console.WriteLine("**************** Here we Go. Weeeeeeeeee!");
            System.Diagnostics.Process.Start("IExplore.exe", launchlink.ToString());
        }

        private string GetHMAC() {
            
            // now put together the hmac, hash it and hex format
            string aSourceData;
            string hmac;
            byte[] tmpSource;
            byte[] tmpHash;

            // put together the HMAC
            aSourceData = username + timestamp + key;

            // Create a byte array from source data
            tmpSource = ASCIIEncoding.ASCII.GetBytes(aSourceData);

            // Compute hash based on source data
            tmpHash = new SHA1CryptoServiceProvider().ComputeHash(tmpSource);

            // convert the hash to hex
            hmac = BitConverter.ToString(tmpHash).Replace("-", "");
            Console.WriteLine("HMAC Generated: " + hmac);

            return hmac;
        }
    }
}
