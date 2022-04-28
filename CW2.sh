#!/bin/bash

#curl https://covidnow.moh.gov.my/ > data_v1.html
html=$(curl --silent https://covidnow.moh.gov.my/)
echo "HTML: $html"

clean_number() {
	tempN=$(echo "$1" | sed 's/[+,]//g')
	#return "$tempN"
}

clean_code() {
	echo "$html" | grep "$1" -A1 | cut -d ">" -f 1 | sed -n 2p | xargs | sed 's/[+,]//g'
}

clean_code '<span class="font-bold text-xl lg:text-2xl" data-v-1e2a93af data-v-91d5f596>'
#a=$(clean_code '<span class="font-bold text-xl lg:text-2xl" data-v-1e2a93af data-v-91d5f596>')
#echo "$a"
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Daily - Cases</span></div>'
b=$(clean_code '<span data-v-1e2a93af data-v-3ab42af2>Daily - Cases</span></div>')
echo "$b"
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Daily - Tests</span>'
c=$(clean_code '<span data-v-1e2a93af data-v-3ab42af2>Daily - Tests</span>')
echo "$c"
clean_code '<span data-v-1e2a93af data-v-3ab42af2>Positivity Rate</span>'
d=$(clean_code '<span data-v-1e2a93af data-v-3ab42af2>Positivity Rate</span>')
echo "$d"
e=$(echo "$html" | grep "Deaths due to COVID" -A2 | tail -n 1 | xargs)
echo "$e" | sed 's/[+]//g'
