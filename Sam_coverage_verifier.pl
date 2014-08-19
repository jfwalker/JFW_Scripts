#####################################################
#													#
# 			Sam_coverage_verifier.pl				#
#				By: Joey Walker						#
#####################################################
#The purpose of this program is to take a fully 
#assembled circular genome and find the areas of low 
#coverage from a sam file that has been mapped to it 
#or a closely related species
#	
#	usage perl Sam_coverage_verifier.pl /
#		  	   Genome_file.fa/
#			   Sam_file.sam/
#			   Window_size/
#			   output.txt


use Data::Dumper;
#take in length of reads
$window = int($ARGV[2]);
open(FILE, $ARGV[0])||die "can't open";
open(out, ">$ARGV[3]")||die "no output";
$count = 1;
#while loop takes in the Genome file
while ($line = <FILE>){
	
	chomp $line;
	#ignores the header line
	if ($line !~ /^>/){
		
		#create a sequence that extends onto the beginning
		#and end, to make up for it being a circular genome
		$size = length($line);
		$begin_end = $size - $window;
		$end = substr $line, $begin_end, ($window - 1);
		$start = substr $line, 0, ($window - 1);
		$end .= $line .= $start;
		#$total_size = length($end);
		
		#create a Hash of all possible Read combinations
		#that could be found from the chloroplast
		foreach $i (1..(length($end))){
			
			$end =~ m/(.{$window}).*/;
			$HASH{$1}[0] = $i;
			$HASH{$1}[1] = 0;
			$end =~ s/^.//;

		}
		#print "$line\n";
		#push @array, $1;
	}
}
#print out Dumper(\%HASH);
close(FILE);
open(SAM, $ARGV[1])||die "can't open";
#open(out, ">>$ARGV[3]")||die "no output";
$count = 1;
#take in sam file
while ($line = <SAM>){

	$line =~ m/.*?\t.*?\t(.*?)\t.*?\t.*?\t.*?\t.*?\t.*?\t.*?\t(.*?)\t.*/;
	print "$count\n";
	#if the sam read exists give a value to the read
	if (exists $HASH{$2}){
		
		$HASH{$2}[1] += 1;
	}
	$count++;

}
#sort the Hash based on position the read would be found
my @keys = sort { $HASH{$a}[0] <=> $HASH{$b}[0] } keys(%HASH);

foreach $i (0..$#keys){
	
	#create two arrays, one with the position and a corresponding
	#one with the number of times it maps
	if (exists $HASH{$keys[$i]}){
	
		#print out "$HASH{$keys[$i]}[0]\t$HASH{$keys[$i]}[1]\n";
		push @position, $HASH{$keys[$i]}[0];
		push @counts, $HASH{$keys[$i]}[1];
	}

}
#Since each base has 101 different possible sequences to result in
#a value, sum up those 101 for each base	
$position_count = 0;
foreach $i (($window)..($#position - ($window))){

	foreach $j (0..$window){
	
		$position_count += $counts[$i - $j];
		if ($j != 0){
		
			$position_count += $counts[$i + $j];
		}
	}
	if ($position_count <= 1){
		print out "$position[$i - $window]\t$position_count\t";
		print out "SANGERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR\n";
	}else{
		print out "$position[$i - $window]\t$position_count\n";
	}
	$position_count = 0;
}
#print out Dumper(\@position_count_array);
#print out Dumper(\@keys);