#!/bin/bash

html=$(curl --silent https://covidnow.moh.gov.my/)
echo "HTML: $html"

clean_code() {
	tempCode=$(echo "$html" | grep "$1" -A1 | cut -d ">" -f 1 | sed -n 2p | xargs | sed 's/[+,]//g')
	#comma needs to be removed to ensure the figure is an integer
}

clean_code '<span class="font-bold text-xl lg:text-2xl" data-v-1e2a93af data-v-91d5f596>'
dailyVaccine=$tempCode
echo "$dailyVaccine"
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Daily - Cases</span>'
dailyCases=$tempCode
echo "$dailyCases"
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Daily - Tests</span>'
dailyTests=$tempCode
echo "$dailyTests"
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Positivity Rate</span>'
positiveRate=$tempCode
echo "$positiveRate"
dailyDeath=$(echo "$html" | grep "Deaths due to COVID" -A2 | tail -n 1 | xargs)
echo "$dailyDeath" | sed 's/[+]//g'
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Active - ICU</span>'
activeICU=$tempCode
echo "$activeICU"
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Total - Cases</span>'
totalCase=$tempCode
echo "$totalCase"
