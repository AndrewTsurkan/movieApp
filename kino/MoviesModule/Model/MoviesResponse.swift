import UIKit

struct MoviesResponse: Codable {
    let totalPages: Int?
    let items: [Item]?
}

struct Item: Codable {
    let kinopoiskId: Int?
    let nameOriginal: String?
    let countries: [Country]?
    let genres: [Genre]?
    let nameRu: String?
    let ratingKinopoisk: Double?
    let year: Int?
    let posterUrlPreview: String?
    let previewUrl: String?
}

struct Country: Codable {
    let country: String?
}

struct Genre: Codable {
    let genre: String?
}
