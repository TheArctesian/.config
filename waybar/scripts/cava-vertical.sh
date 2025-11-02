#!/usr/bin/env bash
# Compact cava audio visualizer for Waybar sidebar

bar="▁▂▃▄▅▆▇█"
dict="s/;//g;"

# creating "dictionary" to replace char with bar
i=0
while [ $i -lt ${#bar} ]
do
    dict="${dict}s/$i/${bar:$i:1}/g;"
    i=$((i=i+1))
done

# write cava config for compact display
config_file="/tmp/waybar_cava_vertical_config"
echo "
[general]
bars = 3

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
" > $config_file

# read stdout from cava and format horizontally (bars side by side)
cava -p $config_file | while read -r line; do
    echo $line | sed $dict
done
