#!/bin/bash

#Script to read list of domains in multiple cpanel server and find duplicates and show where the domain is actually pointed to.
ServerList=Servers   #copy the userdomains file to this path
ListLength=$(ls -1 $ServerList | grep -v "'" | wc -l)
echo "Domain  Original  Duplicates" # > Output
echo ""  > Common.txt
for i in `ls -1 $ServerList | grep -v "'"`
  do
    awk '{print $1}' $ServerList/$i | rev |cut -c2-| rev > $ServerList/$i.tmp   #Cut only the domain names from userdomains
  done

#
for i in `ls -1 $ServerList | grep -v "'" | grep tmp` #loop the serverlist
 do
   #echo $i

for j in `cat $ServerList/$i`  #loop the domains
  do
    #echo $j
DUP=$(grep -w $j $ServerList/*.tmp | cut -f1 -d ":")
DUPWC=$(grep -w $j $ServerList/*.tmp | grep -v $i | cut -f1 -d ":"| wc -l) #check if found in multiple files

GRP=$(grep -c $j Common.txt)

if [ $GRP -gt 0 ];
then
  :
else

while [ $DUPWC -gt 0 ]
do

 echo "$j" >> Common.txt

IP=$(dig  +short $j)

RDNS=$(dig -x $IP +short | head -1)


echo $j $RDNS $DUP

break

done

#host $IP | awk '{print $5}'

fi

done
  done





rm -f $ServerList/*.tmp
#rm -f  Common.txt
