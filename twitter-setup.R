#==============================================================================
# twitter-setup.R
# Purpose: Install R packages and setup OAuth token to query Twitter's API
# Author: David Harrison
#==============================================================================


#setup
library(twitteR)
library(streamR)
library(ROAuth)
library(httr)
library(openssl)

### REGISTERING OAUTH TOKEN ###

## Step 1: go to apps.twitter.com and sign in
## Step 2: click on "Create New App"
## Step 3: fill name, description, and website (it can be anything, even google.com)
##          (make sure you leave 'Callback URL' empty)
## Step 4: Agree to user conditions
## Step 5: copy consumer key and consumer secret and paste below

consumerKey <- "XXXXXXXXXXXXXXXXXXXXXXXXX"
consumerSecret <- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" 
accessKey <- "XXXXXXXXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXX"
accessSecret <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" 

#function in twitteR to store oauth for session
setup_twitter_oauth(consumerKey, consumerSecret, accessKey, accessSecret)
#select option 1 to for local cache
