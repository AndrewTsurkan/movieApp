import Foundation

class PaginationManager {
    //MARK: - Private properties -
    
    private(set) var currentPage: Int
    private(set) var totalPage: Int
    private(set) var isLoading: Bool
    
    var loadMoreAction: ((Int) -> Void)?
    //MARK: - Lifecycle =
    
    init(currentPage: Int = 1, totalPage: Int = 1) {
        self.currentPage = currentPage
        self.totalPage = totalPage
        self.isLoading = false
    }
}

//MARK: - Public -

extension PaginationManager {
    func loadMoreIfNeeded(currentRow: Int, totalItemsCount: Int) {
        guard !isLoading else { return }
        
        if currentRow == totalItemsCount - 1 && currentPage < totalPage {
            currentPage += 1
            loadMoreAction?(currentPage)
        }
    }
    
    func updatePages(totalPages: Int) {
        self.totalPage = totalPages
    }
    
    func setLoadingState(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func changeCurrentPage(with newValue: Int) {
        currentPage = newValue
    }
}
