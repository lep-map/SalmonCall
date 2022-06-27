#cluster allele ratios to three
#Initial allele ratios F1 F2 and F3 (=0.01, 0.5, 0.99)
#awk [-vF1=0.01 -vF2=0.5 -vF3=0.99] -f counts2gen.awk counts.txt
BEGIN{
	map[0] = "A"
	map[1] = "C"
	map[2] = "G"
	map[3] = "T"
}
(NR>1){
	delete c
	for (i=3; i<=NF;i+=4){
		for (j = 0; j < 4; ++j)
			c[j] += $(i+j)
	}
	max = 0
	for (j = 0; j < 4; ++j)
		if (c[j] > c[max])
			max = j
	max2 = (max == 0)
        for (j = 0; j < 4; ++j)
                if (j != max && c[j] > c[max2])
                        max2 = j
	
#	print c[0]"\t"c[1]"\t"c[2]"\t"c[3]"\t"max"\t"max2
	s = $1"\t"$2
#	print s "\t" map[max] "\t" map[max2]
        for (i=3; i<=NF;i+=4){
		c1 = $(i+max)
		c2 = $(i+max2)
		count1[i] = c1
		count2[i] = c2
        }
        p1[0] = 0.33
        p1[1] = 0.33
        p1[2] = 0.33
	if (max_iter == "")
		max_iter = 10
	if (F1 == "")
		F1 = 0.01
	if (F2 == "")
		F2 = 0.5
	if (F3 == "")
		F3 = 0.99

        f1[0] = F1
        f1[1] = F2
        f1[2] = F3
        print s "\t" map[max] "\t" map[max2] "\t" em(p1, f1, count1, count2)
}
function logsum(a,b)
{
	if (a < b)
		return logsum(b, a)
	return a + log(1 + myexp(b - a)) 
}
function myexp(a){
	if (a <= -700)
		return 0
	return exp(a)
}
function em(p,f,data1,data2       ,i,j,ll,li,lf,lf2,lp,qp,qf,qf2,s,is,iter,l,t)
{
	for (iter = 1; iter<=max_iter; ++iter) {
		delete qp
		delete qf
		delete qf2
		for (j = 0; j < 3; ++j) {
			#1e-20 added to avoid problems with log(0)
			lf[j] = log(f[j] + 1e-20)
			lf2[j] = log(1-f[j] + 1e-20)
			lp[j] = log(p[j] + 1e-20)
		}
		ll = 0
		for (i in data1) {
			c1 = data1[i]
			c2 = data2[i]
		
			for (j = 0; j < 3; ++j) {
				l[j] = lp[j] + c1 * lf[j] + c2 * lf2[j]
			}
			li = logsum(logsum(l[0], l[1]), l[2])
			ll+=li
			for (j = 0; j < 3; ++j) {
				t = myexp(l[j] - li)
				qp[j] += t
				qf[j] += t * c1
				qf2[j] += t * c2
			}
	#		print c1,c2,logsum(logsum(l[0], l[1]), l[2])
		}
	#	print ll
		s = 0
		for (j = 0; j < 3; ++j)
			s += qp[j]
		is = 1.0 / s
		for (j = 0; j < 3; ++j) {
			p[j] = qp[j] * is
		}

		for (j = 0; j < 3; ++j) {
			s = (qf[j] + qf2[j])
			if (s > 1e-6)
				f[j] = qf[j] / s
		}
			
	}
	#print p[0],p[1],p[2],f[0],f[1],f[2]
	return  f[0] "\t" f[1] "\t" f[2] "\t" p[0] "\t" p[1] "\t" p[2]
}
