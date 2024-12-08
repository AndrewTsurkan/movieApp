import UIKit

struct MoviesResponse: Codable {
    let totalPages: Int?
    let items: [Items]?
}

struct Items: Codable {
    let kinopoiskId: Int?
    let nameOriginal: String?
    let countries: [Country]?
    let genres: [Genre]?
    let nameRu: String?
    let ratingKinopoisk: Double?
    let year: Int?
    let posterUrlPreview: String?
}

struct Country: Codable {
    let country: String?
}

struct Genre: Codable {
    let genre: String?
}
