import UIKit

final class MoviesViewController: UIViewController {
    // MARK: - Private properties -
    private let contenView = MoviesViewContent()
    private let searchController = CustomSearchController(searchResultsController: nil)
    private var refreshControl: UIRefreshControl!
    private var filteredMovies: [Items] = []
    private var isFiltering: Bool { return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true) || yearPickerManager.selectedYear != nil }
    private var movies: [Items] = [] {
        didSet {
            contenView.reloadTableView()
        }
    }
    
    private var yearPickerManager: YearPickerManager!
    private var paginationManager: PaginationManager!
    private var sortOrder: String = "YEAR"
    
    // MARK: - Life cycle -
    override func loadView() {
        super.loadView()
        view = contenView
        configureSearchController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegateAndDataSource()
        configureNavigationBarItems()
        setupYearPicker()
        pickerButtonTapped()
        setupRefreshControl()
        
        paginationManager = PaginationManager()
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
        contenView.setDelegateAndDataSource(delegate: self, dataSource: self)
    }
    
    func configureSearchController() {
        searchController.searchBarTextChanged = { [weak self] _ in self?.filterMovies() }
        navigationItem.searchController = searchController
    }
    
    func loadMovies(page: Int) {
        guard !paginationManager.isLoading else { return }
        
        paginationManager.setLoadingState(true)
        
        var queryParams: [String: String] = [:]
        queryParams["order"] = sortOrder
        
        NetworkManager.shared.fetchRequest(page: page, queryParams: queryParams) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.paginationManager.setLoadingState(false)
                switch result {
                case .success(let response):
                    self.paginationManager.updatePages(totalPages: response.totalPages ?? 1)
                    if let newMovies = response.items {
                        self.movies.append(contentsOf: newMovies)
                    }
                case .failure(let error):
                    print("Ошибка при загрузке фильмов: \(error)")
                }
                self.contenView.reloadTableView()
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
        yearPickerManager = YearPickerManager()
        contenView.setPickerViewDelegateAndDataSource(delegate: yearPickerManager, dataSource: yearPickerManager)
    }
    
    func filterMovies() {
        guard isFiltering else {
            filteredMovies = []
            contenView.reloadTableView()
            return
        }
        
        let searchText = searchController.searchBar.text?.lowercased() ?? ""
        filteredMovies = MovieFilter.filter(movies: movies, searchText: searchText, selectedYear: yearPickerManager.selectedYear)
        contenView.reloadTableView()
    }
    
    func pickerButtonTapped() {
        contenView.yearPickerButtonAction = { [weak self] in
            self?.contenView.changeDate()
            self?.filterMovies()
        }
    }
    
    func showLoadingIndicator() {
        contenView.showActivityIndicator(true)
        refreshControl.beginRefreshing()
    }
    
    func hideLoadingIndicator() {
        contenView.showActivityIndicator(false)
        refreshControl.endRefreshing()
    }
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        contenView.refreshTableView(refresh: refreshControl)
    }
    
    @objc func refreshData() {
        showLoadingIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self else { return }
            searchController.searchBar.text = nil
            yearPickerManager.selectedYear = nil
            contenView.setTextTitleLabel(text: "Выберите год релиза")
            filteredMovies = []
            paginationManager.changeCurrentPage(with: 1)
            movies.removeAll()
            loadMovies(page: self.paginationManager.currentPage)
            hideLoadingIndicator()
        }
    }
    
    func configureCell(_ cell: MoviesTableViewCell, with movie: Items) {
        guard let posterUrl = movie.posterUrlPreview,
              let movieName = (movie.nameOriginal?.isEmpty ?? true) ? movie.nameRu : movie.nameOriginal,
              let genre = movie.genres,
              let country = movie.countries,
              let year = movie.year,
              let kinopoiskId = movie.kinopoiskId else { return }
        let rating = movie.ratingKinopoisk
        var ratingString: String = ""
        if let rating {
            ratingString = String(rating)
        }
        
        NetworkManager.shared.loadImage(urlString: posterUrl) { [weak cell] image in
                guard let cell, let image else { return }
                let moviesData = MoviesModel(
                    movieName: movieName,
                    year: String(year),
                    country: country.compactMap { $0.country },
                    genre: genre.compactMap { $0.genre },
                    rating: ratingString,
                    poster: image,
                    kinopoiskId: kinopoiskId
                )
            DispatchQueue.main.async {
                cell.configureCell(viewData: moviesData)
            }
        }
    }
    
    @objc func sortButtonTapped() {
        let alertController = UIAlertController(title: "Сортировка", message: "Выберите параметр для сортировки", preferredStyle: .actionSheet)

        let sortByDateAction = UIAlertAction(title: "По дате", style: .default) { [weak self] _ in
            self?.sortOrder = "YEAR"
            self?.reloadMovies()
        }
        
        let sortByRatingAction = UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
            self?.sortOrder = "RATING"
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

