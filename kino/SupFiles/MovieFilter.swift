import Foundation

import Foundation

final class MovieFilter {
    static func filter(movies: [Items], searchText: String, selectedYear: Int?) -> [Items] {
        return movies.filter { movie in
            let matchesSearchText: Bool
            if searchText.isEmpty {
                matchesSearchText = true
            } else {
                matchesSearchText = !(movie.nameOriginal?.isEmpty ?? true)
                    ? movie.nameOriginal!.lowercased().contains(searchText)
                    : (movie.nameRu?.lowercased().contains(searchText) ?? false)
            }

            let matchesYear = selectedYear == nil || (movie.year == selectedYear)
            return matchesSearchText && matchesYear
        }
    }
}
