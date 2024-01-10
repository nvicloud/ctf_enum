#!/bin/bash

# 
#
#
# Date: 2024-01-08
# Version: 2.0
#
# $(date +'%Y_%b_%d_%H:%M:%S')
# 

###############################################################################
# BEGIN 'SecLists Discovery/Installation'
###############################################################################
(>&2 echo '*** SecLists Discovery/Installation *** ')


# Determine if and install SecLists in the desired directory
sec_lists_dir=$(find /usr/share/ -type d -name SecLists 2> /dev/null)

if [ -n "$sec_lists_dir" ]; then
    echo "SecLists directory found at: $sec_lists_dir"
else
    echo "SecLists directory not found. Cloning from GitHub..."
    git clone https://github.com/danielmiessler/SecLists.git /usr/share/wordlists/SecLists
    echo "Cloning complete."
fi

###############################################################################
# BEGIN 'Enable and start PostgreSQL'
###############################################################################
(>&2 echo '*** Enable and start PostgreSQL for MSF *** ')

systemctl enable postgresql --now 
msfdb init

###############################################################################
# BEGIN 'Scanning and Enumeration Tools'
###############################################################################
(>&2 echo '*** Scanning and Enumeration Tools *** ')

git clone https://github.com/nvicloud/ctf_enum /home/htb-*/Desktop
tar -xvf /home/htb-*/Desktop/ctf_enum/ctf_lin.tgz -C /home/htb-*/Desktop/ctf_enum
# rm -f /home/htb-*/Desktop/ctf_enum/ctf_lin.tgz

###############################################################################
# BEGIN 'Software'
###############################################################################
(>&2 echo '*** Additional Software *** ')

# Check if whatweb is installed
if ! which whatweb >/dev/null; then
    echo "whatweb is not installed. Installing..."
    sudo apt update && sudo apt install -y whatweb
else
    echo "whatweb is already installed."
fi

# Check if whatweb is installed
if ! which hash-identifier >/dev/null; then
    echo "hash-identifier is not installed. Installing..."
    sudo apt install -y hash-identifier
else
    echo "hash-identifier is already installed."
fi

crackmapexec || cme
echo "Go Version -" $(go version)
echo "Gobuster" $(gobuster version)

###############################################################################
# BEGIN 'Download Desired Platform Tools'
###############################################################################
(>&2 echo '*** Download Desired Platform Tools *** ')

linux_tools{
    mkdir -p /home/htb-*/Desktop/linux
    git clone https://github.com/nvicloud/ctf_lin /home/htb-*/Desktop/linux
    tar -xvf /home/htb-*/Desktop/linux/ctf_lin/ctf_lin.tgz -C /home/htb-*/Desktop/linux
    # rm -rf /home/htb-*/Desktop/linux/ctf_lin
}

windows_tools{
    mkdir -p /home/htb-*/Desktop/windows
    git clone https://github.com/nvicloud/ctf_win /home/htb-*/Desktop/windows
    tar -xvf /home/htb-*/Desktop/windows/ctf_win/ctf_win.tgz -C /home/htb-*/Desktop/windows
    # rm -rf /home/htb-*/Desktop/windows/ctf_win
}

tput cup 3 12; echo "Installation Type"
tput cup 4 12; echo "================="
tput cup 6 9; echo "1 - Linux Tools"
tput cup 7 9; echo "2 - Windows Tools"
#tput cup 8 9; echo "3 - ___"
tput cup 9 9; echo "Q - Other "
tput cup 10 9;
tput cup 10 19;
read choice || continue
case $choice in
        "1")
                linux_tools
                cd ~/Desktop && ln -s /usr/share/wordlists/rockyou.txt rockyou.txt
                ;;
        "2")
                windows_tools
                cd ~/Desktop && ln -s /usr/share/wordlists/rockyou.txt rockyou.txt
                ;;
#       "3")
#               ;;
        [QqEe])
                exit ;;
*) tput cup 14 4; echo "Invalid Code"; read choice ;;
esac
