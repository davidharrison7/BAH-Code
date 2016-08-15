#==============================================================================
# prepare-tweets-GL.py
# Purpose: Funtions similarly to prepare blogs, but does not create as many features
# Parses and joins each users collective posts into separate files and saves the SFrame
# to be reloaded
# Author: David Harrison
#==============================================================================

#Set BASE_DIR to whichever has the xml tweet files
import os
import graphlab as gl
from bs4 import  BeautifulSoup

BASE_DIR = "/Users/585770/Documents/tweetss" # NOTE: Update BASE_DIR to your own directory path
class BlogData2SFrameParser(object):
    #Some constants
    ID = "id"
    POSTS = "posts"

    
    def __init__(self, xml_files_dir, sframe_outpath):
        #Parse all the blog posts XML files in the xml_files_dir and insert them into an SFrame object,
        #which is later saved to `sframe_outpath`
        self._bloggers_data = []


        for p in os.listdir(xml_files_dir):
            if p.endswith(".xml"):
                #We parse each XML file and convert it to a dict
                self._bloggers_data.append(self.parse_blog_xml_to_dict("%s%s%s" % (xml_files_dir, os.path.sep, p)))
        print "Successfully parsed %s blogs" % len(self._bloggers_data)

        # self._bloggers_data is a list to load to a SFrame object. Dict objects
        # are loaded into a single column named X1. To create separate column for each dict key we use the unpack function.        
        self._sf = gl.SFrame(self._bloggers_data).unpack('X1')

        #Use the rename function in order to remove the X1. prefix from the column names and save the SFrame for later use
        self._sf.rename({c:c.replace("X1.", "") for c in self._sf.column_names()} )        
        self._sf.save(sframe_outpath)


    def parse_blog_xml_to_dict(self, path):
        """
        Parse the blog post in the input XML file and return dict with the  blogger's personal information and posts
        :param path: the path of the xml file
        :return: dict with the blogger's personal details and posts
        :rtype: dict
        """
        blogger_dict = {}
        #Extract the number from the file name
        blog_id = path.split(os.path.sep)[-1].split(".xml")[0].split(".")
        blogger_dict[self.ID] = blog_id
        blogger_dict[self.POSTS] = []
        s = file(path,"r").read().replace("&nbsp;", " ")
        # First, strip tags at the beginning and end of the document
        s = s.replace("@", "").replace("@", "").strip()
        # Now, split the document into individual tweets posts
        post = BeautifulSoup(s).get_text()
        blogger_dict[self.POSTS].append(post)

        return blogger_dict
    @property
    def sframe(self):
        return self._sf

sframe_save_path = "%s/tweets.sframe" % BASE_DIR
b = BlogData2SFrameParser("%s/twitter" % BASE_DIR, sframe_save_path)
sf = b.sframe

os.mkdir("%s/tweettxt" % BASE_DIR)
sf.apply(lambda r: file("%s/tweettxt/%s.txt" % (BASE_DIR, r["id"]),"w").write("\n".join(r['posts']))).__materialize__()
