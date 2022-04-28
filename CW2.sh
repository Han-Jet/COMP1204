#!/bin/bash

html=$(curl --silent https://covidnow.moh.gov.my/)
echo "HTML: $html"

clean_code() {
	echo "$html" | grep "$1" -A1 | cut -d ">" -f 1 | sed -n 2p | xargs | sed 's/[+]//g'
}

clean_code '<span class="font-bold text-xl lg:text-2xl" data-v-1e2a93af data-v-91d5f596>'

clean_code '<span data-v-1e2a93af data-v-3ab42af2>Daily - Cases</span>'

clean_code '<span data-v-1e2a93af data-v-3ab42af2>Daily - Tests</span>'

clean_code '<span data-v-1e2a93af data-v-3ab42af2>Positivity Rate</span>'

e=$(echo "$html" | grep "Deaths due to COVID" -A2 | tail -n 1 | xargs)
echo "$e" | sed 's/[+]//g'

clean_code '<span data-v-1e2a93af data-v-3ab42af2>Active - ICU</span>'
