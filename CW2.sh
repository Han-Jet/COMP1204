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
echo "$positiveRate"
dailyDeath=$(echo "$html" | grep "Deaths due to COVID" -A2 | tail -n 1 | xargs)
echo "$dailyDeath" | sed 's/[+%]//g'
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Active - ICU</span>' 1
activeICU=$tempCode
echo "$activeICU"
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Total - Cases</span>' 1
totalCase=$tempCode
echo "$totalCase"
clean_code '<div title="Wed Apr 27 2022 15:59:00 GMT+0000 (Coordinated Universal Time)" class="col-span-1 text-xs text-gray-500 text-right tracking-tighter leading-3" data-v-1e2a93af>' 2
date=$tempCode
echo "$date"
