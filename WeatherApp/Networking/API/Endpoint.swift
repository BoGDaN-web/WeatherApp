import Foundation

struct Endpoint {
    let baseURL: String
    let path: String
    let queryItems: [URLQueryItem]

    var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.path = path
        components?.queryItems = queryItems
        return components?.url
    }
}
