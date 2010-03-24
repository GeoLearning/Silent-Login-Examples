#!/usr/bin/ruby -w


##########################################################
## GeoNext Project
##
## CONFIDENTIAL & PROPRIETARY
##
## Copyright (C) 2004 - 2007 by Geolearning, Inc.
## All Rights Reserved.
##
## Written by Ryan Bergman
##
## $Header: /GeoNext/GeoNext/Public/Geolearning/Security/Authen/Examples/HMAC-SHA1_Ruby.rb,v 1.2 2008/01/30 16:43:45 rbergman Exp $
##########################################################

require 'digest/sha1'
require 'date'
require 'uri'

#The users username
username='MyUser@geolearning.com'

# The ID of the Key
id = '1000'

### The Secret Key
##  Keys should never be written into code like this. Always practice security and good key managemnt.
#   see the NIST recomendations:
#   http://csrc.nist.gov/publications/nistpubs/800-57/SP800-57-Part1.pdf
#   note that this is not a real key you should get your key from Geolearning.
key = 'ijZeXCslP1Ou2s8T6bR3sa3Dk3KKtTDvKKEz0UT0x2K0P6qoWlmApK7EgzIe1us'

#The domain Folder
DomainPath = 'geonext'

#Optional: the path to forward too after authenticating
OriginalURL = '/geonext/mysettingshome.geo?nav=SettingsandPrefsHome'


#the time needs to be in UTC. grab the UTC time off the server and then format
now = Time.now       
now = now.gmtime              
ISO_Pattern = '%Y-%m-%dT%H:%M:%SZ'
TimeStamp = now.strftime(ISO_Pattern)


#append everything together into the HMAC string
hmacstring = "%s%s%s" % [username,TimeStamp,key]

#hash it with sha1
hmac = Digest::SHA1.hexdigest(hmacstring)

#Format the link
QueryString = "http://localhost/%s/sha1login.geo?username=%s&timestamp=%s&id=%s&hmac=%s&OriginalURL=%s" % [DomainPath,username,TimeStamp,id,hmac,OriginalURL]

#URL encode all of the parms
QueryStringEnd = URI.escape(QueryString)

#Print "HMAC: " + hmac + "\n"

print QueryStringEnd + "\n"
