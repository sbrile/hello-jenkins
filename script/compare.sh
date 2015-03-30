#!/bin/bash
rsync -n -crv * bitnami@52.4.104.177:~/hello-jenkins/ > /tmp/diff

    printf "\n"
	printf "\n"
	printf "\n"
	printf "\n"
    printf "${yellow}###################################${reset}\n"
    printf "${yellow}#  FILES THAT ARE BEING DEPLOYED  #\n"
    printf "${yellow}###################################${reset}\n\n"
	
	cat /tmp/diff | grep -v "sending incremental" | grep -v "bytes/sec" | grep -v "DRY RUN"
	
	printf "\n"
	printf "\n"
	printf "\n"
	printf "\n"