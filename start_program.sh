#!/bin/bash

# KoboldCPP Docker Start Script
echo "========================================"
echo "KoboldCPP Containerized"
echo "By Pornpipat Popum <cappy@fyralabs.com>"
echo "========================================"

# check if CONFIG_FILE is set, if yes then load using --config

if [ -n "$CONFIG_FILE" ]; then
    CARGS+=" --config $CONFIG_FILE"
# else check the ARGS environment variable
elif [ -n "$ARGS" ]; then
    CARGS+=" $ARGS"
fi


# now start the program
nvidia-smi
echo "CARGS: $CARGS"

ls -l /config

./koboldcpp.py $CARGS