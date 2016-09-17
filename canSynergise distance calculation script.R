setwd("~/Desktop/Similar:dissimilar target overlaps/Calculating distances")
library(igraph)
#Load in interactome - from sprot.interactome20160114
data<-read.csv("Proteome.csv")
data.network<-graph.data.frame(data, directed=F)

# Generating global distance matrix for entire human proteome- only needs to be done once 
a<-distances(data.network, v = V(data.network), to = V(data.network), mode = c("all", "out","in"), weights = NULL, algorithm = c("automatic", "unweighted","dijkstra", "bellman-ford", "johnson"))
write.csv(a, "Distance_matrix.csv")
a<-read.csv("Distance_matrix.csv")

# Load in drug1 target list
drug1 <- scan("Gefitinib.txt", what = list(protein = ""))
# Load in drug2 target list
drug2 <- scan("PD98059.txt", what = list(protein = ""))
drug2<-unlist(drug2)
drug1<-unlist(drug1)
combos<-expand.grid(drug1, drug2)
combos$distance<-0

#calculating the distance between targets bsed on lookup table
for (i in 1:nrow(combos)){
  target1<-combos[i,1]
  target2<-combos[i,2]
  distance <- a1[rownames(a1) == target1, colnames(a1) == target2]
  combos[i,3]<-distance
}

#Saving the output
write.csv(combos, "Gefitinib_PD98059.csv")
