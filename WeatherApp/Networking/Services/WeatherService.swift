import Foundation

final class WeatherService: WeatherServiceProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherResponseDTO {
        let endpoint = Endpoint(
            baseURL: Constants.API.weatherBaseURL,
            path: "/v1/forecast",
            queryItems: [
                URLQueryItem(name: "latitude", value: "\(latitude)"),
                URLQueryItem(name: "longitude", value: "\(longitude)"),
                URLQueryItem(name: "current", value: "temperature_2m,wind_speed_10m,weather_code"),
                URLQueryItem(name: "hourly", value: "temperature_2m"),
                URLQueryItem(name: "daily", value: "temperature_2m_max,temperature_2m_min"),
                URLQueryItem(name: "timezone", value: "auto")
            ]
        )

        let response: WeatherResponseDTO = try await apiClient.request(endpoint)
        return response
    }
}
