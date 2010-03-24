#!/usr/bin/python

##########################################################
## GeoNext Project
##
## CONFIDENTIAL & PROPRIETARY
##
## Copyright (C) 2004 - 2007 by Geolearning, Inc.
## All Rights Reserved.
##
## Written by Kevin Williams
##
## $Header: /GeoNext/GeoNext/Public/Geolearning/Security/Authen/Examples/HMAC-SHA1_Python.py,v 1.2 2008/01/30 16:43:45 rbergman Exp $
##########################################################

"""An example of an HMAC "single sign-on" login for GeoMaestro 5 written in 
Python.

    HMACLogin: A class for creating an HMACLogin URL compatible with
        GeoMaestro 5 -- please view the HMACLogin docstring for more
        information.

This script can be executed directly from the command line for example
purposes."""

# Import libraries
try:
    import hashlib #: Python >=2.5
except ImportError:
    import sha as hashlib #: Python <2.5
from datetime import datetime
from urllib import quote as urlencode
from sys import stdout


class HMACLogin(object):
    """Performs an HMAC login to GeoMaestro 5. Supports the following public
    methods:
    
    __init__(key_id, key_value, domain_path, [original_url]): Initialises the
        class.
        
    get_login_url(username): Returns a completed login url for the provided
        username.
        """
    # define constants for this class    
    utc_timestamp_format = '%Y-%m-%dT%H:%M:%SZ'
    url_query = "%s://%s/%s/sha1login.geo?username=%s&timestamp=%s&id=%s" \
        "&hmac=%s"
        
    def __init__(self, key_id, key_value, domain_path, host_name=None, \
        original_url=None, use_https=False):
        """Initialise the class"""
        self.key_id = key_id
        self.key_value = key_value
        self.domain_path = domain_path
        self.host_name = host_name or 'localhost'
        self.original_url = original_url
        self.use_https = self._get_protocol(use_https)

    def _get_protocol(self, secure):
        """Returns the correct protocol value for a URI"""
        if secure:
            return 'https'
        else:
            return 'http'
        
    def _get_utc_timestamp(self):
        """Returns a UTC-formatted timestamp"""
        return datetime.utcnow().strftime(self.__class__.utc_timestamp_format)
            
    def _get_hmac_string(self, username):
        """Returns an HMAC-formatted string"""
        return "%s%s%s" % (username, self._get_utc_timestamp(), self.key_value)
        
    def _get_hmac_string_hash(self, username):
        """Returns an sha-1-hashed HMAC string"""
        hashed_string = hashlib.sha() #: Create hash instance
        hashed_string.update( self._get_hmac_string(username) ) #: Add text
        return hashed_string.hexdigest() #: Return hexadecimal digest value
        
    def _get_url_values(self,username):
        """Returns packed values for populating url_query"""
        url_values = (
            self.use_https,
            self.host_name,
            self.domain_path,
            username,
            self._get_utc_timestamp(),
            self.key_id,
            self._get_hmac_string_hash(username)
            )
        return url_values
        
    def get_login_url(self, username):
        """Performs a login for the provided username"""
        url_vals = self._get_url_values(username)
        url = self.__class__.url_query % (url_vals)
        if self.original_url:
            url += '&OriginalURL=%s' % (self.original_url)
        return url
        
    
def main():
    """A function for handling direct execution of this script; returns a 
    completed HMACLogin url using example data"""
    # Define some example data
    key_id = '1000'
    ### The Secret Key
    ##  Keys should never be written into code like this. Always practice security and good key managemnt.
    #   see the NIST recomendations:
    #   http://csrc.nist.gov/publications/nistpubs/800-57/SP800-57-Part1.pdf
    #   note that this is not a real key you should get your key from Geolearning.
    key_value = r'ijZeXCslP1Ou2s8T6bR3sa3Dk3KKtTDvKKEz0UT0x2K0P6qoWlmApK7EgzIe1us' #: save as raw data
    domain_path = 'geonext'
    host_name = 'localhost'
    original_url = '/geonext/mysettingshome.geo?nav=SettingsandPrefsHome'
    username = 'MyUser@geolearning.com'
    
    # Call HMACLogin and return the login url using the example username
    hmac_login = HMACLogin(
        key_id = key_id,
        key_value = key_value,
        domain_path = domain_path,
        host_name = host_name,
        original_url = original_url,
        use_https = False
        )
    return hmac_login.get_login_url(username)
        
if __name__ == '__main__':
    """Execute the main function and write the result to standard out"""
    result = "%s\n" % ( main() )
    stdout.write(result)
    
    
