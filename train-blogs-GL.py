#==============================================================================
# train-text-GL.py
# Purpose: Uses blog posts to train word2vec model from set of blogs
# some sections called as functions, some are command line driven
# Author: znation, adapted for project
#==============================================================================
#creates TrainSentences class that takes series of text files as input from directory
#returns iterator that is used to split sentences into list of words

import os
import gensim
import re
import nltk
from nltk.corpus import stopwords
from bs4 import BeautifulSoup

BASE_DIR = "/Users/585770/Documents/blogs" # NOTE: Update BASE_DIR to your own directory path
class TrainSentences(object):
    #Iterator class that returns Sentences from texts files in a input directory

    RE_WIHTE_SPACES = re.compile("\s+")
    STOP_WORDS = set(stopwords.words("english"))
    def __init__(self, dirname):
      #Initialize a TrainSentences object with a input directory that contains text files for training

        self.dirname = dirname

    def __iter__(self):
        """
        Sentences iterator that return sentences parsed from files in the input directory.
        Each sentences is returned as list of words
        """
        #First iterate  on all files in the input directory
        for fname in os.listdir(self.dirname):
            # read line from file (Without reading the entire file)
            for line in file(os.path.join(self.dirname, fname), "rb"):
                # split the read line into sentences using NLTK
                for s in txt2sentences(line, is_html=True):
                    # split the sentence into words using regex
                    w =txt2words(s, lower=True, is_html=False, remove_stop_words=False,
                                                 remove_none_english_chars=True)
                    #skip short sentneces with less than 3 words
                    if len(w) < 3:
                        continue
                    yield w

def txt2sentences(txt, is_html=False, remove_none_english_chars=True):
    """
    Split the English text into sentences using NLTK
    :param txt: input text.
    :param is_html: If True thenremove HTML tags using BeautifulSoup
    :param remove_none_english_chars: if True then remove non-english chars from text
    :return: string in which each line consists of single sentence from the original input text.
    :rtype: str
    """
    if is_html:
        txt = BeautifulSoup(txt).get_text()
    tokenizer = nltk.data.load('tokenizers/punkt/english.pickle')

    # split text into sentences using nltk packages
    for s in tokenizer.tokenize(txt):
        if remove_none_english_chars:
            #remove none English chars
            s = re.sub("[^a-zA-Z]", " ", s)
        yield s
    
def txt2words(txt, lower=True, is_html=False, remove_none_english_chars=True, remove_stop_words=True):
    """
    Split text into words list
    :param txt: the input text
    :param lower: if to make the  text to lowercase or not.
    :param is_html: If True then  remove HTML tags using BeautifulSoup
    :param remove_none_english_chars: if True then remove non-english chars from text
    :param remove_stop_words: if True then remove stop words from text
    :return: words list create from the input text according to the input parameters.
    :rtype: list
    """
    if is_html:
        txt = BeautifulSoup(txt).get_text()
    if lower:
        txt = txt.lower()
    if remove_none_english_chars:
        txt = re.sub("[^a-zA-Z]", " ", txt)

    words = TrainSentences.RE_WIHTE_SPACES.split(txt.strip().lower())
    if remove_stop_words:
        #remove stop words from text
        words = [w for w in words if w not in TrainSentences.STOP_WORDS]
    return words
    
#finally create sentences object which uses train sentences with a word2vec model from genism
#will take a long time to fully process so might want to leave overnight
#save model to base dircetory
sentences = TrainSentences("%s/txt" % BASE_DIR)
model = gensim.models.Word2Vec(sentences, size=300, workers=8, min_count=40)
model.save("%s/blog_posts_300_c_40.word2vec" % BASE_DIR)


