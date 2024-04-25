rare.spec <- function(bac1,group){
    rare <- list()
    for (i in 1:length(levels(group$Group))) {
        tem <- bac1[rownames(bac1) %in% group[group$Group == levels(group$Group)[i],"variable"],]
        rare[[levels(group$Group)[i]]] <- floor(colMeans(tem))
    }
    rare <- iNEXT(rare,q = 0,datatype = "abundance")
    p1 <- ggiNEXT(rare,type = 1) + 
        scale_color_manual(values = cbbPalette) + 
        xlab("Sequencing depth (No. reads)") + 
        ylab("Number of ASVs") +
        theme_bw() +
        theme(panel.grid = element_blank(),
              legend.position = "right",
              axis.title = element_text(size = 12,face = "bold",colour = "black"),
              axis.text = element_text(colour = "black",size = 10))
    
    f <- function(x)sum(x==0)
    rare <- list()
    for (i in 1:length(levels(group$Group))) {
        tem <- bac1[rownames(bac1) %in% group[group$Group == levels(group$Group)[i],"variable"],]
        rare[[levels(group$Group)[i]]] <- apply(tem,2,f)
    }
    rare <- iNEXT(rare,q = 0,datatype = "abundance")
    p2 <- ggiNEXT(rare,type = 1) + 
        scale_color_manual(values = cbbPalette) + 
        scale_x_continuous(breaks = c(50000,100000,150000,200000),labels = c(20,40,60,80)) + 
        xlab("Sampling size (No. samples)") + 
        ylab("Number of ASVs") +
        theme_bw() +
        theme(panel.grid = element_blank(),
              legend.position = "right",
              axis.title = element_text(size = 12,face = "bold",colour = "black"),
              axis.text = element_text(colour = "black",size = 10))
    result <- list(p1,p2)
    return(result)
}