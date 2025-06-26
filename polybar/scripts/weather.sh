#!/usr/bin/env bash

# Berkeley, CA weather
CITY="Berkeley,CA,USA"

# Get the weather data
get_weather() {
    # Force metric units (Celsius) with proper format for current temperature
    weather_info=$(curl -s "wttr.in/${CITY}?format=%t&m&period=0")
    
    # Check if the curl was successful
    if [ $? -eq 0 ]; then
        echo "$weather_info"
    else
        echo "Weather unavailable"
    fi
}

# Display the weather
get_weather
