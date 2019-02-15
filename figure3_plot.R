
data=read.csv("figure3_memory_plot_input.txt",sep="\t",header=F)
print(data)
svg("figure3_memory_plot_input.svg")
par(oma=c(10,0,0,0))
data=data[order(data[,1]),]
barplot(data[,2],names=data[,1],las=2,ylab="kbytes")
dev.off()
