#!/bin/bash

SERVER=52.4.104.177
WEBROOT=~/hello_jenkins/
TARFILE=nodejs-backup.$(date +%Y%m%d-%H%M).tar.gz

        printf "${yellow}Backing up code on $SERVER ... ${reset}"
        ssh -l bitnami $SERVER tar cCzf $WEBROOT /tmp/$TARFILE 

        if (( $? == 0 ))
        then
                printf "${green}DONE${reset}\n"
        else
                printf "${red}ERROR${reset}\n"
                exit 1
        fi

printf "\n"

# Check what has changed 
printf "${cyan}Checking code changes${reset}\n"
printf "${yellow}Obtaining last tar backup from $SITE ... ${reset}"

mkdir /tmp/deployed.$$
scp -q bitnami@$SERVER:/tmp/$TARFILE /tmp/deployed.$$

if [[ -f /tmp/deployed.$$/$TARFILE ]]
then
        printf "${green}DONE${reset}\n"
else
        printf "${red}ERROR${reset}\n"
        exit 1
fi

tar -zxf /tmp/deployed.$$/$TARFILE -C /tmp/deployed.$$

LOGFILE="/tmp/deploy-diff-$(date +%Y%m%d-%H%M)"
printf "${yellow}Checking and logging code changes to $LOGFILE ... ${reset}\n"
diff -r . /tmp/deployed.$$ > $LOGFILE

if [[ -f $LOGFILE ]]
then
        printf "${green}DONE${reset}\n"

        (
        printf "\n"
        WC=$(grep -c "^diff|^Binary" $LOGFILE)
        printf "${yellow}changed files ...${reset}\n"
        grep "^diff" $LOGFILE | sed -e "s+diff -r $RELEASEHOME/++" -e "s+ /tmp/deployed.$$.*$++"
        grep "^Binary" $LOGFILE | sed -e "s+Binary files $RELEASEHOME/++" -e "s+ and /tmp/deployed.$$.*$++"
        printf "\n"
        WC=$(grep -c "^Only in $RELEASEHOME/" $LOGFILE)
        printf "${yellow}$WC new files ...${reset}\n"
        grep "^Only in $RELEASEHOME/" $LOGFILE | sed -e "s+Only in /home/git/release/++" -e "s+: +/+"
        printf "\n"
        ) | more
else
        printf "${red}ERROR${reset}\n"
        exit 1
fi

rm -rf /tmp/deployed.$$
printf "\n"
