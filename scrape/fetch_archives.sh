#!/bin/bash


# We should check the date on the cookie file and regenerate if too old...

#curl	--cookie-jar cookies.txt			\
#	-X POST						\
#	-d "adminpw=ZLxq5BULVCvi"			\
#	http://nephoscale.ewind.com/mailman/admin/cvnet

if [[ -e curlerrs ]]; then
  echo Removing old error file...
  rm curlerrs
fi

fetch_one_month(){
	m=$1
	y=$2
	echo Fetching $m $y ...
	src=http://nephoscale.ewind.com/mailman/private/cvnet/$y-$m.txt.gz
	curl	-b cookies.txt	$src			\
		> archive_data/$y-$m.txt 2>> curlerrs
}

for year in 2018 2020 2021 2022 2023 2024
do
  for month in January February March April May June July August September October November December
  do
    fetch_one_month $month $year
  done
done

for year in 2019
do
  for month in January February March April May June October November December
  do
    fetch_one_month $month $year
  done
done

for year in 2017
do
  for month in October November December
  do
    fetch_one_month $month $year
  done
done

for year in 2025
do
  for month in January February March April May
  do
    fetch_one_month $month $year
  done
done

