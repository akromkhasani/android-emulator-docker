#!/bin/bash

G='\033[0;32m'
YE='\033[1;33m'
NC='\033[0m' # No Color

function start_appium () {
    printf "${G}==>  ${YE}Instance will run on port 4723 ${G}<==${NC}""\n"
    sleep 0.5
    appium
};

start_appium
