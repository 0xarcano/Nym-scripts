#!/bin/bash
systemctl stop nym-node
sleep 2
mkdir ~/bck
backup_name=$(date +%s)
mkdir ~/bck/$backup_name
cp ~/nym-node ~/bck/$backup_name/
rm ~/nym-node
wget -q -O ~/nym-node \
$(wget -q -O - 'https://api.github.com/repos/nymtech/nym/releases/latest' | \
jq -r '.assets[] | select(.name=="nym-node").browser_download_url') 
chmod +x ~/nym-node
cp ~/hashes.json ~/bck/$backup_name/
rm ~/hashes.json
wget -q -O ~/hashes.json \
$(wget -q -O - 'https://api.github.com/repos/nymtech/nym/releases/latest' | \
jq -r '.assets[] | select(.name=="hashes.json").browser_download_url') 
systemctl start nym-node
journalctl -f -u nym-node | grep -i error >> bck/$backup_name/$(date +%M)_error.log &
journalctl -f -u nym-node | grep -i warn >> bck/$backup_name/$(date +%M)_warn.log &
journalctl -f -u nym-node
