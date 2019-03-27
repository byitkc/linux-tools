#!/bin/bash

while true
do
    echo "$1 => $2"
    rclone sync $1 $2 -Pu
    echo "$1 <= $2"
    rclone sync $2 $1 -Pu
    sleep $3
done