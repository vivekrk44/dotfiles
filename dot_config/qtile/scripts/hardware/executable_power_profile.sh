#! /usr/bin/env bash
#

CPU=$(system76-power profile | grep Profile | awk '{print $3}')
GPU=$(system76-power graphics)
echo "$CPU | $GPU"
