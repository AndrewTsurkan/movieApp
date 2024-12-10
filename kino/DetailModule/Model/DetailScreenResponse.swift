import Foundation

struct DetailScreenResponse: Codable {
    let posterUrlPreview: String?
    let nameOriginal: String?
    let nameRu: String?
    let description: String?
    let countries: [Country]?
    let genres: [Genre]?
    let startYear: Int?
    let endYear: Int?
    let ratingKinopoisk: Double?
    let year: Int?
    let webUrl: String? 
}
