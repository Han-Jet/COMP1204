#!/bin/bash

#curl https://covidnow.moh.gov.my/ > data_v1.html
html=$(curl --silent https://covidnow.moh.gov.my/)
echo "HTML: $html"
a=$($html | grep '<span class="font-bold text-xl lg:text-2xl" data-v-1e2a93af data-v-91d5f596>' -A1 | cut -d ">" -f 1 | sed -n 2p | xargs)
echo "$a"
