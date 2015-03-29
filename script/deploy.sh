#!/bin/sh
 
ssh bitnami@52.4.104.177 <<EOF
  cd ~/hello-jenkins
  git checkout $commit_id .
  npm install --production
  forever restartall
  exit
EOF