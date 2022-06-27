BEGIN{
gen["AA"]=11
gen["AC"]=12
gen["AG"]=13
gen["AT"]=14

gen["CA"]=12
gen["CC"]=22
gen["CG"]=23
gen["CT"]=24

gen["GA"]=13
gen["GC"]=23
gen["GG"]=33
gen["GT"]=34

gen["TA"]=14
gen["TC"]=24
gen["TG"]=34
gen["TT"]=44
}
(NR==1){print}
(NR>1){
	s = $1"\t"$2
	for (i = 3; i <= NF; ++i)
		if ($i in gen)
			s = s "\t" gen[$i]
		else
			s = s "\t" $i
	print s
}
