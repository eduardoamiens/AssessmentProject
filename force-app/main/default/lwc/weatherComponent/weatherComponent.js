import { LightningElement } from 'lwc'
import getWeatherDetail from'@salesforce/apex/OpenWeatherWS.getWeatherDetail'

export default class WeatherComponent extends LightningElement {
    latitude
    longitude
    weatherData
    error
    loading = false

    temperatur = 43;
    windSpeed = 4.63;
    precipitation = 3;

    connectedCallback() {
        this.getLocation()
    }

    get location() {
        return this.weatherData && this.weatherData.sys ? `Map location: ${this.weatherData.name}, ${this.weatherData.sys.country}` : '';
    }

    get temperature() {
        return this.weatherData && this.weatherData.main ? `${(this.weatherData.main.temp - 273.15).toFixed(1)} °C` : '';
    }

    get humidity() {
        return this.weatherData && this.weatherData.main ? `${this.weatherData.main.humidity}%` : '';
    }

    get weatherDescription() {
        return this.weatherData && this.weatherData.weather ? this.weatherData.weather[0].description : '';
    }

    get windSpeed() {
        return this.weatherData  && this.weatherData.wind ? `${this.weatherData.wind.speed} m/s` : '';
    }

    get sunriseTime() {
        return this.weatherData && this.weatherData.sys ? 'sunriseTime ' + new Date(this.weatherData.sys.sunrise * 1000).toLocaleTimeString() : '';
    }

    get sunsetTime() {
        return this.weatherData && this.weatherData.sys ? 'sunsetTime ' + new Date(this.weatherData.sys.sunset * 1000).toLocaleTimeString() : '';
    }

    get weatherIcon() {
        return this.weatherData && this.weatherData.weather ? `https://openweathermap.org/img/wn/${this.weatherData.weather[0].icon}@2x.png` : '';
    }

    get mapMarkers(){
        return this.latitude && this.longitude ? [
            {
                location: {
                    Latitude: this.latitude,
                    Longitude: this.longitude
                }
            }
        ] : []
    }

    async getLocation() {
        this.loading = true
        if (await navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                position => {
                    this.latitude = position.coords.latitude
                    this.longitude = position.coords.longitude
                    console.log('latitude', this.latitude)
                    console.log('longitude', this.longitude)
                    this.getWeatherDetail()
                },
                error => {
                    this.error = 'Error obteniendo la ubicación: ' + error.message
                }
            )
        } else {
            this.error = 'Geolocalización no es soportada en este navegador.'
        }
        this.loading = false
    }

    async getWeatherDetail(){
        this.weatherData = await getWeatherDetail({latitude: this.latitude, longitude: this.longitude})
        if(this.weatherData){
            this.weatherData = JSON.parse(this.weatherData)
        }
        console.log(this.weatherData)
        console.log('this.weatherData.sys ' + this.weatherData.sys)
        console.log('location() ' + this.location)
        console.log('weatherIcon ' + this.weatherIcon)
    }
}