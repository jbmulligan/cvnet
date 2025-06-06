#!/bin/bash

#curl	--cookie-jar cookies.txt			\
#	-X POST						\
#	-d "adminpw=ZLxq5BULVCvi"			\
#	http://nephoscale.ewind.com/mailman/admin/cvnet

if [[ -e curlerrs ]]; then
  echo Removing old error file ...
  rm curlerrs
fi

if [[ ! -e scratch ]]; then
  mkdir scratch
fi

options_file=scratch/tmp_options
html_file=scratch/tmp_html
prev_html_file=scratch/prev_html
email_addrs_file=scratch/email_addrs
subscriber_file=scratch/subscribers
tmp_data=scratch/tmp_data
realname_data=scratch/realname

cat < /dev/null > $subscriber_file

# How do we know how many chunks there are???

fetch_one_chunk(){
	ltr=$1
	chunk=$2
	url="http://nephoscale.ewind.com/mailman/admin/cvnet/members"
	src="$url?letter=$ltr&chunk=$chunk"
	curl	-b cookies.txt	$src > $html_file 2>> curlerrs
}

#		| awk -F _ '{print $1}'			\

scrape_emails(){
	grep CHECKBOX $html_file			\
		| grep CHECKED				\
		| awk -F '"' '{print $2}'		\
		| sed -e 's/%40/@/'			\
		| sed -e 's/_[a-z]*$//'			\
		| uniq					\
		> $email_addrs_file

	addrs=(`cat $email_addrs_file`)

	for addr in ${addrs[@]}
	do
		process_one $addr
	done
}

process_one(){
	a=$1
	grep CHECKBOX $html_file			\
		| grep CHECKED				\
		| awk -F '"' '{print $2}'		\
		| sed -e 's/%40/@/'			\
		| grep $a				\
		> $tmp_data
	cat $tmp_data					\
		| awk -F @ '{print $2}'			\
		| awk -F _ '{print $2}'			\
		> $options_file
	options=(`cat $options_file`)
	# realname is tricky...
	grep realname $html_file			\
		| sed -e 's/%40/@/'			\
		| grep $a				\
		| awk -F 'value=' '{print $2}'		\
		| awk -F '"' '{print $2}'		\
		> $realname_data

	n_words=`cat $realname_data | wc -w`
	if [[ $n_words -ne 0 ]]; then
		realname=`cat $realname_data`
		echo Address $a has real name "'$realname'"
		options=( ${options[@]} realname \"$realname\" )
	fi
	echo $a ${options[@]}	>> $subscriber_file
}

process_letter(){
	letter=$1
	idx=1
	if [[ -e $prev_html_file ]]; then
		rm $prev_html_file
	fi
	while [[ true ]]; do
		fetch_one_chunk $letter $idx
		if [[ $idx -gt 1 ]]; then
			# The only way that we can detect an invalid chunk index
			# is that we get the same data as last time
			cmp $html_file $prev_html_file > /dev/null
			if [[ $? -eq 0 ]]; then
				idx=$((idx-1))
				echo processed $idx chunks for letter $letter
				return
			fi
		fi
		scrape_emails
		cp $html_file $prev_html_file
		idx=$((idx+1))
	done
}

for l in 0 1 3 a b c d e f g h i j k l m n o p q r s t u v w x y z
do
	process_letter $l
done



