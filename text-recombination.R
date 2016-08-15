#==============================================================================
# text-recombination.R
# Purpose: Merge all the text for each user into one large post and export to 
# folder of xml files for processing with text based machine learning in Python
# some sections called as functions, some are command line driven
# Author: David Harrison
#==============================================================================

#rename stack of followers and their tweets to "realstack2" for this
#probably much easier way to merge the text columns, but did this in a hacky way
#recombines each one into merged block of tweets for each user
realstack2$fulltext <- paste(realstack2$text,realstack2$ realstack2$text.1 ,realstack2$text.2,realstack2$text.3,realstack2$text.4,realstack2$text.5,realstack2$text.6,realstack2$text.7,realstack2$
                               text.8,realstack2$text.9,realstack2$text.10,realstack2$text.11,realstack2$text.12,realstack2$text.13,realstack2$text.14,realstack2$text.15,realstack2$
                               text.16,realstack2$text.17,realstack2$text.18,realstack2$text.19,realstack2$text.20,realstack2$text.21,realstack2$text.22,realstack2$
                               text.23,realstack2$text.24,realstack2$text.25,realstack2$text.26,realstack2$text.27,realstack2$text.28,realstack2$text.29,realstack2$
                               text.30,realstack2$text.31,realstack2$text.32,realstack2$text.33,realstack2$text.34,realstack2$text.35,realstack2$text.36,realstack2$
                               text.37,realstack2$text.38,realstack2$text.39,realstack2$text.40,realstack2$text.41,realstack2$text.42,realstack2$text.43,realstack2$
                               text.44,realstack2$text.45,realstack2$text.46,realstack2$text.47,realstack2$text.48,realstack2$text.49,realstack2$text.50,realstack2$
                               text.51,realstack2$text.52,realstack2$text.53,realstack2$text.54,realstack2$text.55,realstack2$text.56,realstack2$text.57,realstack2$
                               text.58,realstack2$text.59,realstack2$text.60,realstack2$text.61,realstack2$text.62,realstack2$text.73,realstack2$text.64,realstack2$
                               text.65,realstack2$text.66,realstack2$text.67,realstack2$text.68,realstack2$text.69,realstack2$text.70,realstack2$text.71,realstack2$
                               text.72,realstack2$text.73,realstack2$text.74,realstack2$text.75,realstack2$text.76,realstack2$text.77,realstack2$text.78,realstack2$
                               text.79,realstack2$text.80,realstack2$text.81,realstack2$text.82,realstack2$text.83,realstack2$text.84,realstack2$text.85,realstack2$
                               text.86,realstack2$text.87,realstack2$text.88,realstack2$text.89,realstack2$text.90,realstack2$text.91,realstack2$text.92,realstack2$
                               text.93,realstack2$text.94,realstack2$text.95,realstack2$text.96,realstack2$text.97,realstack2$text.98,realstack2$text.99,realstack2$
                               text.100,realstack2$text.101,realstack2$text.102,realstack2$text.103,realstack2$text.104,realstack2$text.105,realstack2$text.106,realstack2$
                               text.107,realstack2$text.108,realstack2$text.109,realstack2$text.110,realstack2$text.111,realstack2$text.112,realstack2$text.113,realstack2$
                               text.114,realstack2$text.115,realstack2$text.116,realstack2$text.117,realstack2$text.118,realstack2$text.119,realstack2$text.120,realstack2$
                               text.121,realstack2$text.122,realstack2$text.123,realstack2$text.124,realstack2$text.125,realstack2$text.126,realstack2$text.127,realstack2$
                               text.128,realstack2$text.129,realstack2$text.130,realstack2$text.131,realstack2$text.132,realstack2$text.133,realstack2$text.134,realstack2$
                               text.135,realstack2$text.136,realstack2$text.137,realstack2$text.138,realstack2$text.139,realstack2$text.140,realstack2$text.141,realstack2$
                               text.142,realstack2$text.143,realstack2$text.144,realstack2$text.145,realstack2$text.146,realstack2$text.147,realstack2$text.148,realstack2$
                               text.149,realstack2$text.150,realstack2$text.151,realstack2$text.152,realstack2$text.153,realstack2$text.154,realstack2$text.155,realstack2$
                               text.156,realstack2$text.157,realstack2$text.158,realstack2$text.159,realstack2$text.160,realstack2$text.161,realstack2$text.162,realstack2$
                               text.163,realstack2$text.164,realstack2$text.165,realstack2$text.166,realstack2$text.167,realstack2$text.168,realstack2$text.169,realstack2$
                               text.170,realstack2$text.171,realstack2$text.172,realstack2$text.173,realstack2$text.174,realstack2$text.175,realstack2$text.176,realstack2$
                               text.177,realstack2$text.178,realstack2$text.179,realstack2$text.180,realstack2$text.181,realstack2$text.182,realstack2$text.183,realstack2$
                               text.184,realstack2$text.185,realstack2$text.186,realstack2$text.187,realstack2$text.188,realstack2$text.189,realstack2$text.190,realstack2$
                               text.191,realstack2$text.192,realstack2$text.193,realstack2$text.194,realstack2$text.195,realstack2$text.196,realstack2$text.197,realstack2$text.197,
                               realstack2$text.198, realstack2$text.199, sep = " ")
                               
#Export to folder as xml files to be read into Python for text gender and age analysis
#Set working directory to new folder for all files
  
for (i in 1:34646){
  write.table(textstack[i,1], file=paste(i, ".txt", sep=""))
}
