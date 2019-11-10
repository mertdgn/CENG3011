#!/bin/bash
#CENG3011, Homework 1, Mert Dogan
#This script makes some file proccessing
if [ $# != 1 ]; then   #checks the input number
echo You must enter 1 input
exit 1 
fi
if [[ $1 != *.gz ]]; then   #checks the input file extention
echo File must end with .gz
exit 1 
fi
if test -f $(pwd)/$1; then  #checks is the input file in directory
 echo $1 exists
 gunzip $1   #if file is in the directory, extract the gz file
 if [ $? == 0 ]; then  #checks is the extraction sucsessfull
  echo extraction is sucsessfull
  fname=$(basename "$1" .gz)
 else
  echo extraction is not sucsessfull
  exit 1
 fi
else
 echo $1 Does not exist
 exit 1
fi

#open extracted file, then arrange and get columns according to conditions. After that sort and write results to SV_del.bed file
cat $fname | grep '<DEL>' | sed "s/END=//; s/;SVLEN/\t;SVLEN/; s/;RPSUP=/\t/; s/;SRSUP=/\t;SRSUP/" | awk '{if($8>$2 && $8-$2>=1000 && $10>10) print $1, "\t", $2, "\t", $8}' | sort -k 1,1 -V -k 2,2 > SV_del.bed

#remove the file that we do not need it anymore
rm $fname

#count the same sizes and sort them. And write results to size_distribution.txt
awk '{print $3-$2}' SV_del.bed | sort -n | uniq -c | awk '{print $2, "\t",  $1}' > size_distribution.txt

