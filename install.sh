#!/bin/bash
apt update
apt install lm-sensors -y

cat <<'EOF' > /etc/zabbix/zabbix_agentd.d/temperature.conf
UserParameter=pve-t-cpu.min,sensors | grep Core | awk -F'[:+°]' '{if(min==""){min=$3}; if($3<min) {min=$3};} END {print min}'
UserParameter=pve-t-cpu.max,sensors | grep Core | awk -F'[:+°]' '{if(max==""){max=$3}; if(max<$3) {max=$3};} END {print max}'
UserParameter=pve-t-cpu.average,sensors | grep Core | awk -F'[:+°]' '{avg+=$3}END{print avg/NR}'
EOF

systemctl restart zabbix-agent.service
