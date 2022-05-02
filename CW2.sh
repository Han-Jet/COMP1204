#!/bin/bash

html=$(curl --silent https://covidnow.moh.gov.my/)
#echo "HTML: $html"

clean_code() {
	tempCode=$(echo "$html" | grep "$1" -A"$2" | cut -d ">" -f 1 | sed -n 2p | xargs | sed 's/[+,]//g')
	#comma needs to be removed to ensure the figure is an integer
}

clean_code '<span class="font-bold text-xl lg:text-2xl" data-v-1e2a93af data-v-91d5f596>' 1
dailyVaccine=$tempCode
echo "dailyVaccine: $dailyVaccine"
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Daily - Cases</span>' 1
dailyCases=$tempCode
echo "dailyCases: $dailyCases"
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Daily - Tests</span>' 1
dailyTests=$tempCode
echo "dailyTests: $dailyTests"
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Positivity Rate</span>' 1
positiveRate=$(echo "$tempCode" | sed 's/%//g')
echo "positiveRate: $positiveRate"
dailyDeath=$(echo "$html" | grep "Deaths due to COVID" -A2 | tail -n 1 | xargs)
echo "dailyDeath: $dailyDeath" | sed 's/[+]//g'
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Active - ICU</span>' 1
activeICU=$tempCode
echo "activeICU: $activeICU"
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Total - Cases</span>' 1
totalCase=$tempCode
echo "totalCase: $totalCase"
date=$(echo "$html" | grep 'Data as of' -A2 | tail -n 2 | head -n 1 | sed 's/[,]//g' | xargs)
echo "date: $date"
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Total - Deaths</span>' 1
totalDeaths=$tempCode
echo "totalDeaths: $totalDeaths"
clean_code '<div class="bg-blue-100 px-2 m-auto">' 1
activeCases=$tempCode
echo "activeCases: $activeCases"
dailyHospital=$(echo "$html" | grep "Daily - Admissions" -A2 | tail -n 1 | xargs)
echo "dailyHospital: $dailyHospital"
activeVent=$(echo "$html" | grep "COVID-19 Patients Ventilated" -A4 | tail -n 1 | xargs)
echo "activeVent: $activeVent"
dailyBid=$(echo "$html" | grep "Brought in Dead" -A8 | tail -n 1 | xargs)
echo "dailyBid: $dailyBid" | sed 's/[+]//g'
totalBid=$(echo "$html" | grep "Brought in Dead" -A4 | tail -n 1 | xargs)
echo "totalBid: $totalBid" | sed 's/[,]//g'
totalVaccine=$(echo "$html" | grep "Total - Administered" -A2 | tail -n 1 | xargs)
echo "totalVaccine: $totalVaccine" | sed 's/[,]//g'
clean_code '<span class="leading-4" data-v-1e2a93af data-v-91d5f596>At Least 1 Dose</span>' 1
firstDose=$tempCode
echo "firstDose: $firstDose" | sed 's/%//g'
clean_code '<span class="leading-4" data-v-1e2a93af data-v-91d5f596>2 Doses</span>' 1
secondDose=$tempCode
echo "secondDose: $secondDose" | sed 's/%//g'
clean_code '<span class="leading-4" data-v-1e2a93af data-v-91d5f596>Booster</span>' 1
booster=$tempCode
echo "booster: $booster" | sed 's/%//g'
#Create table script
db="covidnow"
table1="cases"
table2="vaccination"
table3="healthcare"
table4="death"

/opt/lampp/bin/mysql -u root -e "\
	CREATE DATABASE IF NOT EXISTS $db;\
	USE $db;\
	CREATE TABLE IF NOT EXISTS $table1 (\
		case_id int NOT NULL AUTO_INCREMENT,\
		date varchar(20),\
		new_cases int,\
		total_cases int,\
		daily_tests int,\
		positivity_rate decimal(10,2),\
		active_cases int,\
		updated_time datetime,\
		PRIMARY KEY (case_id)\
	);\
	
	CREATE TABLE IF NOT EXISTS $table2 (\
		vac_id int NOT NULL AUTO_INCREMENT,\
		date varchar(20),\
		daily_administered int,\
		total_administered int,\
		first_dose decimal(10,2),\
		two_doses decimal(10,2),\
		booster decimal(10,2),\
		updated_time datetime,\
		PRIMARY KEY (vac_id)\
	);\
	
	CREATE TABLE IF NOT EXISTS $table3 (\
		health_id int NOT NULL AUTO_INCREMENT,\
		date varchar(20),\
		active_ventilators int,\
		active_icu int,\
		dailyhosp_admission int,\
		updated_time datetime,\
		PRIMARY KEY (health_id)\
	);\
		
	CREATE TABLE IF NOT EXISTS $table4 (\
		death_id int NOT NULL AUTO_INCREMENT,\
		date varchar(20),\
		daily_death int,\
		total_death int,\
		dail_bid int,\
		total_bid int,\
		updated_time datetime,\
		PRIMARY KEY (death_id)\
	);\
	
	INSERT INTO $table1 (date, new_cases, total_cases, daily_tests, positivity_rate, active_cases, updated_time)
	VALUES ('$date', $dailyCases, $totalCase, $dailyTests, '$positiveRate', $activeCases, NOW());\
	
	INSERT INTO $table3 (date, active_ventilators, active_icu, dailyhosp_admission, updated_time)
	VALUES ('$date', $activeVent, $activeICU, $dailyHospital, NOW());\
	
	SELECT * FROM $table1;\
	SELECT * FROM $table2;\
	SELECT * FROM $table3;\
	SELECT * FROM $table4;\
"
