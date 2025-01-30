#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'
send_email() {
  SUBJECT="System Monitoring Alert - $(date)"
  EMAIL="mariaabadir24@gmail.com"
  BODY="System usage alert: $1"

  echo "$BODY" | mail -s "$SUBJECT" "$EMAIL"
}

echo "System Monitoring Report"
date
echo "=========================================="

echo "Disk Usage:"
diskUsage=$(/usr/bin/df -h | grep '/dev/sda3' | awk '{print $5}')
diskUsage=${diskUsage%\%}

if [ $diskUsage -gt 19 ]
then
  /usr/bin/df -h | grep 'Filesystem'
  /usr/bin/df -h | grep '/dev/sda3'
  send_email "Warning: Disk usage has exceeded 19%. Current usage: ${diskUsage}%."
  echo -e "${RED}Warning: /dev/sda3 is above 19% usage!${NC}"
else
  /usr/bin/df -h | grep 'Filesystem'
  /usr/bin/df -h | grep '/dev/sda3'
fi

echo
echo "CPU Usage:"
/usr/bin/top -bn1 | grep "Cpu(s)" | awk '{print "current CPU used: "100 - $8"%"}'

echo
echo "Memory Usage:"
/usr/bin/free -h | grep "Mem" | awk '{print "Total Memory: "$2}'
/usr/bin/free -h | grep "Mem" | awk '{print "Used Memory: "$3}'
/usr/bin/free -h | grep "Mem" | awk '{print "Free Memory: "$4}'

echo
echo "Top 5 Memory-Consuming Processes:"
ps -eo pid,user,%mem,comm --sort=-%mem | head -n 6

