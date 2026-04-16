import Foundation

final class CitySearchService: CitySearchServiceProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func searchCities(query: String) async throws -> [City] {
        let endpoint = Endpoint(
            baseURL: Constants.API.geocodingBaseURL,
            path: "/v1/search",
            queryItems: [
                URLQueryItem(name: "name", value: query),
                URLQueryItem(name: "count", value: "10"),
                URLQueryItem(name: "language", value: "en"),
                URLQueryItem(name: "format", value: "json")
            ]
        )

        let response: CitySearchResponseDTO = try await apiClient.request(endpoint)

        return response.results?.map {
            City(
                id: $0.id,
                name: $0.name,
                latitude: $0.latitude,
                longitude: $0.longitude,
                country: $0.country
            )
        } ?? []
    }
}
