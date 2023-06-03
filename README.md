# bashScriptForMassSshUpdateAndmore
bash script for mass update, upgrade, autoremove and take the Serial Number for all linux PCs in your Network


Works only for linux machines

ABOUT

Bash script that can connect via ssh to the network and do update, upgrade autoremove and write in an excel all the serial numbers of the hard disk for each of the network computers with their ips and hostnames.
It is also necessary to have the name of excel in the line excel_file="hosts.xlsx" as it assumes that the bash script and excel are in the same folder. We also need a host txt file that will contain all the hosts that we want to do the above actions, hosts_file="hosts.txt"
