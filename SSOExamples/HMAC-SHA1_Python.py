#!/usr/bin/python

##########################################################
## CONFIDENTIAL & PROPRIETARY
##
## Copyright (C) 2011 by SumTotal Systems, Inc.
## All Rights Reserved.
##########################################################

# Import libraries
try:
    import hashlib #: Python >=2.5
except ImportError:
    import sha as hashlib #: Python <2.5
from datetime import datetime
from urllib import quote as urlencode
from sys import stdout


class HMACLogin(object):

    # define constants for this class    
    utc_timestamp_format = '%Y-%m-%dT%H:%M:%SZ'
    
    # Use sha1login.geo for SHA-1 
    # Use sha256login.geo for SHA-256
    url_query = "https://gm1.geolearning.com/geonext/MyCompany/sha1login.geo?username=%s&timestamp=%s&id=%s&hmac=%s"
        
    def __init__(self, key_id, key_value,  original_url=None):
        self.key_id = key_id
        self.key_value = key_value
        self.original_url = original_url

        
    def _get_utc_timestamp(self):
        return datetime.utcnow().strftime(self.__class__.utc_timestamp_format)
            
    def _get_hmac_string(self, username):
        return "%s%s%s" % (username, self._get_utc_timestamp(), self.key_value)
        
    def _get_hmac_string_hash(self, username):
        # Two options,: SHA1 and SHA256 (available 3/25/2011
        #  hashed_string = hashlib.sha256()
        hashed_string = hashlib.sha1() #: Create hash instance
        hashed_string.update( self._get_hmac_string(username) ) #: Add text
        return hashed_string.hexdigest() #: Return hexadecimal digest value
        
    def _get_url_values(self,username):
        url_values = (
            username,
            self._get_utc_timestamp(),
            self.key_id,
            self._get_hmac_string_hash(username)
            )
        return url_values
        
    def get_login_url(self, username):
        url_vals = self._get_url_values(username)
        url = self.__class__.url_query % (url_vals)
        if self.original_url:
            url += '&OriginalURL=%s' % (self.original_url)
        return url
        
    
def main():
    # Define some example data
    key_id = '1000'
    # The Secret Key
    #  Keys should never be written into code like this. Always practice security and good key managemnt.
    #   see the NIST recomendations:
    #   http://csrc.nist.gov/publications/nistpubs/800-57/SP800-57-Part1.pdf
    #   note that this is not a real key you should get your key from Geolearning.
    key_value = r'ijZeXCslP1Ou2s8T6bR3sa3Dk3KKtTDvKKEz0UT0x2K0P6qoWlmApK7EgzIe1us' #: save as raw data
    original_url = '/geonext/MyCompany/trainingandmetricshome.geo?nav=TrainingandMetrics'
    username = 'MyUser@geolearning.com'
    
    # Call HMACLogin and return the login url using the example username
    hmac_login = HMACLogin(
        key_id = key_id,
        key_value = key_value,
        original_url = original_url
        )
    return hmac_login.get_login_url(username)
        
if __name__ == '__main__':
    """Execute the main function and write the result to standard out"""
    result = "%s\n" % ( main() )
    stdout.write(result)
    
    
