import UIKit

final class SearchController: UISearchController {
    
    // MARK: - Public properties -
    
    var searchBarTextChanged: ((String) -> Void)?
    
    // MARK: - Lifecycle -
    
    override init(searchResultsController: UIViewController? = nil) {
        super.init(searchResultsController: searchResultsController)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UISearchResultsUpdating -

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            searchBarTextChanged?(searchText.lowercased())
            searchBar.searchTextField.textColor = .white
        }
    }
}

//MARK: - Private extension -

private extension SearchController {
    func configure() {
        searchResultsUpdater = self
        obscuresBackgroundDuringPresentation = false
        hidesNavigationBarDuringPresentation = false
        searchBar.searchTextField.layer.borderColor = UIColor.gray.cgColor
        searchBar.searchTextField.layer.borderWidth = 1
        searchBar.searchTextField.layer.cornerRadius = 5
        searchBar.placeholder = "keyword"
        let placeholderText = NSAttributedString(string: searchBar.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        searchBar.searchTextField.attributedPlaceholder = placeholderText
    }
}

