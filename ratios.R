d=read.table("ratios.txt")
c=read.table("selectgen.txt")
n = nrow(d)
m = ncol(d)
f = 1
for (i in 1 : n){
	title = paste0(d[i,1], " ", d[i,2])
	if (i %% 16 == 1) {
		if (i > 1)
			dev.off()
		file=paste0("ratio", f, ".png")
		f = f + 1
		png(file, width=1024,height=1024)
		par(mfrow=c(4,4))
	}
	plot(density(as.numeric(d[i,3:502]), na.rm=T),xlim=c(0,1),main=title)
	abline(v=c[i,5])
	abline(v=c[i,6])
	abline(v=c[i,7])
}
dev.off()
