#!/bin/bash

BL='\033[0;34m'
G='\033[0;32m'
RED='\033[0;31m'
YE='\033[1;33m'
NC='\033[0m' # No Color

function wait_emulator_to_be_ready() {
  emulator_name=${EMULATOR_NAME}
  emulator -avd "${emulator_name}" -port $EMULATOR_PORT -camera-back none -camera-front none -no-boot-anim -no-audio -gpu off -memory 3072
  printf "${G}==>  ${BL}Emulator has ${YE}${EMULATOR_NAME} ${BL}started in headed mode! ${G}<==${NC}""\n"
}

function disable_animation() {
  adb shell "settings put global window_animation_scale 0.0"
  adb shell "settings put global transition_animation_scale 0.0"
  adb shell "settings put global animator_duration_scale 0.0"
}

wait_emulator_to_be_ready
sleep 1
disable_animation
