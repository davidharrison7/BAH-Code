#==============================================================================
# nb-tweets.R
# Purpose: Get New Balance Tweets
# Function can be used with other companies and search terms as well
# Author: David Harrison
#==============================================================================
#run function once to get most recent tweets and then run loop below to work backwards by MaxID
AllNBTweets <- searchTwitter("newbalance OR #newbalance OR NBfootball OR #nbnumbers", n = 2000)

#set max based on last element of list above
Max <- 743389039215128576

#set loop length and parameters as needed
#sinceID and maxID give the window of time to add to, set lanaguage to "en" to avoid non-ASCII characters

for (i in 1:10){
  
  AllNBTweets <- searchTwitter("newbalance OR #newbalance OR NBfootball OR #nbnumbers",
                               lang = "en", n = 2000, sinceID = 747421063127179264, maxID = Max)
  
  #make data frame and organize by date, write csv file if one doesn't exist
  AllNBdf <- twListToDF(AllNBTweets)
  AllNBdf <- AllNBdf[, order(names(AllNBdf))]
  AllNBdf$created <- strftime(AllNBdf$created)
  if (file.exists(paste("allnewbalance", '_stack.csv'))==FALSE) write.csv(AllNBdf, file=paste("allnewbalance", '_stack.csv'), row.names=F)
  
  #add to file, remove duplicates, and re-write
  NBstack <- read.csv(file=paste("allnewbalance", '_stack.csv'))
  NBstack <- rbind(NBstack, AllNBdf)
  NBstack <- subset(NBstack, !duplicated(NBstack$text))
  NBstack <- NBstack[order(as.Date(NBstack$created), decreasing = TRUE),]

  write.csv(NBstack, file=paste("allnewbalance", '_stack.csv'), row.names=F)
  
  #reset max ID to last position in data frame
  Max <- AllNBdf[2000,4]
  
  print(Max)
  #add sleep cycle so API doesn't kick program out
  Sys.sleep(30)
  
  next
}
