#!/bin/bash

#Script to read list of domains in multiple cpanel server and find duplicates and show where the domain is actually pointed to.
ServerList=Servers   #copy the userdomains file to this path
ListLength=$(ls -1 $ServerList | grep -v "'" | wc -l)
echo " Domain,Original,Duplicates"
for i in `ls -1 $ServerList | grep -v "'"`
  do
    awk '{print $1}' $ServerList/$i | rev |cut -c2-| rev > $ServerList/$i.tmp   #Cut only the domain names from userdomains
  done

#
for i in `ls -1 $ServerList | grep -v "'" | grep tmp`
 do
for j in `cat $ServerList/$i`
  do
    DUP=$(grep -w common *.tmp | grep -v Server1.tmp | cut -f1 -d ":")
    
OP=$(grep -w $j $ServerList/*.tmp | grep -v $i)

if  $OP ;
  then
    echo -e " $j , $(dig +short -x `dig  +short $j`) , $OP"

    sed '/\<$j\>/d'
done
done






  #rm -f $ServerList/*.tmp
