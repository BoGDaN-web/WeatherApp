import Foundation

struct CityResultDTO: Decodable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
}
