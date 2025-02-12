#!/bin/bash

echo "Searching for Invalid User Logins..."
grep "Invalid user" "/var/log/auth.log"

echo "Searching for Repeated Failed Password Attempts..."
grep "Failed password" "/var/log/auth.log"

echo "Counting Failed Password Attempts..."
grep "Failed password" "/var/log/auth.log" | wc -l

echo "Searching for Disconnects from Invalid Users..."
grep "Disconnected from invalid user" "/var/log/auth.log"

echo "Enter suspicious IP to search for (or press Enter to skip):"
read suspicious_ip
if [[ ! -z "$suspicious_ip" ]]; then
    grep "$suspicious_ip" "/var/log/auth.log" | grep "Invalid user"
fi

echo "Checking the Number of Failed Attempts from Each IP..."
grep "Failed password" "/var/log/auth.log" | awk '{print $1, $2, $3, $11}' | sort | uniq -c | sort -n

echo "Searching for logs from the last 24 hours..."
grep "$(date --date='1 day ago' '+%b %d')" "/var/log/auth.log"

echo "Viewing the Last Login for All Users..."
lastlog

echo "Enter username to check for multiple failed login attempts (or press Enter to skip):"
read username
if [[ ! -z "$username" ]]; then
    grep "Invalid user" "/var/log/auth.log" | grep "$username"
fi

echo "Searching for Sudo Commands Used..."
grep "sudo" "/var/log/auth.log"

echo "Detecting IPs with Multiple Invalid User Attempts..."
grep "Invalid user" "/var/log/auth.log" | awk '{print $1, $2, $3, $11}' | sort | uniq -c | sort -nr | head -n 10

echo "Enter IP to block (or press Enter to skip):"
read block_ip
if [[ ! -z "$block_ip" ]]; then
    echo "Blocking IP: $block_ip"
    sudo ufw deny from "$block_ip"
fi

echo "Script execution complete."
