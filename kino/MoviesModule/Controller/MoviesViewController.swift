import UIKit

final class MoviesViewController: UIViewController {
    
    enum SortOrder: String {
        case year = "YEAR"
        case rating = "RATING"
    }
    
    // MARK: - Private properties -
    
    private let contentView = MoviesView()
    private let searchController = SearchController(searchResultsController: nil)
    private var refreshControl: UIRefreshControl!
    private var filteredMovies: [Item] = []
    private var isFiltering: Bool {
        (searchController.isActive && searchController.searchBar.text?.isEmpty == false) || yearPickerManager.selectedYear != nil
    }
    private var movies: [Item] = [] {
        didSet {
            contentView.reloadTableView()
        }
    }
    
    private let yearPickerManager = YearPickerManager()
    private let paginationManager = PaginationManager()
    private var sortOrder: SortOrder = .year
    
    // MARK: - Lifecycle -
    
    override func loadView() {
        super.loadView()
        view = contentView
        configureSearchController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegateAndDataSource()
        configureNavigationBarItems()
        setupYearPicker()
        pickerButtonTapped()
        setupRefreshControl()
        
        paginationManager.loadMoreAction = { [weak self] page in
            self?.loadMovies(page: page)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMovies(page: paginationManager.currentPage)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource -

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredMovies.count : movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoviesTableViewCell.reuseIdentifier, for: indexPath) as? MoviesTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = isFiltering ? filteredMovies[indexPath.row] : movies[indexPath.row]
        configureCell(cell, with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

// MARK: - UIScrollViewDelegate -

extension MoviesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height - 100 && !paginationManager.isLoading {
            paginationManager.loadMoreIfNeeded(currentRow: movies.count - 1, totalItemsCount: movies.count)
        }
    }
}

// MARK: - UISearchResultsUpdating -

extension MoviesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterMovies()
    }
}

// MARK: - Private Methods -

private extension MoviesViewController {
    func setDelegateAndDataSource() {
        contentView.setDelegateAndDataSource(delegate: self, dataSource: self)
    }
    
    func configureSearchController() {
        searchController.searchBarTextChanged = { [weak self] _ in self?.filterMovies() }
        navigationItem.searchController = searchController
    }
    
    func loadMovies(page: Int) {
        guard !paginationManager.isLoading else { return }
        
        paginationManager.setLoadingState(true)
        
        var queryParams: [String: String] = [:]
        queryParams["order"] = sortOrder.rawValue
        
        NetworkManager.shared.getFilms(page: page, queryParams: queryParams) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                paginationManager.setLoadingState(false)
                switch result {
                case .success(let response):
                    paginationManager.updatePages(totalPages: response.totalPages ?? 1)
                    movies += response.items ?? []
                case .failure(let error):
                    print("Ошибка при загрузке фильмов: \(error)")
                }
                contentView.reloadTableView()
            }
        }
    }
    
    func configureNavigationBarItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(logOutButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(sortButtonTapped))
        navigationItem.title = "KinoPoisk"
    }
    
    @objc func logOutButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupYearPicker() {
        contentView.setPickerViewDelegateAndDataSource(delegate: yearPickerManager, dataSource: yearPickerManager)
    }
    
    func filterMovies() {
        guard isFiltering else {
            filteredMovies = []
            contentView.reloadTableView()
            return
        }
        
        let searchText = searchController.searchBar.text?.lowercased() ?? ""
        filteredMovies = MovieFilter.filter(movies: movies, searchText: searchText, selectedYear: yearPickerManager.selectedYear)
        contentView.reloadTableView()
    }
    
    func pickerButtonTapped() {
        contentView.yearPickerButtonAction = { [weak self] in
            self?.contentView.changeDate()
            guard let selectedYear = self?.yearPickerManager.selectedYear else { return }
            self?.contentView.setTextTitleLabel(text: String(selectedYear))
            self?.filterMovies()
        }
    }
    
    func showLoadingIndicator() {
        contentView.showActivityIndicator(true)
        refreshControl.beginRefreshing()
    }
    
    func hideLoadingIndicator() {
        contentView.showActivityIndicator(false)
        refreshControl.endRefreshing()
    }
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        contentView.refreshTableView(refresh: refreshControl)
    }
    
    @objc func refreshData() {
        showLoadingIndicator()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            searchController.searchBar.text = nil
            yearPickerManager.selectedYear = nil
            contentView.setTextTitleLabel(text: "Выберите год релиза")
            filteredMovies = []
            paginationManager.changeCurrentPage(with: 1)
            movies.removeAll()
            loadMovies(page: self.paginationManager.currentPage)
            hideLoadingIndicator()
        }
    }
    
    func configureCell(_ cell: MoviesTableViewCell, with movie: Item) {
        guard let posterUrl = movie.posterUrlPreview,
              let movieName = (movie.nameOriginal?.isEmpty ?? true) ? movie.nameRu : movie.nameOriginal,
              let genre = movie.genres,
              let country = movie.countries,
              let year = movie.year,
              let kinopoiskId = movie.kinopoiskId else { return }
        let rating = movie.ratingKinopoisk
        
        NetworkManager.shared.loadImage(urlString: posterUrl) { [weak cell] image in
                guard let cell, let image else { return }
            DispatchQueue.main.async {
                cell.configureCell(viewData: .init(
                    movieName: movieName,
                    year: String(year),
                    country: country.compactMap { $0.country },
                    genre: genre.compactMap { $0.genre },
                    rating: rating != nil ? String(rating!) : "",
                    poster: image,
                    kinopoiskId: kinopoiskId
                ))
            }
        }
    }
    
    @objc func sortButtonTapped() {
        let alertController = UIAlertController(title: "Сортировка", message: "Выберите параметр для сортировки", preferredStyle: .actionSheet)

        let sortByDateAction = UIAlertAction(title: "По дате", style: .default) { [weak self] _ in
            self?.sortOrder = .year
            self?.reloadMovies()
        }
        
        let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.sortOrder = .rating
            self?.reloadMovies()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)

        alertController.addAction(sortByDateAction)
        alertController.addAction(sortByRatingAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
    
    func reloadMovies() {
        paginationManager.changeCurrentPage(with: 1)
        movies.removeAll()
        loadMovies(page: paginationManager.currentPage)
    }
}
