### Pipeline for standard analyses of OTU statistics of bacterial communities
### Based on R v4.0.2
setwd("../")
library(reshape2)
library(ggplot2)
library(tidyverse)
library(ape)
library(picante)
library(dplyr)
library(ggtree)
library(iNEXT)

### Loading Parameters  & Processing
source("Loading.R")

result <- Loading_Color()
cbbPalette <- result[[1]]
cbbPalette1 <- result[[2]]
bac <- Loading_Table("Input/taxa_table.xls")
group <- Loading_Group("Input/group1.txt")
tree <- Loading_Tree("Input/phylogeny.tre")

result <- Data_Process(bac,group,tree)
bac1 <- result[[1]]
bac2 <- result[[2]]
bac3 <- result[[3]]
tree <- result[[4]]
Group_numb <- result[[5]]
Sample_numb <- result[[6]]
wid <- result[[7]]

## OTU statistics
dir.create("Results")

### Stastics of taxonomy annotation
dir.create("Results/")
source("tax.stat.R")
result <- tax.stat(bac[,c(group$variable,"taxonomy")],bac3,group)    
write.table(result[[1]],
            "Results/ax.stat.txt",
            row.names = FALSE,sep = "\t")
pdf("Results/Tax.anno.per.pdf",width = 4,height = 4)
result[[2]]
dev.off()
write.table(result[[3]],
            "Results/Tax.stat_group.txt",
            row.names = FALSE,sep = "\t")


source("rare.spec.R")
result <- rare.spec(bac1,group)
pdf("Results/rarefaction1.pdf",height = 3,width = 5)
p1
dev.off()
pdf("Results/speccum1.pdf",height = 3,width = 5)
p2
dev.off()

print("01.OTU.tax.R all Success")

