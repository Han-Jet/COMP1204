#!/bin/bash

html=$(curl --silent https://covidnow.moh.gov.my/)
echo "HTML: $html"

clean_code() {
	tempCode=$(echo "$html" | grep "$1" -A"$2" | cut -d ">" -f 1 | sed -n 2p | xargs | sed 's/[+,]//g')
	#comma needs to be removed to ensure the figure is an integer
}

clean_code '<span class="font-bold text-xl lg:text-2xl" data-v-1e2a93af data-v-91d5f596>' 1
dailyVaccine=$tempCode
echo "$dailyVaccine"
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Daily - Cases</span>' 1
dailyCases=$tempCode
echo "$dailyCases"
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Daily - Tests</span>' 1
dailyTests=$tempCode
echo "$dailyTests"
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Positivity Rate</span>' 1
positiveRate=$tempCode
echo "$positiveRate" | sed 's/%//g'
dailyDeath=$(echo "$html" | grep "Deaths due to COVID" -A2 | tail -n 1 | xargs)
echo "$dailyDeath" | sed 's/[+]//g'
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Active - ICU</span>' 1
activeICU=$tempCode
echo "$activeICU"
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Utilisation (COVID)</span>' 1
icuUtilisation=$tempCode
echo "$icuUtilisation" | sed 's/%//g'
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Daily - Admissions</span>' 1
dailyHospital=$tempCode
echo "$dailyHospital"
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Total - Cases</span>' 1
totalCase=$tempCode
echo "$totalCase"
date=$(echo "$html" | grep 'Data as of' -A2 | tail -n 2 | head -n 1 | sed 's/[,]//g' | xargs)
echo "$date"
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Total - Deaths</span>' 1
totalDeaths=$tempCode
echo "$totalDeaths"
clean_code '<div class="bg-blue-100 px-2 m-auto">' 1
activeCases=$tempCode
echo "$activeCases"
