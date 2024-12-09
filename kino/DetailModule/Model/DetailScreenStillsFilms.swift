import UIKit

struct DetailScreenStillsFilms: Codable {
    let totalPages: Int?
    let items: [StillsItems]?
}

struct StillsItems: Codable {
    let previewUrl: String?
}
