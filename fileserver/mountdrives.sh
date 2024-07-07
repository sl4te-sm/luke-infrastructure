#!/bin/bash

sleep 60
mount /dev/sda1 /extdrives/hdd0 || exit
mount /dev/sdc1 /extdrives/hdd1 || exit

mount /dev/sdf1 /extdrives/hdd2
if [ $? -ne 0 ]; then
    mount /dev/sdg1 /extdrives/hdd2
    if [ $? -ne 0 ]; then
        mergerfs -o cache.files=partial,dropcacheonclose=true.category.create=mfs /extdrives/hdd0:/extdrives/hdd1
        exit
    fi
fi

mergerfs -o cache.files=partial,dropcacheonclose=true,category.create=mfs /extdrives/hdd0:/extdrives/hdd1:/extdrives/hdd2
