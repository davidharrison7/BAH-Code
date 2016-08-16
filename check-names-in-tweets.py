#==============================================================================
# check-names-in-tweets.py
# Purpose: read in csv file of screen names from twitter user accounts
# splits names and checks first string to see if it matches name in database
# if a match it returns the name, if not returns NA
# Author: David Harrison
#==============================================================================
import USSSALoader
import csv
import re

class checkNames():
    
         #findnames = re.compile(r'([A-Z]\w*(?:\s[A-Z]\w*)?)')
     
    #loads name database names
    #splits names, takes only first string and removes quoting
    def is_name_in_text(self,filename):
         names = self._loadNames()
         names = names.split()
         #names = tuple(names)
         #print len(names)
         #print names[:40]
         #twitter_names = [line.rstrip('\n') for line in open(filename)]
         with open(filename) as f:
             twitter_names = [line.upper() for line in f]
             twitter_names = [y.replace('\n', '') for y in twitter_names]
             twitter_names = [i.split()[0] for i in twitter_names]
             twitter_names = [y.replace('"', '') for y in twitter_names]
   
             
             
             print names[:5]
             listA = twitter_names
             listB = names
             listC = []
             #checks to see if the twitter name is in the list of all names
             #returns the matched name or an NA
             for a in listA:
                 if any(a in item for item in listB):
                     listC.append(a)
                 else:
                     listC.append('NA')
            
             return listC
            
         
    def _loadNames(self):
         boy_names, girl_names = USSSALoader.getNameList()
         boy_names = list(boy_names)
         boy_names = [x[0] for x in boy_names]
         girl_names = list(girl_names)
         girl_names = [x[0] for x in girl_names]
         list1 = boy_names + girl_names
         names = " ".join(list1)
         return names
        

if __name__ == "__main__":
    cn = checkNames()
    filename = 'birthname _stack.csv'
    allnames = cn.is_name_in_text(filename)
    print allnames[:100]
    #import numpy as np
    #myarray = np.asarray(allnames)
    #out = csv.writer(open("checkednames.csv","w"), delimiter=',',quoting=csv.QUOTE_ALL)
    #out.writerow(myarray)
    
    with open('checkednames.csv', 'w') as f:
        writer = csv.writer(f, delimiter=',', quoting=csv.QUOTE_ALL)
        for val in allnames:
            writer.writerow([val])
