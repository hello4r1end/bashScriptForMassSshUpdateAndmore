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
USERNAME="smt"

# Read the SSH password
PASSWORD="123"
#read -s -p "Enter the SSH password: " PASSWORD
echo ""

# Function to check if SSH is open on an IP address
check_ssh() {
    IP="$1"
    nc -z -w5 "$IP" 22 > /dev/null 2>&1
    return $?
}

# Function to update the system
update_system() {
    IP="$1"
    echo "SSH is accessible on $IP. Proceeding with update..."
    echo "Updating $IP..."
    # Try to SSH into the machine and run the update command
    sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no "$USERNAME@$IP" "echo '$PASSWORD' | sudo -S apt-get update" > "${IP}_update_report.txt" 2>&1

    # Check if the update was successful and print a message
    if [ $? -eq 0 ]; then
        echo -e "\033[1;32mUpdate successful for $IP.\033[0m"
    else
        echo -e "\033[1;31mUpdate failed for $IP.\033[0m"
    fi
}

# Function to upgrade the system
upgrade_system() {
    IP="$1"
    echo "SSH is accessible on $IP. Proceeding with upgrade..."
    echo "Upgrading $IP..."
    # Try to SSH into the machine and run the upgrade command
    sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no "$USERNAME@$IP" "echo '$PASSWORD' | sudo -S apt-get upgrade" > "${IP}_upgrade_report.txt" 2>&1

    # Check if the upgrade was successful and print a message
    if [ $? -eq 0 ]; then
        echo -e "\033[1;32mUpgrade successful for $IP.\033[0m"
    else
        echo -e "\033[1;31mUpgrade failed for $IP.\033[0m"
    fi
}

# Function to autoremove the system
autoremove_system() {
    IP="$1"
    echo "SSH is accessible on $IP. Proceeding with Autoremove..."
    echo "Autoremoving $IP..."
    # Try to SSH into the machine and run the upgrade command
    sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no "$USERNAME@$IP" "echo '$PASSWORD' | sudo -S apt-get autoremove -y" > "${IP}" 2>&1

    # Check if the autoremove was successful and print a message
    if [ $? -eq 0 ]; then
        echo -e "\033[1;32mAutoremove successful for $IP.\033[0m"
    else
        echo -e "\033[1;31mAutoremove failed for $IP.\033[0m"
    fi
}
# Loop through each IP address in the subnet and perform the selected action
while true; do
    echo "Please choose an option:"
    echo "1. Update"
    echo "2. Upgrade"
    echo "3. Autoremove"
    echo "4. Get Serial Numbers (SN)"
    echo "5. Exit"
    read -p "Option: " OPTION

    case $OPTION in
        1)
            for ((i=1;i<=1024;i++)); do
                IP="$SUBNET.$i"

                # Check if the IP address is in the subnet
                if [[ "$(sipcalc $IP $NETMASK | grep -c 'Network address')" == "1" ]] || [[ "$(sipcalc $IP $NETMASK | grep -c 'Broadcast address')" == "1" ]]; then
                    continue
                fi

                echo "Checking SSH on $IP..."

                # Check if SSH is accessible on the IP address
                if check_ssh "$IP"; then
                    update_system "$IP"
                else
                    echo "SSH is not accessible on $IP. Skipping..."
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

                echo "Checking SSH on $IP..."

                # Check if SSH is accessible on the IP address
                if check_ssh "$IP"; then
                    upgrade_system "$IP"
                else
                    echo "SSH is not accessible on $IP. Skipping..."
                fi
            done
            ;;
        3)
            for ((i=1;i<=1024;i++)); do
                IP="$SUBNET.$i"

                # Check if the IP address is in the subnet
                if [[ "$(sipcalc $IP $NETMASK | grep -c 'Network address')" == "1" ]] || [[ "$(sipcalc $IP $NETMASK | grep -c 'Broadcast address')" == "1" ]]; then
                    continue
                fi

                echo "Checking SSH on $IP..."

                # Check if SSH is accessible on the IP address
                if check_ssh "$IP"; then
                    echo "SSH is accessible on $IP. Proceeding with autoremove..."
                    echo "Autoremoving $IP..."
                    # Try to SSH into the machine and run the autoremove command
                    sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no "$USERNAME@$IP" "echo '$PASSWORD' | sudo -S apt-get autoremove -y" > "${IP}_autoremove_report.txt" 2>&1

                    # Check if the autoremove was successful and print a message
                    if [ $? -eq 0 ]; then
                        echo -e "\033[1;32mAutoremove successful for $IP.\033[0m"
                    else
                        echo -e "\033[1;31mAutoremove failed for $IP.\033[0m"
                    fi
                else
                    echo "SSH is not accessible on $IP. Skipping..."
                fi
            done
            ;;
        4)
            # The name txt of hosts
            hosts_file="hosts.txt"

            # The name of the Excel file to save the data
            excel_file="hosts.xlsx"

            # Delete the old Excel file if it exists
            if [ -f "/home/smith/Desktop/scripts/SN/excel_save/$excel_file" ]; then
                rm "/home/smith/Desktop/scripts/SN/excel_save/$excel_file"
            fi

            # Create the new Excel file and insert the headers in the first row
            touch "/home/smith/Desktop/scripts/SN/excel_save/$excel_file"
            echo -e "IP\tHostname\tSerial Number" >> "/home/smith/Desktop/scripts/SN/excel_save/$excel_file"

            # Iterate for each host in the file
            while read -r host; do
                # Check if SSH is accessible on the IP address
                if check_ssh "$host"; then
                    echo "SSH is accessible on $host. Proceeding with getting serial number..."

                    # Connect to the host via SSH and retrieve the serial number
                    serial=$(sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no "$USERNAME@$host" "echo \$PASSWORD | lsblk --nodeps -o name,serial | grep sda | awk '{print \$NF}'")

                    # Add the host data to the Excel file
                    echo -e "$host\t$(sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no "$USERNAME@$host" "hostname")\t$serial" >> "/home/smith/Desktop/scripts/SN/excel_save/$excel_file"
                    echo "Successfully retrieved serial number for $host."
                else
                    echo "SSH is not accessible on $host. Skipping..."
                fi
            done < "/home/smith/Desktop/scripts/SN/excel_save/$hosts_file"

            echo "Completed retrieving serial numbers for all hosts."
            ;;
        5)
            exit
            ;;
        *)
            echo "Invalid option. Please choose again."
            ;;
    esac
done
