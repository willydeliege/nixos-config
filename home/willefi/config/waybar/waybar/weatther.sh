#!/bin/bash

LOCATION="Montegnée"  # Replace with your city
WEATHER_JSON=$(curl -s "wttr.in/${LOCATION}?format=j1" 2>/dev/null)

if [ $? -ne 0 ]; then
    echo '{"text": " Weather Unavailable", "tooltip": "Unable to fetch weather data"}'
    exit 0
fi

# Current condition
temp=$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].temp_C')
feels_like=$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].FeelsLikeC')
condition=$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].weatherDesc[0].value')
humidity=$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].humidity')
wind=$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].windspeedKmph')

# Choose icon
case "${condition,,}" in
    *sun*|*clear*) icon="";;
    *cloud*) icon="";;
    *rain*|*drizzle*) icon="";;
    *snow*) icon="";;
    *fog*|*mist*) icon="";;
    *thunder*) icon="";;
    *) icon="";;
esac

# Build 3-day forecast tooltip
tooltip="<b>Weather for ${LOCATION}</b>\n"
tooltip+="Current: ${temp}°C (Feels like ${feels_like}°C), ${condition}\n"
tooltip+="Humidity: ${humidity}%, Wind: ${wind} km/h\n\n"
tooltip+="<b>3-Day Forecast:</b>\n"

for i in 0 1 2; do
    date=$(echo "$WEATHER_JSON" | jq -r ".weather[$i].date")
    max_temp=$(echo "$WEATHER_JSON" | jq -r ".weather[$i].maxtempC")
    min_temp=$(echo "$WEATHER_JSON" | jq -r ".weather[$i].mintempC")
    day_condition=$(echo "$WEATHER_JSON" | jq -r ".weather[$i].hourly[0].weatherDesc[0].value")

    tooltip+="${date}: ${min_temp}°C - ${max_temp}°C, ${day_condition}\n"
done

# Output for Waybar
echo "{\"text\": \"${icon} ${temp}°C\", \"tooltip\": \"${tooltip}\"}"
