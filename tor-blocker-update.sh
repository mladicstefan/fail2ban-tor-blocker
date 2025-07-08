#!/bin/bash
# Script to download and block Tor exit nodes directly with UFW
# place this inside /usr/local/bin/tor-blocker-update.sh

TOR_LIST_URL="https://check.torproject.org/torbulkexitlist"
TOR_LIST_FILE="/tmp/tor-exit-nodes.txt"
LOG_FILE="/var/log/tor-blocker.log"

# Download current Tor exit node list
curl -s "$TOR_LIST_URL" > "$TOR_LIST_FILE"

if [ $? -eq 0 ]; then
    echo "$(date): Downloaded Tor exit node list" >> "$LOG_FILE"
    
    # Read each IP and add to UFW directly
    while IFS= read -r ip; do
        if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
            ufw insert 1 deny from "$ip" 2>/dev/null
        fi
    done < "$TOR_LIST_FILE"
    
    echo "$(date): Applied Tor exit node blocks via UFW" >> "$LOG_FILE"
else
    echo "$(date): Failed to download Tor exit node list" >> "$LOG_FILE"
fi

# Clean up
rm -f "$TOR_LIST_FILE"
