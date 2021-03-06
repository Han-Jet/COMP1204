#!/bin/bash

shm="/dev/shm/"
cases_file="${shm}case.txt"
death_file="${shm}death.txt"
vax_file="${shm}vaccine.txt"
health="${shm}healthcare.txt"

death_data=$(/opt/lampp/bin/mysql -u root -e "use covidnow; select * from death;")
echo "# $death_data" > $death_file
#cat $death_file

gnuplot << EOF

set title "Graph for daily death"
set xlabel "Date"
set ylabel "Death"
set xtics 24*60*60
set xdata time
set timefmt '%d %B %Y'  #time format in .dat file
set format x '%d/%m'    #the time format to be displayed in the graph
set terminal png font 'Barlow'
set terminal png size 2160,1080
set style line 1 linecolor rgb "#FF8000"
set style line 2 linecolor rgb "#3333FF"
set output "$HOME/death.png" #show the graph in .png format 
plot "$death_file" using 2:5 with lines title "Daily Death" linestyle 1, "$death_file" using 2:7 with lines title "Daily Brought in Dead" linestyle 2

EOF

rm $death_file
