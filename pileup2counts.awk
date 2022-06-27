#samtools mpileup -q 10 -Q 10 -s $(cat sorted_bams)|awk -f pileup2counts.awk
#needs mapping.txt
BEGIN{
	#reads mapping.txt
        while ((getline line < "mapping.txt") > 0) {
		++NF
		$(NF) = line
	}
	if (NF == 0) {
		print "Error: file mapping.txt not found!"  > "/dev/stderr"
		exit
	}
	s = "CHR\tPOS"

	numIndividuals = 0
	for (i = 1; i <= NF; ++i) {
		mapping[i] = $i
		if (!($i in imapping))
			listOrder[++numIndividuals] = $i
		++imapping[$i]
	}
	print "Number of bams = "  NF > "/dev/stderr"
	print "Number of individuals = "  numIndividuals > "/dev/stderr"
	close("cat mapping.txt")


	for (mi = 1; mi <= numIndividuals; ++mi) {
		s = s "\t" listOrder[mi]
	}
	print s
	FS="\t"
}
{
	delete prob
	for (i = 5; i <= NF; i+=4) {
		if ($(i-1) == 0)
			$i = ""
		gsub(/\$/,"",$i)  #remove end of reads
		gsub(/\^./,"",$i) #remove quality
		while (match($i, /[+-][1-9][0-9]*/) > 0) { #remove indels
			$i = substr($i, 1, RSTART - 1) substr($i, RSTART + RLENGTH + substr($i, RSTART + 1, RLENGTH - 1))
		}
		individual = mapping[int(i / 4)] 
                tmp = $i
		prob[individual, 1] += gsub(/[Aa]/, "", tmp)
		prob[individual, 2] += gsub(/[Cc]/, "", tmp)
		prob[individual, 3] += gsub(/[Gg]/, "", tmp)
		prob[individual, 4] += gsub(/[Tt]/, "", tmp)
	}
	s = $1 "\t" $2
	for (mi = 1; mi <= numIndividuals; ++mi) {
		m = listOrder[mi]

		s = s "\t" (prob[m, 1] + 0)
		for (k = 2; k <= 4; ++k)
			s = s " " (prob[m, k]+0)
	}
	print s
}
