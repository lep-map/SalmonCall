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
        for (i=3; i<=NF;i+=4){
		c1 = $(i+max)
		c2 = $(i+max2)
		if (c1+c2>=10)
			s = s "\t" c1/(c1+c2)
		else
			s = s "\tNA"
        }
	print s
}
