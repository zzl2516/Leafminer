tax.stat <- function(bac,bac3,group){
    bac <- bac[rownames(bac3),]
    tax.stat <- c()
    for (i in 1:(ncol(bac)-1)) {
        dd1 <- c()
        for (j in 1:6) {
            dd <- ifelse(bac3[,i] > 0,bac3[,j + Sample_numb],NA)
            dd <- gsub("Unclassified",NA,dd)
            dd <- dd[complete.cases(dd)]
            dd1 <- c(dd1,length(unique(dd)))
        }
        tax.stat <- cbind(tax.stat,dd1)
    }
    tax.stat <- as.data.frame(tax.stat)
    rownames(tax.stat) <- c("Phylum","Class","Order","Family","Genus","Species")
    colnames(tax.stat) <- colnames(bac)[1:(ncol(bac)-1)]
    dd1 <- c()
    for (j in 1:6) {
        dd <- gsub("Unclassified",NA,bac3[,j + Sample_numb])
        dd <- dd[complete.cases(dd)]
        dd1 <- c(dd1,length(unique(dd)))
    }
    tax.stat$Total <- dd1
    tax.stat$Taxonomy <- rownames(tax.stat)
    tax.stat <- tax.stat[,c("Taxonomy",colnames(tax.stat)[1:(ncol(tax.stat)-1)])]
    
    dd1 <- c()
    for (j in 1:6) {
        dd <- gsub("Unclassified",NA,bac3[,j + Sample_numb])
        dd <- dd[complete.cases(dd)]
        dd1 <- c(dd1,length(dd)/nrow(bac3))
    }
    tax.per <- data.frame(Taxonomy = c("Phylum","Class","Order","Family","Genus","Species"),
                          Per = dd1)
    tax.per$Taxonomy <- factor(tax.per$Taxonomy,levels = c("Phylum","Class","Order","Family","Genus","Species"))
    tax.per$lab <- paste(tax.per$Taxonomy,"-",round(tax.per$Per*100,2),"%",sep = "")
    p <- ggplot(tax.per,aes(Taxonomy,Per,fill = Taxonomy)) +
        geom_bar(stat = "identity",width = 0.9,show.legend = FALSE) +
        coord_polar(theta = "y",start = 0) + 
        geom_text(aes(Taxonomy,y = 0,label = lab),hjust = 1.05,size = 2) + 
        ylim(0,2) + 
        labs(x = NULL,y = NULL) + 
        scale_fill_manual(values = cbbPalette1) +
        theme_bw()+
        theme(panel.grid=element_blank(),
              panel.border = element_blank(),
              axis.ticks = element_blank(),
              axis.line = element_blank(), 
              axis.title=element_blank(),
              axis.text=element_blank())
    
    data.1 <- as.data.frame(t(bac[,1:(ncol(bac)-1)]))
    aa <- match(rownames(data.1),group$variable)
    data.1 <- data.1[aa,]
    data.1$Group <- group$Group
    data.group <- aggregate(data.1[,1:(ncol(data.1)-1)],
                            list(data.1$Group),mean)
    rownames(data.group) <- data.group$Group.1
    data.group <- t(data.group[,-1])
    data.group <- as.data.frame(cbind(data.group,bac[,ncol(bac)]))
    bac <- data.group
    bac3 <- as.data.frame(cbind(data.group[,-ncol(data.group)],bac3[,(ncol(bac3)-5):ncol(bac3)]))
    tax.stat1 <- c()
    for (i in 1:(ncol(bac)-1)) {
        dd1 <- c()
        for (j in 1:6) {
            dd <- ifelse(bac3[,i] > 0,bac3[,j + Group_numb],NA)
            dd <- gsub("Unclassified",NA,dd)
            dd <- dd[complete.cases(dd)]
            dd1 <- c(dd1,length(unique(dd)))
        }
        tax.stat1 <- cbind(tax.stat1,dd1)
    }
    tax.stat1 <- as.data.frame(tax.stat1)
    rownames(tax.stat1) <- c("Phylum","Class","Order","Family","Genus","Species")
    colnames(tax.stat1) <- colnames(bac)[1:(ncol(bac)-1)]
    dd1 <- c()
    for (j in 1:6) {
        dd <- gsub("Unclassified",NA,bac3[,j + Group_numb])
        dd <- dd[complete.cases(dd)]
        dd1 <- c(dd1,length(unique(dd)))
    }
    tax.stat1$Total <- dd1
    tax.stat1$Taxonomy <- rownames(tax.stat1)
    tax.stat1 <- tax.stat1[,c("Taxonomy",colnames(tax.stat1)[1:(ncol(tax.stat1)-1)])]
    
    result <- list(tax.stat,p,tax.stat1)
    return(result)
}