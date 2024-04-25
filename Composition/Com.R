library(ggplot2)
phylum <- read.table("Phylum.xls",header = TRUE,sep = "\t")
phylum$Phylum <- factor(phylum$Phylum,levels = phylum$Phylum)
cbbPalette <- c("#A7226F","#F46C3F","#F7DC68","#2E9599")

p <- ggplot(data = phylum,aes(x = 1, y = Abun,fill = Phylum)) + 
    geom_bar(stat = "identity") +
    geom_text(aes(x = 1, y = 100 - Abun[1]/2,
                  label = paste("Proteobacteria (",round(Abun[1],2),"%)",sep = "")),
              color = "white",size = 5) +
    ylab(label = "Relative abundance (%) of bacterial phyla") + 
    xlab(label = "") + 
    scale_fill_manual(values = cbbPalette) +
    theme_bw()+ 
    theme(panel.grid=element_blank()) + 
    theme(panel.border = element_blank()) +
    theme(panel.background=element_rect(fill='transparent', color='black'),
          plot.margin = unit(c(3,5,2,1),"mm")) + 
    theme(axis.text.y=element_blank()) + 
    theme(axis.text.x=element_text(colour = "black",size = 10)) + 
    theme(axis.ticks.length = unit(0.4,"lines"), 
          axis.ticks = element_line(color='black'),
          axis.line = element_line(colour = "black"),
          axis.ticks.y = element_blank())+ 
    theme(axis.title.x = element_text(size = 12,face = "bold")) + 
    scale_y_continuous(limits = c(0,100.001),expand = c(0,0)) + 
    theme(legend.text = element_text(colour = "black",size = 10)) + 
    theme(legend.title = element_blank(),
          legend.position = "top") + 
    coord_flip()
pdf("Phylum.pdf",height = 1.5,width = 5)
p
dev.off()

genus <- read.table("Genus.xls",header = TRUE,sep = "\t")
genus$Genus[4] <- gsub("-.*","",genus$Genus[4])
genus$Genus <- factor(genus$Genus,levels = genus$Genus)

cbbPalette1 <- c("#B2182B","#56B4E9","#E69F00","#009E73","#F0E442","#0072B2",
                 "#D55E00","#CC79A7","#CC6666","#9999CC","#66CC99","#999999",
                 "#ADD1E5")

p <- ggplot(genus,aes(Genus,Abun)) + 
    geom_col(aes(fill = Genus),
             position = "dodge",width = 0.8) +
    geom_text(aes(y = Abun + max(Abun,na.rm = TRUE)*0.05,
                  label = paste(round(Abun,2),"%",sep = "")),
              position = position_dodge(width = 0.8),
              size = 2.7,color = "black",fontface = "bold") +
    scale_fill_manual(values = cbbPalette1) +
    labs(y="Relative abundance (%)") +
    scale_y_continuous(expand = expansion(mult = c(0,0.1))) + 
    theme_bw() +
    theme(panel.grid = element_blank(),
          axis.text = element_text(size=9,colour = "black"),
          axis.text.x = element_text(angle=60, hjust=1,face = "bold"),
          axis.title.y = element_text(size=12,colour = "black",face = "bold"),
          axis.title.x = element_blank(),
          legend.position = "none")

pdf("Genus.pdf",height = 3,width = 5)
p
dev.off()

