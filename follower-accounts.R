#==============================================================================
# follower-accounts.R
# Purpose: Get user ID numbers for all followers of a given account
# Pass ID numbers to return full acount information for each follower
# Once accounts information is stored, uses each account's username to return
# Last 200 tweets and appends them to each user
# some sections called as functions, some are command line driven
# Author: David Harrison
#==============================================================================

#Needs different form of OAuth access than other programs with stored token
#Consumer key and consumer secret are the same as with twitter-setup.R
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

#run line example for function
NBfollowers <- getFollowers(screen_name = "NB_Baseball")
NB <- as.numeric(levels(NBfollowers$followers))[NBfollowers$followers]

#initialize empty data frame after follower ids are obtained
Followerstack <- data.frame()

#Run line to create dataframe with follower account information
#will need to run for a while to gather all users
#For each user returns: account description, number of statuses, follower num,
#Favorite num, friends num, self identified name, date account was created,
#Screen name, language, user id, and link to profile image
for (i in 1:30000){
  
  flag <- TRUE  
  #gets user information for each ID number
  #skips users who's accounts are protected or produce errors
  Followerinfo <- tryCatch(lookupUsers(NB[i,1]), error = function(e) flag <<-FALSE)
  if (!flag) next
  getfollower.df <- twListToDF(Followerinfo)
  Followerstack <- rbind(Followerstack, getfollower.df)
  Followerstack <- unique(Followerstack)
  
  
  if(i%%400 == 0){
    print(i)
   Sys.sleep(800)
  }
  
  next
}
print("done")

#write file with all followers to CSV. Can be read back in to use for finding tweets
write.csv(Followerstack, file=paste("follower", '_stack.csv'), row.names=F)

#runs through the data frame of users and passes user names to twitter to find last
#200 tweets for each user
#Quickly reaches rate limiting with the API so another function that takes a while to run
#Reset for loop location to last input
#Will skip users who do not have any tweets

for (i in 31001:length(Followerstack$description)){
  #checks if close to rate limit and gives indicators for where in the list it is running
    if (i%%100 == 0){
        print(i)
        rate <- getCurRateLimitInfo()
        t <- as.numeric(rate[39,3])
          if (t<45){
            print(Sys.time())
            for (i in 1:25){
              rate2 <- getCurRateLimitInfo()
              z <- as.numeric(rate2[39,3])
              if (z == 180){
                print("go")
                break
                }else{
                Sys.sleep(30)
                next
              } 
            }
          }
      }
    #Grabs User Timeline of last 200 tweets and checks for errors
    #Removes extraneous details for each set of 200 tweets so it doesn't overburden the data frame
    tweets <- try(userTimeline(Followerstack[i,11], n=200, includeRts=TRUE, excludeReplies=FALSE), silent = TRUE)
    if(inherits(tweets, 'try-error')){
      next
    }else if (length(tweets) == 0){
      next
    }else{
      usertweets <- twListToDF(tweets)
      #takes out everything, but text of tweet, date created and number of retweets
      usertweets <- subset(usertweets, select=-c(favorited, truncated, replyToSN, replyToSID, screenName,
                           id, favoriteCount, replyToUID, statusSource, retweeted, latitude, longitude, isRetweet))
      userDF <- as.data.frame(Followerstack[i,1:length(Followerstack)])
      #once set of 200 tweets is gathered, append them to the user's profile information
      DF <- userDF
            for (x in 1:200){
              
                DF <- append(DF, usertweets[x,1:3])
                next
            }
      DF <- as.data.frame(DF)
      Totalstack <-rbind.data.frame(Totalstack, DF)
      
      next
    }
}

print("done")
#remove duplicates
Totalstack <- subset(Totalstack, !duplicated(Totalstack$screenName))
#write to file
write.csv(Totalstack, file=paste("total2", '_stack.csv'), row.names=F)






