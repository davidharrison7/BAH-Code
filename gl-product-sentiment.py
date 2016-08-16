#==============================================================================
# gl-prodict-sentiment.py
# Purpose: read in csv of reviews and use pretrained Graph Lab model to run product sentiment
# returns a summary of all words input, can also return most negative or positive as well as 
# some sections called as functions, some are command line driven
# Author: David Harrison
#==============================================================================
#pretrained model by Graph Lab that was trained on 20% of a 140 million amazon review set with
#with star ratings as either a binary positive or negative. Uses a bag of words model with a 
#logistic regression to create the classifier
#then transforms the text of the input csv of reviews using TF-IDF (text frequency, inverse document frequency)
#then tokenizes with NLTK's punkt sentence parser and runs the pretrained model

#Nike
import os
os.environ["GRAPHLAB_DISABLE_LAMBDA_SHM"] = "1"
os.environ["GRAPHLAB_FORCE_IPC_TO_TCP_FALLBACK"] = "1"
import graphlab as gl
from graphlab import SFrame

data="/Users/585770/Documents/nikereviews.csv"
sf = gl.SFrame.read_csv(data,header=True,quote_char='"', column_type_hints = {'z':str } )
#create model using column header as the features target
m = gl.product_sentiment.create(sf, features=['z'], splitby='review')
#general summary of the model and overall sentiment levels
m.sentiment_summary
#returns sentiment levels, standard deviation, and count
m.sentiment_summary (['annoying', 'neon', 'relaxed', 'wide'], k=5298).print_rows(num_rows=40)

 

#Adidas
import os
os.environ["GRAPHLAB_DISABLE_LAMBDA_SHM"] = "1"
os.environ["GRAPHLAB_FORCE_IPC_TO_TCP_FALLBACK"] = "1"
import graphlab as gl
from graphlab import SFrame

data="/Users/585770/Documents/adidas_reviews.csv"
sf = gl.SFrame.read_csv(data,header=True,quote_char='"', column_type_hints = {'adidas_final':str } )

m = gl.product_sentiment.create(sf, features=['adidas_final'], splitby='review')

m.sentiment_summary (['shoe','relaxed', 'chic'], k=5298).print_rows(num_rows=40)
                     

#New Balance
import os
os.environ["GRAPHLAB_DISABLE_LAMBDA_SHM"] = "1"
os.environ["GRAPHLAB_FORCE_IPC_TO_TCP_FALLBACK"] = "1"
import graphlab as gl
from graphlab import SFrame

data="/Users/585770/Documents/NB_reviews.csv"
sf = gl.SFrame.read_csv(data,header=True,quote_char='"', column_type_hints = {'newbalance_final':str } )

m = gl.product_sentiment.create(sf, features=['newbalance_final'], splitby='review')

m.sentiment_summary (['loose', 'snug'], k=5298).print_rows(num_rows=40)

#Sneaker Forum
import os
os.environ["GRAPHLAB_DISABLE_LAMBDA_SHM"] = "1"
os.environ["GRAPHLAB_FORCE_IPC_TO_TCP_FALLBACK"] = "1"
import graphlab as gl
from graphlab import SFrame

data="/Users/585770/Documents/sneaker_forum_reviews.csv"
sf = gl.SFrame.read_csv(data,header=True,quote_char='"', column_type_hints = {'posts':str } )

m = gl.product_sentiment.create(sf, features=['posts'], splitby='review')

m.sentiment_summary(['price', 'comfortable', 'durability', 'quality', 'performance', 'fit', 'size', 'shoe', 'large', 'small',
                     'color', 'tight', 'New Balance', 'design', 'support', 'bright', 'pretty' 'red', 'blue', 'yellow','white','black',
                     'pink', 'purple', 'gold', 'silver', 'green', 'style', 'running', 'light', 'heavy', 'feel'], k=5298).print_rows(num_rows=40)
                     
