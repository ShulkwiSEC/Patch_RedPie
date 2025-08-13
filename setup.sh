#!/bin/bash
set -e

useradd -m redpie

git clone https://github.com/ShulkwiSEC/RedPie.git /home/redpie/RedPie

pip3 install -r /home/redpie/RedPie/requirement.txt
python3 -m playwright install
python3 -m playwright install-deps

chown -R root:root /home/redpie/RedPie
chmod -R 750 /home/redpie/RedPie

echo 'redpie ALL=(ALL) NOPASSWD: /app/redpie.sh' >> /etc/sudoers
