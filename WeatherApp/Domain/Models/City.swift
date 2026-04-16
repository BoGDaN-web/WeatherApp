import Foundation

struct City: Hashable, Codable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
}
