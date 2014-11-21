#Translator.pl
#email: jfwalker@umich.edu
#Translation program for a file of coding fasta
#nucleotides.  The first my translator HASH has
#the "Universal" genetic code the second has
#the MTDNA genetic code.  They can be switched relatively
#easily.  By uncommenting different parts the program
#can easily be changed to check all or chosen orf's, print things
#out in blocks or a new hash can be added with changed genetic
#code. 
# input: ~/Folder$perl Translator.pl Fasta.fasta

use strict;
#----------------------------------------------------------------------------------
#translate:
#Turn DNA into A.A sequence
#Example: @frames=translate($DNAseq);
#----------------------------------------------------------------------------------

sub translate{
	my(@DNAseq)=@_;
	my@frames;
	my$amino_acid_sequence;
	#my %translator = ("TTT"=>"F", "TTC"=>"F", "TTA"=>"L", "TTG"=>"L",
	 #		   "TCT"=>"S", "TCC"=>"S", "TCA"=>"S", "TCG"=>"S",
     #          "TAT"=>"Y", "TAC"=>"Y", "TAA"=>"*", "TAG"=>"*",
     #          "TGT"=>"C", "TGC"=>"C", "TGA"=>"*", "TGG"=>"W",
     #          "CTT"=>"L", "CTC"=>"L", "CTA"=>"L", "CTG"=>"L",
     #          "CCT"=>"P", "CCC"=>"P", "CCA"=>"P", "CCG"=>"P",
     #          "CAT"=>"H", "CAC"=>"H", "CAA"=>"Q", "CAG"=>"Q",
     #          "CGT"=>"R", "CGC"=>"R", "CGA"=>"R", "CGG"=>"R",
     #          "ATT"=>"I", "ATC"=>"I", "ATA"=>"I", "ATG"=>"M",
     #          "ACT"=>"T", "ACC"=>"T", "ACA"=>"T", "ACG"=>"T",
     #          "AAT"=>"N", "AAC"=>"N", "AAA"=>"K", "AAG"=>"K",
     #          "AGT"=>"S", "AGC"=>"S", "AGA"=>"R", "AGG"=>"R",
     #          "GTT"=>"V", "GTC"=>"V", "GTA"=>"V", "GTG"=>"V",
     #          "GCT"=>"A", "GCC"=>"A", "GCA"=>"A", "GCG"=>"A",
     #          "GAT"=>"D", "GAC"=>"D", "GAA"=>"E", "GAG"=>"E",
     #          "GGT"=>"G", "GGC"=>"G", "GGA"=>"G", "GGG"=>"G");
    	my %translator = ("TTT"=>"F", "TTC"=>"F", "TTA"=>"L", "TTG"=>"L",
			   "TCT"=>"S", "TCC"=>"S", "TCA"=>"S", "TCG"=>"S",
               "TAT"=>"Y", "TAC"=>"Y", "TAA"=>"*", "TAG"=>"*",
               "TGT"=>"C", "TGC"=>"C", "TGA"=>"W", "TGG"=>"W",
               "CTT"=>"L", "CTC"=>"L", "CTA"=>"L", "CTG"=>"L",
               "CCT"=>"P", "CCC"=>"P", "CCA"=>"P", "CCG"=>"P",
               "CAT"=>"H", "CAC"=>"H", "CAA"=>"Q", "CAG"=>"Q",
               "CGT"=>"R", "CGC"=>"R", "CGA"=>"R", "CGG"=>"R",
               "ATT"=>"I", "ATC"=>"I", "ATA"=>"M", "ATG"=>"M",
               "ACT"=>"T", "ACC"=>"T", "ACA"=>"T", "ACG"=>"T",
               "AAT"=>"N", "AAC"=>"N", "AAA"=>"K", "AAG"=>"K",
               "AGT"=>"S", "AGC"=>"S", "AGA"=>"*", "AGG"=>"*",
               "GTT"=>"V", "GTC"=>"V", "GTA"=>"V", "GTG"=>"V",
               "GCT"=>"A", "GCC"=>"A", "GCA"=>"A", "GCG"=>"A",
               "GAT"=>"D", "GAC"=>"D", "GAA"=>"E", "GAG"=>"E",
               "GGT"=>"G", "GGC"=>"G", "GGA"=>"G", "GGG"=>"G");  
	#my $seqlen = length($DNAseq);
	my@newarray;
	
	foreach my$i ( 0 .. 2){
	
	push @newarray, $DNAseq[0];
	$DNAseq[0] =~ s/^.//;
	
	}
		
	foreach my$j (0..$#newarray){
	$amino_acid_sequence =~ s/X$//;
	$amino_acid_sequence =~ s/\*$//;
	push @frames, $amino_acid_sequence;
	$amino_acid_sequence = '';
	my $seqlen = length($newarray[$j]);
	my$k = $seqlen / 3;
		foreach my$i (0..$k){
		my$start = $i * 3;
		my$codon = substr($newarray[$j], $start, 3);
		if (exists $translator{$codon}){
		$amino_acid_sequence = $amino_acid_sequence . $translator{ $codon };
		}else{
			$amino_acid_sequence = $amino_acid_sequence . "X";
		}
		}
	}
	$amino_acid_sequence =~ s/X$//;
	$amino_acid_sequence =~ s/\*//;

	push @frames, $amino_acid_sequence;
	return @frames;	
}

