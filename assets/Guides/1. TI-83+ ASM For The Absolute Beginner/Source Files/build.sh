#! /bin/bash


#todo - only read in files that end with .asm
clear

rm "bin/"*.lst
rm "bin/"*.8xp

for file in src/*
do
    if [ -f "$file" ]; then 
        temp=${file#*/} 
        echo "Building "$temp
        spasm -E -T -I src/includes ${file} "bin/"${temp%.*}".8xp"
    fi 
done
