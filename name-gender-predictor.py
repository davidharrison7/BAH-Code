#==============================================================================
# name-gender-predictor.py
# Purpose: reads in stack of checked names, skips those with NA and predicts 
# gender for the rest with about 80% accuracy using Naive Bayes trained model
# Author: David Harrison
#==============================================================================
from nltk import NaiveBayesClassifier,classify
import USSSALoader
import random
import csv

class genderPredictor():
    
    def getFeatures(self):
        maleNames,femaleNames=self._loadNames()
        
        featureset = list()
        #checks probability distibution of male and female using Naive Bayes trained model
        for nameTuple in maleNames:
            features = self._nameFeatures(nameTuple[0])
            male_prob, female_prob = self._getProbDistr(nameTuple)
            features['male_prob'] = male_prob
            features['female_prob'] = female_prob
            featureset.append((features,'M'))
        
        for nameTuple in femaleNames:
            features = self._nameFeatures(nameTuple[0])
            male_prob, female_prob = self._getProbDistr(nameTuple)
            features['male_prob'] = male_prob
            features['female_prob'] = female_prob
            featureset.append((features,'F'))
    
        return featureset
        
    #creates train and test set based on USSSA name data for validation
    def trainAndTest(self,trainingPercent=0.80):
        featureset = self.getFeatures()
        random.shuffle(featureset)
        
        name_count = len(featureset)
        
        cut_point=int(name_count*trainingPercent)
        
        train_set = featureset[:cut_point]
        test_set  = featureset[cut_point:]
        
        self.train(train_set)
        
        return self.test(test_set)
    
    #returns probability for a given name 
    def classify(self,name):
        feats=self._nameFeatures(name)
        return self.classifier.classify(feats)
        
    def train(self,train_set):
        self.classifier = NaiveBayesClassifier.train(train_set)
        return self.classifier
        
    def test(self,test_set):
       #print test_set
       return classify.accuracy(self.classifier,test_set)
       
    def accurate(self, name):
    
        
       features = self._nameFeatures(name)
            #features['male_prob'] = 0
            #features['female_prob'] = 0
    
       return self.classifier.prob_classify(features)
    
    def _getProbDistr(self,nameTuple):
            male_prob = (nameTuple[1] * 1.0) / (nameTuple[1] + nameTuple[2])
            if male_prob == 1.0:
                male_prob = 0.99
            elif male_prob == 0.0:
                male_prob = 0.01
            else:
                pass
            female_prob = 1.0 - male_prob
            return (male_prob, female_prob)
        
    def getMostInformativeFeatures(self,n=5):
        return self.classifier.most_informative_features(n)
        
    def _loadNames(self):
        return USSSALoader.getNameList()
        
    def _nameFeatures(self,name):
        #name=name.upper()
        return {
            'last_letter': name[-1],
            'last_two' : name[-2:],
            'last_three': name[-3:],
            'last_is_vowel' : (name[-1] in 'AEIOUY')
        }

if __name__ == "__main__":
    gp = genderPredictor()
    accuracy=gp.trainAndTest()
    print 'Accuracy: %f'%accuracy
    print 'Most Informative Features'
    featureset = gp.getFeatures()
    feats=gp.getMostInformativeFeatures()
    #uncomment if checking individual names
    #for feat in feats:
        #print '\t%s = %s'%feat
    #uncomment for allowing raw input instead of set of names
    #name = raw_input('Enter name to classify: ')
    
    #with open('checkednames.csv', 'rb') as f:
     #   n = csv.reader(f)
      #  names = list(n)
    #passes in csv of checked names and runs probability for each name
    with open("checkednames.csv") as f:
        gend = []
        reader = csv.reader(f)
        next(reader, None)
        for row in csv.reader(f):
            names = row[0]
            
        #names = str(names)#names = list(names)
            names = names.strip('"')
            
            print names
            #names = filter(None, names)
            #print names
            if names == 'NA':
                gend.append('NA')
                next
            else: 
                name = gp.classify(names)
                gend.append(name)
                print name
                next

    #file to write gender for each to csv that will match with each screenname
    with open('gend_names.csv', 'w') as f:
        writer = csv.writer(f, delimiter=',', quoting=csv.QUOTE_ALL)
        for val in gend:
            writer.writerow([val])
        #print gend[:5]
    
    #uncomment these lines if you want to see the probability for a given input name
    #print '\n%s is classified as %s'%(name, gp.classify(name))
    #pdist = gp.accurate(name)
    #print gp.accurate(name)
    #print pdist.prob('M')
    #print pdist.prob('F')
