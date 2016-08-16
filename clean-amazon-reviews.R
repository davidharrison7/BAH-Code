#==============================================================================
# clean-amazon-reviews.py
# Purpose: Takes csv of Amazon reviews and merges reviews into single column
# exports csv for processing with Python
# Author: David Harrison
#==============================================================================
#separate columns
A <- newbalance[c(1)]
B <- newbalance[c(2)]
C <- newbalance[c(3)]
D <- newbalance[c(4)]
E <- newbalance[c(5)]
G <- newbalance[c(6)]
H <- newbalance[c(7)]
I <- newbalance[c(8)]
J <- newbalance[c(9)]
K <- newbalance[c(10)]
L <- newbalance[c(11)]
M <- newbalance[c(12)]

#rename columns
names(A) <- "Review"
names(B) <- "Review"
names(C) <- "Review"
names(D) <- "Review"
names(E) <- "Review"
names(G) <- "Review"
names(H) <- "Review"
names(I) <- "Review"
names(J) <- "Review"
names(K) <- "Review"
names(L) <- "Review"
names(M) <- "Review"

#combine columns into single column
newbalance_review <- rbind(A,B)
newbalance_review <- rbind(newbalance_review,C)
newbalance_review <- rbind(newbalance_review,D)
newbalance_review <- rbind(newbalance_review,E)
newbalance_review <- rbind(newbalance_review,G)
newbalance_review <- rbind(newbalance_review,H)
newbalance_review <- rbind(newbalance_review,I)
newbalance_review <- rbind(newbalance_review,J)
newbalance_review <- rbind(newbalance_review,K)
newbalance_review <- rbind(newbalance_review,L)
newbalance_review <- rbind(newbalance_review,M)

#insert NA's for blank spaces and remove incomplete cells
newbalance_review[newbalance_review==""] <- NA
newbalance_final <- newbalance_review[complete.cases(newbalance_review),]

#write to file
write.csv(newbalance_final, file=("NB_reviews.csv"), row.names=T)
