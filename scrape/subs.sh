#!/bin/bash

#curl	--cookie-jar cookies.txt			\
#	-X POST						\
#	-d "adminpw=ZLxq5BULVCvi"			\
#	http://nephoscale.ewind.com/mailman/admin/cvnet

curl	-b cookies.txt					\
	'http://nephoscale.ewind.com/mailman/admin/cvnet/members?letter=a&chunk=1' \
	> curlout.html 2> curlerrs

