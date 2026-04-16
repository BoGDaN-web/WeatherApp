import Foundation

struct WeatherData: Hashable {
    let city: City
    let current: CurrentWeather
    let hourly: [HourlyForecast]
    let daily: [DailyForecast]
}
