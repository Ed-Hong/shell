#!/bin/bash

array[0]="KebabsToGo"
array[1]="Shawarma Press"
array[2]="Grimaldi's"
array[3]="Freshii"
array[4]="Indian Food"
array[5]="Chipotle"
array[6]="Freebirds"
array[7]="Thai Food"
array[8]="Empa Mundo"
array[9]="Cavalli's"
array[10]="Fuzzy's"
array[11]="Torchy's"
array[12]="Firehouse"
array[13]="Bread Zeppelin"
array[14]="Green Gator"

size=${#array[@]}
index=$(($RANDOM % $size))
echo ${array[$index]}
