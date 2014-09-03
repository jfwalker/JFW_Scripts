##############################################
#	Mitochondria_Gene_Splitter.pl	     #	
#		by: Joe Walker		     #  	
#	email: jfwalker@umich.edu	     #	
##############################################
#The purpose of this script is to take in Mito
#files from genbank downloaded as fasta and 
#remove the genes from the files
#usage: perl Mitochrondria_Gene_Splitter.pl/
#	     Mitochondrial.fasta/
#	     Features.txt
use Data::Dumper;
open(MITO, $ARGV[0])||die "do not have full Mito file";
while ($line = <MITO>){

	chomp $line;
	if ($line =~ /^>/){
		
		$NCBI_Name = ($line =~ m/.*?\|.*?\|.*?\|(.*?)\|.*/)[0];	
		$Science_Name = ($line =~ m/>.*? (.*?) mitochon.*/)[0];
		$HASH{$NCBI_Name}[1] = $Science_Name;
	}else{

		$HASH{$NCBI_Name}[0] .= $line;
	}

}
close(MITO);
$count = 0;
#print Dumper(\%HASH);
open(FEATURES, $ARGV[1])||die "do not have features file";
while($line = <FEATURES>){

	chomp $line;
	if ($line =~ /^>/){
		
		$NCBI_Name = ($line =~ m/.*?ref\|(.*?)\|.*/)[0];

		 
	}elsif($line =~ /gene/g){
		
		#$NCBI_Name = "$NCBI_Name\_A$count";

		@array = split "\t", $line;
		if(@array[2] =~ /gene/){
			$NCBI_Name = "$NCBI_Name-$count";
			$Feature_Hash{$NCBI_Name}[0] = @array[0];
			$Feature_Hash{$NCBI_Name}[1] = @array[1];
		}elsif(@array[3] =~ /gene/){

			$Feature_Hash{$NCBI_Name}[2] = @array[4];
		}else{}
		$count++;

	}else{}

}
#print Dumper(\%Feature_Hash);
foreach $key (%Feature_Hash){
	
	#print "$key\n";
	$name = ($key =~ m/(.*?)-.*/)[0];
	if (exists $HASH{$name}){

		#give values real names
		$gene_start = $Feature_Hash{$key}[0];
		$gene_end = $Feature_Hash{$key}[1];
		$gene_name = $Feature_Hash{$key}[2];
		$full_mito = $HASH{$name}[0];
		$species_name = $HASH{$name}[1];
		$NCBI_Name = $name;
		$species_name =~ s/ /_/g;
		$species_name =~ s/\.//g;
		if($gene_start >= $gene_end){
			$gene_off = $gene_start - $gene_end;
			open(out, ">>$gene_name");
			print out "$species_name-$NCBI_Name-$gene_off\n";
			$Clipped_gene = substr $full_mito, ($gene_end - 1), ($gene_off);
			print out "$Clipped_gene\n";
		}else{
			open(out, ">>$gene_name");
		
			$gene_off = $gene_end - $gene_start;
			print out "$species_name-$NCBI_Name-$gene_off\n";
			$Clipped_gene = substr $full_mito, ($gene_start - 1), ($gene_off);
			print out "$Clipped_gene\n";

		}
	}
}



