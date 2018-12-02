#!/bin/bash
# A small Bash script to poll the reading on a GPIO
# to figure if the cat accessed the food or water or litter box
# Here a Zigbee child sends a signal to a Zigbee parent indicating
# if the food box or litter box or water box were accessed.

# Vimp - the code requires root privileges to run well

# folder that has the GPIO settings
GPIO_PATH=/sys/class/gpio

# GPIO number - info
# GPIO66 - food
# GPIO67 - water
# GPIO68 - litter
FOOD_BOWL=66
WATER_BOWL=67
LITTER_BOWL=68

#Sets up the GPIO for food box
echo $FOOD_BOWL > "$GPIO_PATH/export"
echo in > "$GPIO_PATH/gpio$FOOD_BOWL/direction"

#Sets up the GPIO for water box
echo $WATER_BOWL > "$GPIO_PATH/export"
echo in > "$GPIO_PATH/gpio$WATER_BOWL/direction"

#Sets up the GPIO for litter box
echo $LITTER_BOWL > "$GPIO_PATH/export"
echo in > "$GPIO_PATH/gpio$LITTER_BOWL/direction"

apiKey=WWWWQQQQXXXXYYYY # Fill this with the ThingSpeak channel write API key

#In an infinte loop, look for 1(high) on each of the GPIOs
#Send data to thinkspeak when any relevant even happens with timestamp
while true
do  
  echo "Started polling"
  DATE_TIME=`date "+%Y%m%d-%H%M%S"`
  if [ $( cat "$GPIO_PATH/gpio$FOOD_BOWL/value" ) -eq "1" ]; then
    echo "Food"
    update=$(curl --silent --request POST --header "X-THINGSPEAKAPIKEY: $apiKey" --data "field1=$DATE_TIME&field2=1" "http://api.thingspeak.com/update")
  fi

  if [ $( cat "$GPIO_PATH/gpio$WATER_BOWL/value" ) -eq "1" ]; then
    echo "Water"
    update=$(curl --silent --request POST --header "X-THINGSPEAKAPIKEY: $apiKey" --data "field1=$DATE_TIME&field2=2" "http://api.thingspeak.com/update")
  fi

  if [ $( cat "$GPIO_PATH/gpio$LITTER_BOWL/value" ) -eq "1" ]; then
    echo "Litter"
    update=$(curl --silent --request POST --header "X-THINGSPEAKAPIKEY: $apiKey" --data "field1=$DATE_TIME&field2=3" "http://api.thingspeak.com/update")
  fi
done
