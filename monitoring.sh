#!/bin/bash

echo "#Architecture : Linux" $(uname -rm)
echo "#CPU Physical :" $(cat /proc/cpuinfo | grep "cpu cores" | tail -c 2)
echo "#vCPU :" $(cat /proc/cpuinfo | grep processor | wc -l)
memused=$(cat /proc/meminfo | grep "Mem" | tail -n 1 | cut -b 19-24)
memtotal=$(cat /proc/meminfo | grep "Mem" | head -n 1 | cut -b 19-24)
echo "#Memory Usage : $memused kb/$memtotal kb" $(printf "(%.2f\n%%)" $(echo "($memused / $memtotal) * 100" | bc -l))
dfavailable=$(df -a --total | tail -n 1 | cut -b 43-49)
dfsize=$(df -a --total | tail -n 1 | cut -b 53-59)
dfused=$(df -a --total | tail -n 1 | cut -b 62-64)
echo "#Disk Usage : $dfavailable kb/$dfsize kb ($dfused)"
echo "#CPU Load :" $(uptime | cut -b 45-48)
echo "#Last Boot:" $(last reboot --time-format iso | tail -n 1 | cut -b 13-37)
lvmuse=$(lsblk | grep -c "lvm")
if  [ $lvmuse -gt 0 ];
then
	echo "#LVM use : yes"
else
	echo "#LVM use : no"
fi
echo "#TCP Connexions:" $(ss -s | head -n 2 | tail -n 1 | cut -b 1-8)
echo "#Users logged:" $(w -h | wc -l)
ipaddr=$(ifconfig -a | grep "inet" | head -n 1 | cut -b 14-22)
macaddr=$(ifconfig -a | grep "ether" | cut -b 15-31)
echo "#Network IP: $ipaddr ($macaddr)"
sudocmd=$(cat /var/log/sudo | wc -l)
echo "#Sudo count log:" $(printf "%.0f" $(echo "($sudocmd / 2)" | bc -l))
