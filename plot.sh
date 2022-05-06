#!/bin/bash

shm="/dev/shm/"
cases_file="${shm}case.txt"
death_file="${shm}death.txt"
vax_file="${shm}vaccine.txt"
health="${shm}healthcare.txt"

cases_data=$(/opt/lampp/bin/mysql -u root -e "use covidnow; select * from cases;")
echo "# $cases_data" > $cases_file
#cat $cases_file

gnuplot << EOF

set title "Graph for daily cases"
set xlabel "Date"
set ylabel "Cases"
set xtics 24*60*60
set xdata time
set timefmt '%d %B %Y'  #time format in the .dat file
set format x '%d/%m'    #the time format to be displayed in the graph
set terminal png font 'Barlow'
set terminal png size 2160,1080
set style line 1 linecolor rgb "#FF8000"
set output "$HOME/cases.png" #show the graph in .png format 
plot "$cases_file" using 2:5 with lines title "Daily Cases" linestyle 1 

EOF

rm $cases_file
