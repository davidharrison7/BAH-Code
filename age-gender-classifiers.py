#==============================================================================
# age-gender-classifiers.py
# Purpose: load sframes and trained model and run classifiers for text based age and gender
# Author: David Harrison
#==============================================================================

#load trained model
import gensim
BASE_DIR = "/Users/585770/Documents/blogs" # NOTE: Update BASE_DIR to your own directory path
model_download_path = "%s/blog_posts_300_c_40.word2vec" % BASE_DIR
model = gensim.models.Word2Vec.load(model_download_path)

#load sframe for blogs
import graphlab as gl
sframe_save_path = "%s/blogs.sframe" % BASE_DIR
sf = gl.load_sframe(sframe_save_path)
print sf.num_rows()

#load sframe for tweets
sframe_save_path = "%s/tweets.sframe" % BASE_DIR
newsf = gl.load_sframe(sframe_save_path)
print newsf.num_rows()


# Construct Bag-of-Words model for each and evaluate it
sf['1gram features'] = gl.text_analytics.count_ngrams(sf['posts'], 1)
sf['2gram features'] = gl.text_analytics.count_ngrams(sf['posts'], 2)

newsf['1gram features'] = gl.text_analytics.count_ngrams(newsf['posts'], 1)
newsf['2gram features'] = gl.text_analytics.count_ngrams(newsf['posts'], 2)


#now run classifiers with graph labs

#wasn't running with all blog posts so had to take a sample

sf = sf[:5000]
#train set is the validation set and can see accuracy
train_set = sf
#test set to actually run is the tweets
test_set = newsf

#for each classifier created, graph lab will test a number of classifiers to see
#which validates the best, can save as SFrame and export as CSV to match with input data
#first classifiers are for text based gender and probability associated
cls = gl.classifier.create(train_set, target='gender', features=['1gram features'])
gender_result = (cls.predict(test_set))
gender_result = gender_result.apply(lambda x: [x], dtype=list)
gender_result = gender_result.astype(list)
gender_result = gender_result.unpack(column_name_prefix='gender')

baseline_result = gender_result.append(prob_result)
print baseline_result

prob_result = cls.predict(test_set, output_type='probability')
prob_result = prob_result.apply(lambda x: [x], dtype=list)
prob_result = prob_result.astype(list)
prob_result = prob_result.unpack(column_name_prefix='probability')

baseline_result = prob_result.append(prob_result)
print baseline result

#now set up age ranges for classifiers to put into bins
valid_age = range(13,18) + range(23,28) + range(33,43)
sf_age_categories = sf.filter_by(valid_age, 'age')

def get_age_category(age):
    if 13 <= age <=17:
        return "10s"
    elif 23 <= age <= 27:
        return "20s"
    elif 33 <= age <= 42:
        return "30s"    
    return None
        
sf['age_category'] = sf['age'].apply(lambda age: get_age_category(age))
sf_age_categories = sf.dropna() # remove blogger without age category
print sf_age_categories.num_rows()

train_set2 = sf_age_categories

cls = gl.classifier.create(train_set2, target='age_category', features=['1gram features'])

age_category_result = cls.predict(test_set)
age_category_result = cls.predict_topk(test_set, output_type='probability', k=3)
age_category_result = age_category_result.apply(lambda x: [x], dtype=list)
age_category_result = age_category_result.astype(list)
age_category_result = age_category_result.unpack(column_name_prefix='probability')

print age_category_result


