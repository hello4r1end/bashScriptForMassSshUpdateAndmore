
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
SUBNET="192.168.1"
NETMASK="192.168.1.0/24"
USERNAME="Put the username"
read -s -p "Enter the SSH password: " PASSWORD
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
                sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no "$USERNAME@$IP" "sudo -S apt-get update && sudo -S apt-get upgrade -y" > "${IP}_update_report.txt" 2>&1

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

                # Try to SSH into the machine and run the update, upgrade, and autoremove commands
                sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no "$USERNAME@$IP" "sudo -S apt-get autoremove -y" 

                # Check if the update was successful and print a message
                if [ $? -eq 0 ]; then
                    echo -e "\033[1;32mautoremove successful for $IP.\033[0m"
                else
                    echo -e "\033[1;31mautoremove failed for $IP.\033[0m"
                fi
            done
            ;;
            
            3)
            
            # The name txt of hosts
hosts_file="hosts.txt"

# The name of the Excel file to save the data
excel_file="hosts.xlsx"


# Delete the old Excel file if it existsif [ -f "/home/hellofriend/Desktop/New Folder/$excel_file" ]; then
    rm "home/hellofriend/Desktop/New Folder/$excel_file"


# Create the new Excel file and insert the headers in the first rowtouch "/home/smith/Desktop/scripts/SN/excel_save/$excel_file"
echo -e "IP\--Hostname---Serial Number" | tr '\t' '\n' | xargs -I {} echo -n "{}\t" >> "/home/hellofriend/Desktop/New Folder/excel_save/$excel_file"
echo "" >> "/home/hellofriend/Desktop/New Folder/excel_save/$excel_file"

# # Iterate for each host in the file
while read host; do
    # # Connect to the host via ssh and save the IP and hostname
    ip=$(sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $USERNAME@$host "hostname -I | awk '{print $1}'")
    hostname=$(sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $USERNAME@$host "hostname")
    serial=$(echo $PASSWORD | lsblk --nodeps -o name,serial | grep sda | awk '{print $NF}')
   
      # Adding the host data to the Excel file
    echo -e "$ip\hostname-->$hostname SN-->$serial" | tr '\t' '\n' | xargs -I {} echo -n "{}" >> "home/hellofriend/Desktop/New Folder/$excel_file"
    echo "" >> "home/hellofriend/Desktop/New Folder/excel_save/$excel_file"
done < "home/hellofriend/Desktop/New Folder/$hosts_file"

	;;
          4)
            exit
            ;;
        *)
            echo "Invalid option. Please choose again."
            ;;
    esac
done