#----------------------------------------------------------------------------------
#formatSeq:
#turn DNA into columns of sequences
#Example: $formatted=formatSeq($protseq, $blocklength, $linelength);
#----------------------------------------------------------------------------------

sub formatSeq{	

	my($seq, $ten, $fifty)=@_;	
	my ($makeBlock, $protBlock, $protlength);
												
	$protlength=length($seq);	

	for(my $pos=0;$pos<$protlength;$pos+=$ten){
		#make blocks if they can fit on line
		if (($pos+$ten)%$fifty){
			$makeBlock = substr( $seq, $pos, $ten );
			$makeBlock = "$makeBlock ";
		}else{
			$makeBlock = substr( $seq, $pos, $ten );
			$makeBlock="$makeBlock\n";	
		}
		$protBlock .= "$makeBlock";
	}
	#remove extra end space
	$protBlock =~ s/ $//;
	return $protBlock;
}

#----------------------------------------------------------------------------------
#reverseComplement
#create reverse complement of DNA
#Example: $RevCompSeq=reverseComplement($seq);
#----------------------------------------------------------------------------------

sub reverseComplement{
	my ($seq)=@_;
	my$reverseseq = reverse $seq;			
	$reverseseq =~ tr/ATCG/TAGC/;	
	$seq = $reverseseq;					
	return $seq;
} 


#----------------------------------------------------------------------------------
# main program
#----------------------------------------------------------------------------------
my ($name, $line, $dont_need, $sequence_name, $newseq);
my (@sequence_names, @sequence, @amino_acid);

while ($line = <>)                                    
{   
	#put everything onto one line

    chomp $line;  
	if ( $line =~ /^>/ ) {
		($name, $dont_need) = split " ", $line, 2;
		$sequence_name = $name;
		$sequence_name =~ s/^>//;
		push @sequence_names, $sequence_name;
		push @sequence, $newseq;
		$newseq = "";
	}else{
  
		$newseq .= $line;
	}
	
}
push @sequence, $newseq;
shift @sequence;

#loop for print statements and to call on functions
foreach my $k (0..$#sequence_names){
	
	my @reversed;
	$reversed[$k]=reverseComplement($sequence[$k]);
	
	#forward reading frames
	my @amino_acid=translate($sequence[$k]);	
	#my$AAs=@amino_acid;
	#print "AAs $AAs\n";
	foreach my $i (1..1){
			
		my $count = $i + 1;	
		my $formatted=formatSeq($amino_acid[$i], 10, 50);	
		#print "$sequence[$k]\n";
		print ">$sequence_names[$k]\n$amino_acid[$i]\n";		
	}
	
	#reverse reading frames
	#@amino_acid=translate($reversed[$k]);  
	#foreach my $i (1..3){
			
	#	my $count = $i + 1;			
	#	my $formatted=formatSeq($amino_acid[$i], 10, 50);														  
	#	print ">$sequence_names[$k]_r$i $sequence_names[$k] reverse reading frame $i\n$amino_acid[$i]\n";		
	#}
	
}




