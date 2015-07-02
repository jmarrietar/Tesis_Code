setwd("/Users/josemiguelarrieta/Dropbox/11_Semestre/Tesis/Tesis_Code")
df<-read.csv('AUC.csv',header=T)

library(reshape2)
dfm <- melt(df[,c('Dataset.Algorithm.','Org','B.Bag','B.Ins')],id.vars = 1)
colnames(dfm) <- c("Dataset.Algorithm.", "variable","AUC")
library(ggplot2)
library(Cairo)
Cairo(file="AUC.png",type="png",units="in",width=10,height=7,pointsize=12,dpi=300)
ggplot(dfm,aes(x = Dataset.Algorithm. ,y = AUC)) + 
  geom_bar(aes(fill = variable),position = "dodge",stat="identity")+ coord_flip()+ xlab("Dataset [Algorithm]")
dev.off()

######################################################################################

df<-read.csv('F.csv',header=T)

library(reshape2)
dfm <- melt(df[,c('Dataset...Algorithm.','Org','B.Bag','B.Ins')],id.vars = 1)
colnames(dfm) <- c("Dataset.Algorithm.", "variable","F")
library(ggplot2)
#library(Cairo)
#Cairo(file="F.png",type="png",units="in",width=10,height=7,pointsize=12,dpi=300)
ggplot(dfm,aes(x = Dataset.Algorithm. ,y = F)) + 
  geom_bar(aes(fill = variable),position = "dodge",stat="identity")+ coord_flip()+ xlab("Dataset [Algorithm]")
#dev.off()