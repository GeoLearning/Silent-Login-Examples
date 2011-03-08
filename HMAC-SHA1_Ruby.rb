#!/usr/bin/ruby -w

##########################################################
## GeoNext Project
##
## CONFIDENTIAL & PROPRIETARY
##
## Copyright (C) 2011 by Sumtotal Systems Inc.
## All Rights Reserved.
##
## Written by Ryan Bergman
##
##########################################################

require 'digest/sha1'
require 'date'
require 'uri'

#The users username
username='geositeadmin'

# The ID of the Key
id = '1234'

### The Secret Key
##  Keys should never be written into code like this. Always practice security and good key managemnt.
#   see the NIST recomendations:
#   http://csrc.nist.gov/publications/nistpubs/800-57/SP800-57-Part1.pdf
#   note that this is not a real key you should get your key from SumTotal.
key = 'ijZeXCslP1Ou2s8T6bR3sa3Dk3KKtTDvKKEz0UT0x2K0P6qoWlmApK7EgzIe1us'


#Optional: the path to forward too after authenticating
OriginalURL = '/geonext/MyCompany/trainingandmetricshome.geo?nav=TrainingandMetrics'


#the time needs to be in UTC. grab the UTC time off the server and then format
now = Time.now       
now = now.gmtime              
ISO_Pattern = '%Y-%m-%dT%H:%M:%SZ'
TimeStamp = now.strftime(ISO_Pattern)


#append everything together into the HMAC string
hmacstring = "%s%s%s" % [username,TimeStamp,key]

# hash it with sha256
# Maestro offers 2 options: SHA256 and SHA1. Sha256 will be available March 25th 2011
hmac = Digest::SHA256.hexdigest(hmacstring)

#Format the link
QueryString = "https://gm1.geolearning.com/geonext/MyCompany/sha256login.geo?username=%s&timestamp=%s&id=%s&hmac=%s&OriginalURL=%s" % [username,TimeStamp,id,hmac,OriginalURL]

#URL encode all of the parms
QueryStringEnd = URI.escape(QueryString)

#Print "HMAC: " + hmac + "\n"

print QueryStringEnd + "\n"
