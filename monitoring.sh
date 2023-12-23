#!/bin/bash
#!/bin/bash

echo "#Architecture : " $(uname -sra)
echo "#CPU Physical :" $(cat /proc/cpuinfo | grep "cpu cores" | tail -c 2)
echo "#vCPU :" $(cat /proc/cpuinfo | grep processor | wc -l)
meminfo=$(free --mega | awk 'NR==2 {print $2,$3}')
memused=$(echo $meminfo | awk '{print $2}')
memtotal=$(echo $meminfo | awk '{printf $1}')
echo "#Memory Usage : $memused kb/$memtotal kb" $(printf "(%.2f\n%%)" $(echo "($memused / $memtotal) * 100" | bc -l))
dfinfo=$(df -a --total -h | tail -n 1)
dfavailable=$(echo $dfinfo | awk '{print $4}')
dfused=$(echo $dfinfo | awk '{print $3}')
dfpercentage=$(echo $dfinfo | awk '{print $5}')
echo "#Disk Usage : $dfused /$dfavailable ($dfpercentage)"
echo "#CPU Load :" $(uptime | cut -b 45-48)
echo "#Last Boot:" $(last reboot | head -n 1 | awk '{print $5,$6,$7,$8}')
lvmuse=$(lsblk | grep -c "lvm")
if  [ $lvmuse -gt 0 ];
then
	echo "#LVM use : yes"
else
	echo "#LVM use : no"
fi
echo "#TCP Connexions:" $(ss -s | head -n 2 | tail -n 1 | cut -b 16-17)
echo "#Users logged:" $(w -h | wc -l)
ipaddr=$(ifconfig -a | grep "inet" | head -n 1 | cut -b 14-22)
macaddr=$(ifconfig -a | grep "ether" | cut -b 15-31)
echo "#Network IP: $ipaddr ($macaddr)"
sudocmd=$(cat /var/log/sudo | wc -l)
echo "#Sudo count log:" $(printf "%.0f" $(echo "($sudocmd / 2)" | bc -l))
