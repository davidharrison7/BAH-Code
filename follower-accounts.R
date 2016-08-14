#==============================================================================
# follower-accounts.R
# Purpose: Get username's for all followers of a given account
# Author: David Harrison
#==============================================================================

#Needs different form of OAuth access than other programs with stored file
#Consumer key and consumer secret are the same as with twitter-setup
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "http://api.twitter.com/oauth/authorize"
consumerKey <- "XXXXXXXXXXXXXXXXXXXXXXXXXX"
consumerSecret <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
my_oauth <- OAuthFactory$new(consumerKey=consumerKey,
consumerSecret=consumerSecret, requestURL=requestURL,
accessURL=accessURL, authURL=authURL)
my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))


#function to get limit rate for account so API doesn't kick you out
getLimitRate <- function(my_oauth){
  require(rjson); require(ROAuth)
  url <- "https://api.twitter.com/1.1/application/rate_limit_status.json"
  params <- list(resources = "followers,application")
  response <- my_oauth$OAuthRequest(URL=url, params=params, method="GET", 
                                    cainfo=system.file("CurlSSL", "cacert.pem", package = "RCurl"))
  return(unlist(fromJSON(response)$resources$application$`/application/rate_limit_status`[['remaining']]))
}

#function to get the number of follower accounts remaining to scrape
getLimitFollowers <- function(my_oauth){
  require(rjson); require(ROAuth)
  url <- "https://api.twitter.com/1.1/application/rate_limit_status.json"
  params <- list(resources = "followers,application")
  response <- my_oauth$OAuthRequest(URL=url, params=params, method="GET", 
                                    cainfo=system.file("CurlSSL", "cacert.pem", package = "RCurl"))
  return(unlist(fromJSON(response)$resources$followers$`/followers/ids`[['remaining']]))
}

#Main function to run, input desired screen name after it is run in the global environment
#Screen_name = the screen name of the account for which you want a list of followers screenames 
getFollowers <- function(screen_name, cursor=-1){
  
  require(rjson); require(ROAuth)
  
  limit <- getLimitFollowers(my_oauth)
  cat(limit, " hits left\n")
  while (limit==0){
    Sys.sleep(sleep)
    # sleep for 5 minutes if limit rate is less than 100
    rate.limit <- getLimitRate(my_oauth)
    if (rate.limit<100){
      Sys.sleep(300)
    }
    limit <- getLimitTimeline(my_oauth)
    cat(limit, " hits left\n")
  }
  ## url to call
  url <- "https://api.twitter.com/1.1/followers/ids.json"
  ## empty list for followers
  followers <- c()
  ## while there's more data to download...
  while (cursor!=0){
    ## making API call
    params <- list(screen_name = screen_name, cursor = cursor)
    url.data <- my_oauth$OAuthRequest(URL=url, params=params, method="GET", 
                                      cainfo=system.file("CurlSSL", "cacert.pem", package = "RCurl"))
    Sys.sleep(1)
    ## one API call less
    limit <- limit - 1
    ## trying to parse JSON data
    json.data <- fromJSON(url.data, unexpected.escape = "skip")
    if (length(json.data$error)!=0){
      cat(url.data)
      stop("error! Last cursor: ", cursor)
    }
    ## adding new IDS
    followers <- c(followers, as.character(json.data$ids))
    
    ## previous cursor
    prev_cursor <- json.data$previous_cursor_str
    ## next cursor
    cursor <- json.data$next_cursor_str
    ## giving info
    cat(length(followers), "followers. Next cursor: ", cursor, "\n")
    
    ## sleeping if we hit the limit
    cat(limit, " API calls left\n")
    while (limit==0){
      Sys.sleep(600)
      # sleep for 5 minutes if limit rate is less than 100
      rate.limit <- getLimitRate(my_oauth)
      if (rate.limit<100){
        Sys.sleep(300)
      }
      limit <- getLimitFollowers(my_oauth)
      cat(limit, " API calls left\n")
    }
  }
  return(followers)
}
