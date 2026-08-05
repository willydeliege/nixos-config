#!/usr/bin/env python3
import json
import requests
import re

def get_weather_icon(condition_code):
    """Convertit le code météo en icône"""
    # Mapping des codes météo wttr.in vers des icônes
    weather_icons = {
        "113": "☀️",  # Ensoleillé
        "116": "⛅",  # Partiellement nuageux
        "119": "☁️",  # Nuageux
        "122": "☁️",  # Très nuageux
        "143": "🌫️",  # Brouillard
        "176": "🌦️",  # Pluie légère
        "179": "🌨️",  # Neige légère
        "182": "🌧️",  # Grésil
        "185": "🌧️",  # Bruine verglaçante
        "200": "⛈️",  # Orages
        "227": "🌨️",  # Tempête de neige
        "230": "❄️",  # Blizzard
        "248": "🌫️",  # Brouillard
        "260": "🌫️",  # Brouillard givrant
        "263": "🌦️",  # Bruine
        "266": "🌧️",  # Bruine légère
        "281": "🌧️",  # Bruine verglaçante
        "284": "🌧️",  # Bruine verglaçante forte
        "293": "🌦️",  # Pluie légère
        "296": "🌧️",  # Pluie légère
        "299": "🌧️",  # Pluie modérée
        "302": "🌧️",  # Pluie modérée
        "305": "🌧️",  # Pluie forte
        "308": "🌧️",  # Pluie très forte
        "311": "🌧️",  # Pluie verglaçante
        "314": "🌧️",  # Pluie verglaçante forte
        "317": "🌨️",  # Grésil
        "320": "🌨️",  # Grésil
        "323": "🌨️",  # Neige légère
        "326": "🌨️",  # Neige légère
        "329": "❄️",  # Neige modérée
        "332": "❄️",  # Neige forte
        "335": "❄️",  # Neige forte
        "338": "❄️",  # Neige très forte
        "350": "🌧️",  # Grêle
        "353": "🌦️",  # Averses légères
        "356": "🌧️",  # Averses modérées
        "359": "🌧️",  # Averses fortes
        "362": "🌨️",  # Averses de grésil
        "365": "🌨️",  # Averses de grésil
        "368": "🌨️",  # Averses de neige légères
        "371": "❄️",  # Averses de neige modérées
        "374": "🌧️",  # Averses de grêle légères
        "377": "🌧️",  # Averses de grêle
        "386": "⛈️",  # Orages légers
        "389": "⛈️",  # Orages modérés
        "392": "⛈️",  # Orages de neige légères
        "395": "⛈️"   # Orages de neige modérées
    }
    return weather_icons.get(condition_code, "❓")

def get_weather_data():
    try:
        # API wttr.in en format JSON
        url = "https://wttr.in/Montegnée?format=j1"
        response = requests.get(url, timeout=10)
        response.raise_for_status()

        data = response.json()

        # Données actuelles
        current = data["current_condition"][0]
        temp_c = current["temp_C"]
        feels_like_c = current["FeelsLikeC"]
        weather_code = current["weatherCode"]
        weather_desc = current["lang_fr"][0]["value"] if "lang_fr" in current else current["weatherDesc"][0]["value"]
        humidity = current["humidity"]
        wind_kmph = current["windspeedKmph"]
        wind_dir = current["winddir16Point"]
        precip_mm = current["precipMM"]

        # Icône météo
        icon = get_weather_icon(weather_code)

        # Prévisions 3 jours
        forecasts = []
        for i in range(min(3, len(data["weather"]))):
            day_data = data["weather"][i]
            date = day_data["date"]
            max_temp = day_data["maxtempC"]
            min_temp = day_data["mintempC"]

            # Prévisions par tranches horaires
            hourly_forecasts = []
            for hour_data in day_data["hourly"]:
                time = hour_data["time"].zfill(4)  # Format HHMM
                time_formatted = f"{time[:2]}:{time[2:]}"
                temp = hour_data["tempC"]
                desc = hour_data["lang_fr"][0]["value"] if "lang_fr" in hour_data else hour_data["weatherDesc"][0]["value"]
                hourly_forecasts.append(f"{time_formatted}: {temp}°C, {desc}")

            forecasts.append({
                "date": date,
                "max_temp": max_temp,
                "min_temp": min_temp,
                "hourly": hourly_forecasts
            })

        # Construction du tooltip
        tooltip_lines = [
            f"🌡️  Température: {temp_c}°C (ressenti {feels_like_c}°C)",
            f"☁️  Conditions: {weather_desc}",
            f"💨 Vent: {wind_kmph} km/h {wind_dir}",
            f"💧 Humidité: {humidity}%",
            f"🌧️  Précipitations: {precip_mm} mm",
            "",
            "📅 Prévisions 3 jours:"
        ]

        for forecast in forecasts:
            tooltip_lines.append(f"\n📆 {forecast['date']}: {forecast['min_temp']}°C - {forecast['max_temp']}°C")
            for hourly in forecast['hourly']:
                tooltip_lines.append(f"   {hourly}")

        tooltip = "\n".join(tooltip_lines)

        # Texte affiché dans la barre
        text = f"{icon} {temp_c}°C"

        return {
            "text": text,
            "tooltip": tooltip,
            "class": "weather"
        }

    except requests.RequestException as e:
        return {
            "text": "❌ Météo indisponible",
            "tooltip": f"Erreur de connexion: {str(e)}",
            "class": "weather-error"
        }
    except (KeyError, IndexError, ValueError) as e:
        return {
            "text": "❌ Erreur données",
            "tooltip": f"Erreur de parsing: {str(e)}",
            "class": "weather-error"
        }
    except Exception as e:
        return {
            "text": "❌ Erreur",
            "tooltip": f"Erreur inconnue: {str(e)}",
            "class": "weather-error"
        }

if __name__ == "__main__":
    weather_data = get_weather_data()
    print(json.dumps(weather_data))
