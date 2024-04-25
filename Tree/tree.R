library(ggtree)
library(tidyverse)
library(picante)
library(ape)
library(ggnewscale)
library(ggtreeExtra)

tree <- read.tree("phylogeny.tre")
bac <- read.table("taxa_table.xls",header = TRUE,sep = "\t",row.names = 1)
bac <- bac[bac$taxonomy != "Unculture",]
if (grepl("; ",bac$taxonomy[1])) {
    taxonomy <- bac %>% 
        separate(taxonomy,c("Domain","Phylum","Class","Order","Family","Genus","Species"),"; ")
}else{
    taxonomy <- bac %>% 
        separate(taxonomy,c("Domain","Phylum","Class","Order","Family","Genus","Species"),";")
    
}
taxonomy$Phylum <- gsub("p__","",taxonomy$Phylum)
taxonomy$Class <- gsub("c__","",taxonomy$Class)
taxonomy$Order <- gsub("o__","",taxonomy$Order)
taxonomy$Family <- gsub("f__","",taxonomy$Family)
taxonomy$Genus <- gsub("g__","",taxonomy$Genus)
taxonomy$Species <- gsub("s__","",taxonomy$Species)
bac <- bac[,-ncol(bac)]
bac <- as.data.frame(cbind(bac,taxonomy[,(ncol(taxonomy)-6):ncol(taxonomy)]))
bac <- bac[bac$Domain != "Unassignable",]
bac <- bac[bac$Domain != "Unclassified",]
bac <- subset(bac,select = -Domain)
bac <- bac[complete.cases(bac$Phylum),]
bac <- bac[rowSums(bac[,1:(ncol(bac)-6)]) > 1,]
bac1 <- t(bac[,1:(ncol(bac)-6)])
bac2 <- bac[,1:(ncol(bac)-6)]
bac2 <- t(t(bac2)/colSums(bac2)*100)
bac3 <- as.data.frame(cbind(bac2,bac[,(ncol(bac)-5):ncol(bac)]))
for (i in (ncol(bac3)-5):ncol(bac3)) {
    bac3[grepl("norank",bac3[,i]),i] <- "Unclassified"
    bac3[grepl("uncultured",bac3[,i]),i] <- "Unclassified"
    bac3[grepl("unclassified",bac3[,i]),i] <- "Unclassified"
    bac3[grepl("unidentified",bac3[,i]),i] <- "Unclassified"
    bac3[grepl("metagenome",bac3[,i]),i] <- "Unclassified"
    bac3[is.na(bac3[,i]),i] <- "Unclassified"
    bac3[,i] <- gsub("\\[","",bac3[,i])
    bac3[,i] <- gsub("\\]","",bac3[,i])
}
sum <- rowSums(bac3[,1:(ncol(bac3)-6)])
sum <- data.frame(OTU = rownames(bac3),Sum = sum)
sum <- sum[order(sum$Sum,decreasing = TRUE),]
sum <- sum[1:500,]
bac4 <- bac3[rownames(bac3) %in% sum$OTU,]
bac5 <- bac1[,colnames(bac1) %in% sum$OTU]

phylum <- c("Proteobacteria","Firmicutes","Bacteroidota")
genus <- c("Undibacterium","Achromobacter","Acinetobacter","Methylobacterium",
           "Aeromonas","Acidovorax","Pseudomonas","Staphylococcus","Serratia",
           "Sphingomonas","Comamonas")
bac4$Phylum <- ifelse(bac4$Phylum %in% phylum,bac4$Phylum,"Others")
groupInfo <- split(rownames(bac4),bac4$Phylum)
tree$tip.label <- gsub("(^')|('$)","",tree$tip.label)
tree <- prune.sample(bac5,tree)
tree <- groupOTU(tree, groupInfo)

cbbPalette <- c("#F7DC68","#F46C3F","#2E9599","#A7226F")

cbbPalette1 <- c("#B2182B","#56B4E9","#E69F00","#009E73","#F0E442","#0072B2",
                 "#D55E00","#CC79A7","#CC6666","#9999CC","#66CC99","#999999",
                 "#ADD1E5")

p <- ggtree(tree,layout = "circular",aes(color = group), branch.length="none") + 
    geom_tippoint(size = 1,aes(color = group)) + 
    scale_color_manual(values = cbbPalette,name = "Phylum") + 
    theme(legend.title = element_text(size = 16,face = "bold",colour = "black"),
          legend.text = element_text(size = 12,face = "bold",colour = "black"),
          legend.key.height = unit(0.6,"cm")) + 
    guides(color = guide_legend(override.aes = list(size = 6)))

heatmapData <- data.frame(ID = rownames(bac4),Genus = bac4$Genus)
heatmapData$Genus <- ifelse(heatmapData$Genus %in% genus,heatmapData$Genus,"Others")
heatmapData$Genus <- factor(heatmapData$Genus,levels = c(genus,"Others"))
p2 <- p + 
    new_scale_fill() + 
    geom_fruit(data = heatmapData,geom = geom_tile,
               mapping = aes(y = ID,x = 1,fill = Genus),
               pwidth = 0.1,offset = -0.05) + 
    scale_fill_manual(values=cbbPalette1,name = "Genus")

tax.stat <- c()
for (i in 1:nrow(bac4)) {
    dd <- bac4[,bac4[i,] > 0]
    tax.stat <- c(tax.stat,ncol(dd))
}

fc <- data.frame(ID = rownames(bac4),Num = tax.stat)
aa <- p2$data
aa <- aa[,c(4,8)]
colnames(aa)[1] <- "ID"
rownames(fc) <- fc$ID 
fc <- fc[aa$ID,]
p3 <- p2 + 
    new_scale_fill() +
    geom_fruit(data=fc,geom=geom_bar,
        mapping=aes(y=ID, x=Num, fill=Num),  
        pwidth=0.2,stat="identity",offset = 0.05) + 
    scale_fill_gradient(high="#D32F2F",low = "#FFF7F3",name = "Detected")

pdf("Phylogenetic_tree.pdf",width = 8,height = 9)
p3
dev.off()

