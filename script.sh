
#!/bin/bash

#!/bin/bash

echo "  ______   ___    ___                                          "
echo " /\  _  \ /\_ \  /\_ \    __                                   "
echo " \ \ \L\ \\//\ \ \//\ \  /\_\    ___     ___     ___      __   "
echo "  \ \  __ \ \ \ \  \ \ \ \/\ \ /' _\`_  \` / __\`\\ /' _\`\\  /'__\`\\ "
echo "   \ \ \/\ \ \_\ \_ \_\ \_\ \ \/\ \/\ \/\ \L\ \/\ \/\ \/\  __/ "
echo "    \ \_\ \_\/\____\/\____\\ \_\ \_\ \_\ \____/\ \_\ \_\ \____\ "
echo "     \/_/\/_/\/____/\/____/ \/_/\/_/\/_/\/___/  \/_/\/_/\/____/ "
echo ""
echo "Design By P.Mavrogiannis"
echo ""
echo ""
echo ""

# Define the subnet, username, and password
SUBNET="192.168.10"
NETMASK="192.168.1.0/24"
USERNAME="Put username"
read -s  -p "Enter the SSH password: " PASSWORD
echo ""

# Loop through each IP address in the subnet and update the system
while true; do
    echo "Please choose an option:"
    echo "1. Update and upgrade"
    echo "2. Autoremove"
    echo "3. SN"
    echo "4. Exit"
    read -p "Option: " OPTION

    case $OPTION in
        1)
            for ((i=1;i<=1024;i++)); do
                IP="$SUBNET.$i"

                # Check if the IP address is in the subnet
                if [[ "$(sipcalc $IP $NETMASK | grep -c 'Network address')" == "1" ]] || [[ "$(sipcalc $IP $NETMASK | grep -c 'Broadcast address')" == "1" ]]; then
                    continue
                fi

                echo "Updating $IP..."

                # Try to SSH into the machine and run the update and upgrade commands
		sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -p 222 "$USERNAME@$IP" "echo $PASSWORD | sudo -S apt-get update && echo $PASSWORD | sudo -S apt-get upgrade -y && echo $PASSWORD | sudo -S apt-get autoremove -y " > /home/smt/Desktop/newscript/reports_update/"${IP}_update_report.txt" 2>&1






                # Check if the update was successful and print a message
                if [ $? -eq 0 ]; then
                    echo -e "\033[1;32mUpdate successful for $IP.\033[0m"
                else
                    echo -e "\033[1;31mUpdate failed for $IP.\033[0m"
                fi
            done
            ;;
        2)
             for ((i=1;i<=1024;i++)); do
                IP="$SUBNET.$i"

                # Check if the IP address is in the subnet
                if [[ "$(sipcalc $IP $NETMASK | grep -c 'Network address')" == "1" ]] || [[ "$(sipcalc $IP $NETMASK | grep -c 'Broadcast address')" == "1" ]]; then
                    continue
                fi

                echo "Autoremoving $IP..."

                # Try to SSH into the machine and run the autoremove commands
		sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -p 222 "$USERNAME@$IP" "echo $PASSWORD | sudo -S apt-get autoremove -y " > /home/smt/Desktop/newscript/reports_autoremove/"${IP}_autoremove_report.txt" 2>&1






                # Check if the Autoremoving was successful and print a message
                if [ $? -eq 0 ]; then
                    echo -e "\033[1;32mAutoremove successful for $IP.\033[0m"
                else
                    echo -e "\033[1;31mAutoremove failed for $IP.\033[0m"
                fi
            done
            ;;
            
            3)
            
            # The name of the hosts file

hosts_file="hosts.txt"

# The name of the Excel file to save the data

excel_file="hosts.xlsx"


# Delete the old Excel file if it exists

if [ -f "/home/smt/Desktop/newscript/excel/$excel_file" ]; then
    rm "/home/smt/Desktop/newscript/excel/$excel_file"
fi

# Create the new Excel file and insert the headers in the first row

touch "/home/smt/Desktop/newscript/excel"
echo -e "IP\--Hostname---Serial Number" | tr '\t' '\n' | xargs -I {} echo -n "{}\t" >>"/home/smt/Desktop/newscript/excel/$excel_file"
echo "" >> "/home/smt/Desktop/newscript/excel/$excel_file"

# Repeat for each host in the file

while read -r host; do
    # Connect to the host via ssh and save the IP and hostname

    if timeout 2s sshpass -p "$PASSWORD" ssh -n   -p 222 "$USERNAME@$host" "echo Connection successful; hostname -I | awk '{print \$1}'; hostname; lsblk -no name,serial | awk '/sda/{print \$2}'; exit"; then
    ip=$(sshpass -p "$PASSWORD" ssh -n -p 222 "$USERNAME@$host" "hostname -I | awk '{print \$1}'")
    hostname=$(sshpass -p "$PASSWORD" ssh -n  -p 222 "$USERNAME@$host" "hostname")
    serial=$(sshpass -p "$PASSWORD" ssh -n  -p 222 "$USERNAME@$host" "lsblk -no name,serial | awk '/sda/{print \$2}'")
#brand=$(sshpass -p "$PASSWORD" ssh -n -p 222 "$USERNAME@$host" "udevadm info --query=all --name=/dev/sda | grep 'ID_MODEL=' | awk -F= '{print \$3}'")

    #Record the host information in the excel file

    






   
      # Προσθήκη των δεδομένων του host στο αρχείο Excel
echo -e "$ip\t$hostname\t$serial" >> "/home/smt/Desktop/newscript/excel/$excel_file"




    
    else
    
      echo "Connection refused for $host"
        sleep 1s
        continue
    fi
    echo "" >> "/home/smt/Desktop/newscript/excel/$excel_file"
    continue
    

done < "/home/smt/Desktop/newscript/excel/$hosts_file"


	;;
          4)
            exit
            ;;
        *)
            echo "Invalid option. Please choose again."
            ;;
    esac
done
