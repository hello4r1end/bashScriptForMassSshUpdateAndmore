# Bash Script for System Updates and Inventory

This repository contains a Bash script that helps automate system updates and inventory management for a group of Linux machines within a network. The script allows you to connect via SSH to the network, perform system updates, upgrades, autoremoval of unnecessary packages, retrieve the serial numbers of the hard disks for each computer, and log all actions performed by the script. The script saves the inventory information in an Excel file along with the IP addresses and hostnames of the machines.

## Features

- Update and upgrade: The script connects via SSH to each Linux machine in the network and performs system updates and upgrades using the `apt-get update` and `apt-get upgrade -y` commands.
- Autoremove: Similar to the update feature, the script removes unnecessary packages using the `apt-get autoremove -y` command.
- Inventory management: The script retrieves the serial numbers of the hard disks, IP addresses, and hostnames for each machine and saves this information in an Excel file named `hosts.xlsx`.
- Logging: The script keeps logs of every action performed, including updates, upgrades, autoremoval, and inventory management.
- Excel file management: The script deletes the previous Excel file before creating a new one to ensure that the latest inventory information is saved.

## Prerequisites

Before running the script, make sure you have the following dependencies installed:

- `sipcalc`: A command-line tool for subnet calculations.
- `sshpass`: A utility for non-interactive SSH password authentication.
- Linux machines: The script is designed to work specifically with Linux machines.

## Usage

1. Clone the repository:

```shell
git clone https://github.com/your-username/your-repository.git
Navigate to the cloned directory:
shell
Copy code
cd your-repository
Update the script with your desired subnet, username, and password information:
shell
Copy code
# Define the subnet, username, and password
SUBNET="192.168.10"
NETMASK="192.168.1.0/24"
USERNAME="Put username"
read -s -p "Enter the SSH password: " PASSWORD
Update the name of the Excel file in the script:
shell
Copy code
# The name of the Excel file to save the data
excel_file="hosts.xlsx"
Make the script executable:
shell
Copy code
chmod +x script.sh
Run the script:
shell
Copy code
./script.sh
Follow the on-screen prompts to choose the desired operation.

View the logs:

shell
Copy code
cat logs.txt
License
This project is licensed under the MIT License.

Contributing
Contributions are welcome! If you find any issues or have suggestions for improvements, please create a new issue or submit a pull request.
