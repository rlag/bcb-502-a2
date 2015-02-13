## Ross Lagoy
## A2, BCB 502
## 02/12/15

# Install needed packages 'Tools>Install Packages'
library(pvclust)
library(cluster)
library(fpc)
library(gdata)

# Load mydata by a function OR *RECCOMMENDED* by Tools>Import Dataset>From Text File  -- locate formatted.csv
mydata <- read.csv("~/Documents/Spring/biovis/assignments/A2/A2/A2/formatted.csv", header=FALSE)

# Remove last column of mydata (carried over from processing)
mydata[102] <- NULL
View(mydata) # View mydata in R

# Tell R mydata is a euclidean distance matrix (from processing)
d <- dist(mydata, method = "euclidean")

# Make leaf labels
animalname <- c("aardvark","antelope","bass","bear","boar","buffalo",
                "calf","carp","catfish","cavy","cheetah","chicken",
                "chub","clam","crab","crayfish","crow","deer",                "dogfish",
                "dolphin","dove","duck","elephant","flamingo",
                "flea","frog","frog","fruitbat","giraffe","girl",
                "gnat","goat","gorilla","gull","haddock","hamster",
                "hare","hawk","herring","honeybee","housefly",
                "kiwi","ladybird","lark","leopard","lion",
                "lobster","lynx","mink","mole","mongoose","moth",
                "newt","octopus","opossum","oryx","ostrich",
                "parakeet","penguin","pheasant","pike","piranha",
                "pitviper","platypus","polecat","pony","porpoise",
                "puma","pussycat","raccoon","reindeer","rhea",
                "scorpion","seahorse","seal","sealion","seasnake",
                "seawasp","skimmer","skua","slowworm","slug",
                "sole","sparrow","squirrel","starfish","stingray",
                "swan","termite","toad","tortoise","tuatara",
                "tuna","vampire","vole","vulture","wallaby",
                "wasp","wolf","worm","wren")

# Fit mydata to a single-linkage type clustering
fit <- hclust(d, method="single")

# Plot the resulting tree
plot(fit, labels = animalname, cex = 1, xlab = "", sub = "",
     ylab = "Level", main = "Tree of Life")

# References
# http://www.statmethods.net/advstats/cluster.html
# http://home.deib.polimi.it/matteucc/Clustering/tutorial_html/hierarchical.html
