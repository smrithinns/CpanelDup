#!/bin/bash
IFS=$'\n'

#Script to read list of domains in multiple cpanel server and find duplicates and show where the domain is actually pointed to.
#Create a file with the server name in the directory Servers and copy userdomains into it.
ServerNum=$(ls -1 Servers)



#for i in `ls -1 Servers | grep -v "'"` #list of Servers
#do
  #echo $i

mapfile -t Arr_Server1 < <( awk '{print $1}' Servers/Server1 | rev |cut -c2-| rev )#Read domain names to array

    #done

#for i in `ls -1 Servers`
#do
   for arr in "${Arr_Server1[@]}"
  do
     echo -e "  $arr"
   done
#done
