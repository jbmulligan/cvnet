#!/bin/bash


# We should check the date on the cookie file and regenerate if too old...

#curl	--cookie-jar cookies.txt			\
#	-X POST						\
#	-d "adminpw=ZLxq5BULVCvi"			\
#	http://nephoscale.ewind.com/mailman/admin/cvnet

curl	-b cookies.txt					\
	http://nephoscale.ewind.com/mailman/private/cvnet/2025-May.txt.gz \
	> archive_data/2025-May.txt 2> curlerrs

