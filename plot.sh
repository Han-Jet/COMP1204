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
set xdata time; set timefmt '%d %B %Y'; set format x '%d/%m'
set terminal png size 1920,1080
set output "$HOME/cases.png"
plot "$cases_file" using 2:5 with lines notitle

EOF

rm $cases_file
