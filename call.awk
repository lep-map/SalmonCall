#awk -f call.awk calls.txt counts.txt
BEGIN{
	map["A"] = 1
	map["C"] = 2
	map["G"] = 3
	map["T"] = 4
	
	gen[11] = "AA"
	gen[12] = "AC"
	gen[13] = "AG"
	gen[14] = "AT"
	gen[21] = "AC"
	gen[22] = "CC"
	gen[23] = "CG"
	gen[24] = "CT"
	gen[31] = "AG"
	gen[32] = "CG"
	gen[33] = "GG"
	gen[34] = "GT"
	gen[41] = "AT"
	gen[42] = "CT"
	gen[43] = "GT"
	gen[44] = "TT"

	if (tol == "")
		tol = log(0.05)
	else
		tol = log(tol)
}
(NR==FNR) {
	s = $1"\t"$2
	a1[s] = map[$3]
	a2[s] = map[$4]
	
	f1[s] = log($5 + 1e-20)
	f2[s] = log($6 + 1e-20)
	f3[s] = log($7 + 1e-20)

	g1[s] = log(1 - $5 + 1e-20)
	g2[s] = log(1 - $6 + 1e-20)
	g3[s] = log(1 - $7 + 1e-20)

	p1[s] = log($8 + 1e-20)
	p2[s] = log($9 + 1e-20)
	p3[s] = log($10 + 1e-20)
}
(NR!=FNR) {
	if (FNR == 1)
		print
	else {
		s = $1"\t"$2
		if (s in a1) {
			as1 = a1[s]
			as2 = a2[s]
			ps1 = p1[s]
			ps2 = p2[s]
			ps3 = p3[s]
			fs1 = f1[s]
			fs2 = f2[s]
			fs3 = f3[s]
			gs1 = g1[s]
			gs2 = g2[s]
			gs3 = g3[s]
			for (i = 2; i <= NF; i+=4) {
				c1 = $(i+as1)
				c2 = $(i+as2)
				l[1] = ps1 + c1 * fs1 + c2 * gs1
				l[2] = ps2 + c1 * fs2 + c2 * gs2
				l[3] = ps3 + c1 * fs3 + c2 * gs3
				maxj = 1
				for (j = 2; j <= 3; ++j)
					if (l[j] > l[maxj])
						maxj = j
				maxj2 = 1 + (maxj == 1)
				for (j = 1; j <= 3; ++j)
					if (j != maxj && l[j] > l[maxj2])
						maxj2 = j
				if (l[maxj] + tol > l[maxj2]) {
					if (maxj == 1)
						s = s "\t" gen[as2 as2]
					else if (maxj == 2)
						s = s "\t" gen[as1 as2]
					else
						s = s "\t" gen[as1 as1]
				
				} else
					s = s "\tNA"
					
			}
			print s
		}
	}
}

