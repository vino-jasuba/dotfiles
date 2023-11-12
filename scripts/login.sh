#!/bin/bash
seed=12
os=$(uname -a | awk '{printf "%s %s", $1, $3}')
memUsed=$(free -m | grep "Mem" | awk '{printf "%.1fG", $3/1000}')
memTotal=$(free -m | grep "Mem" | awk '{printf "%.fG", $2/1000}')
cpuTemp=$(sensors | grep CPU | awk '{print $2}' | sed 's/+//' | tr -d '\n')
loadAvg=$(cat /proc/loadavg | awk '{printf "%s %s %s", $1, $2, $3}')

printf "
  󰕈 $os  $memUsed/$memTotal   $cpuTemp  辰$loadAvg
" | lolcat --truecolor --seed=$seed --spread=6
exit

# Set default output device to HDMI audio
pactl set-default-sink $(pactl list short sinks | cut -f2 | sort | head -n 1)

