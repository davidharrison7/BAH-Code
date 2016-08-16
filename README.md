# BAH-Code

   twitter-setup.R
   
   1) Sets up the authentication for the twitter API in R
   
   
   
   nb-tweets.R
   
   1) Pulls tweets with given parameters of topic and ID location
   
   
   
   follower-accounts.R
   
   1) Runs through given acount and pulls ID numbers of all followers
   2) Passes ID numbers and pulls full account information for each user
   3) Passes screen names to gather last 200 tweets for each user and appends them to account info
   
   
   
   text-recombination-R2Python.R
   
   1) Takes all tweets for each account and merges them into one xml file per user of all their tweets
   
   
   
   prepare-tweets-text-age-gender.py
   
   1) parses all tweets from xml files to text files to be run through machine learning model
   
   
   
   prepare-blogs-text-age-gender.py
   
   1) parses prelabeled blog posts that can will be used to train machine learning model to predict age and gender from text
   
   
   
   train-text-age-gender.py
   
   1) passes the prelabeled blog posts to graph lab model to train the data set and save a trained model
   
   
   
   age-gender-text-classifiers.py
   
   1) loads trained models and runs classifiers for gender and age based on text content for each user account
   
   
   
   USSSAloader.py 
   
   1) loads US names database of 90,000 names to use for training machine learning name prediction model
   
   
   
   check-names-in-tweets.py
   
   1) parses names on user accounts by strings and searches names database to see if they are actual names
   2) if names do exist in the database it returns the name if not returns NA as placeholder
   
   
   
   name-gender-predictor.py
   
   1) passes names from check-names to trained model for gender prediction and skips NA's
   2) returns male and female and can return probability for each as well
   
   
   
   clean-amazon-reviews.R
   
   1) cleans amazon reviews and reorganizes into single column to be pased to python for product sentiment analysis
   
   
   
   gl-product-sentiment.py
   
   1) uses graph-labs pretrained product sentiment model to give sentiment results for reviews of given brand 
   2) also can check individual words for the average sentiment of all reviews that contain them
   
   
   
   
   
  
