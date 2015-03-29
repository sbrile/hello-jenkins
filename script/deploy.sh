#!/bin/sh
 
ssh bitnami@52.4.104.177 <<EOF
  cd ~/hello-jenkins
  git pull
  npm install --production
  forever restartall
  exit
EOF