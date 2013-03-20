	#!/bin/bash
#i-c138d3b3 stopped stapp m1.medium 10.234.3.247
keypairdev="integ"
keypairprod="stapp|stdb|vpc-public-10-234-1"
keypairstage="scp-staging"
tmpFile="/tmp/ec2.info"
tmpFile2="/tmp/ec2tags.info"
tmpFile3="/tmp/ec2volumes.info"
echo -n "Choose your option 1,2,3,4 "
echo "1. Prod"
echo "2. Staging"
echo "3. Dev"
echo "4. Search a specific"
read answer
echo $answer
case $answer in
	1) keypair=$keypairprod
	search();
	;;
	2)  keypair=$keypairstage ;;
	3)  keypair=$keypairdev ;;
	4)  
	echo "nombre maquina"
	read instance
	keypair=""
	ec2Info= $(ec2-describe-instances |grep INSTANCE | awk {'print $2, $4, $5, $7,  $12, $NF'} > $tmpFile)
	ec2name=`ec2-describe-tags --filter "resource-type=instance"  > $tmpFile2 `
	instance=$answer
	keypair=`cat $tmpFile |  grep $instance | awk {' print $3 '}`
        status=`cat $tmpFile |  grep $instance | awk {' print $2 '}`
        ip=`cat $tmpFile |  grep $instance | awk {' print $5 '}`
        id=$instance
        size=`cat $tmpFile  | grep $instance | awk {' print $4 '}`
        #TAG     instance        i-da0ac0a9      Name    STAGING-public-webserver2
        name=`cat  $tmpFile2 | grep $instance |awk {'print $5'} `
        #name=`cat $tmpFile  | grep $instance | awk {' print $6 '}`
        #prodapp-type2-smp5 -  running - 10.234.3.76 - i-8b12fcf9 - m1.xlarge stapp
        #volumes=`ec2-describe-instance-attribute $instance -b`
        volumes=`cat  $tmpFile3 | grep $instance |awk {'print $2'} `
	echo "$name | $status | $ip | $id | $size | $keypair| $volumes";
	;;
	*) echo "INVALID NUMBER!" ;;
esac

search()
{
ec2Info=`ec2-describe-volumes > $tmpFile3`
ec2Info= $(ec2-describe-instances |grep INSTANCE | egrep $keypair| awk {'print $2, $4, $5, $7,  $12, $NF'} > $tmpFile)
# ec2Info=`ec2-describe-instances | grep -e INSTANCE| grep -e running | egrep 'prod|stapp' |awk {'print $2, $4, $5, $7,  $12'} > $tmpFile`
 ec2name=`ec2-describe-tags --filter "resource-type=instance"  > $tmpFile2 `
 nstances=`cat $tmpFile |  awk {'print $1'}`
 numOfInstances=`cat $tmpFile | grep running | wc -l`
 you=`whoami`
echo "The instances you have, by hostname, are as follows ..."
echo "You have $numOfInstances instances running  that fit in your search running"
echo "*******************************************************"
echo "Instance name - status - IP - instance ID - Size - Keypair - Volumes"
echo "*******************************************************"
 for instance in $nstances
 do
	keypair=`cat $tmpFile |  grep $instance | awk {' print $3 '}`
        status=`cat $tmpFile |  grep $instance | awk {' print $2 '}`
	ip=`cat $tmpFile |  grep $instance | awk {' print $5 '}`
        id=$instance
	size=`cat $tmpFile  | grep $instance | awk {' print $4 '}`
	#TAG     instance        i-da0ac0a9      Name    STAGING-public-webserver2
	name=`cat  $tmpFile2 | grep $instance |awk {'print $5'} `
	#name=`cat $tmpFile  | grep $instance | awk {' print $6 '}`
        #prodapp-type2-smp5 -  running - 10.234.3.76 - i-8b12fcf9 - m1.xlarge stapp
	#volumes=`ec2-describe-instance-attribute $instance -b`
	volumes=`cat  $tmpFile3 | grep $instance |awk {'print $2'} `
	echo "$name | $status | $ip | $id | $size | $keypair| $volumes"
	echo "---------------------------------------------------------------------" 
done
}
