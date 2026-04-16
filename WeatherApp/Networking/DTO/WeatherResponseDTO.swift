import Foundation

struct WeatherResponseDTO: Decodable {
    let current: CurrentDTO
    let hourly: HourlyDTO
    let daily: DailyDTO

    struct CurrentDTO: Decodable {
        let temperature2m: Double
        let windSpeed10m: Double
        let weatherCode: Int

        enum CodingKeys: String, CodingKey {
            case temperature2m = "temperature_2m"
            case windSpeed10m = "wind_speed_10m"
            case weatherCode = "weather_code"
        }
    }

    struct HourlyDTO: Decodable {
        let time: [String]
        let temperature2m: [Double]

        enum CodingKeys: String, CodingKey {
            case time
            case temperature2m = "temperature_2m"
        }
    }

    struct DailyDTO: Decodable {
        let time: [String]
        let temperature2mMax: [Double]
        let temperature2mMin: [Double]

        enum CodingKeys: String, CodingKey {
            case time
            case temperature2mMax = "temperature_2m_max"
            case temperature2mMin = "temperature_2m_min"
        }
    }
}
