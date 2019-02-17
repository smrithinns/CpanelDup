#!/bin/bash
#Date: 20190215

#Script to read list of domains in multiple cpanel server and find duplicates and show where the domain is actually pointed to.

ServerList=Servers   #Copy the userdomains file to this path

echo "Domain,Duplicates,Original"  > Output
echo ""  > Common.txt

for i in `ls -1 $ServerList | grep -v "'"`
  do
      awk '{print $1}' $ServerList/$i | rev |cut -c2-| rev > $ServerList/$i.tmp   #Cut only the domain names from userdomains
  done


for i in `ls -1 $ServerList | grep -v "'" | grep tmp` #loop the Serverlist
 do
   #echo $i

   for j in `cat $ServerList/$i`  #loop the domains
    do
    #echo $j

#Find domains in multiple servers

      DUPWC=$(grep -w ^$j $ServerList/*.tmp | grep -v $i | cut -f1 -d ":"| wc -l) #check if found in multiple files
      GRP=$(grep -c $j Common.txt)

      if [ $GRP -gt 0 ]; #This is to remove duplicate check
        then
            :
      else

        while [ $DUPWC -gt 0 ]
          do
            echo "$j" >> Common.txt

            IP=$(dig  +short $j) #Original IP

            RDNS=$(dig -x $IP +short | head -1 | rev| cut -c2- | rev) #Hostname

            DUP=$(grep -w ^$j $ServerList/*.tmp | cut -f1 -d ":"| cut -c9- | rev | cut -c5- | rev | grep -v $RDNS )

            echo $j, $DUP, $RDNS >> Output

            break

          done
      fi
    done
done

rm -f $ServerList/*.tmp
rm -f  Common.txt
