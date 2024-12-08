import UIKit

final class MoviesViewController: UIViewController {
    // MARK: - Private properties -
    private let contenView = MoviesViewContent()
    private let searchController = CustomSearchController(searchResultsController: nil)
    private var refreshControl: UIRefreshControl!
    private var filteredMovies: [Items] = []
    private var isFiltering: Bool { return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true) || yearPickerManager.selectedYear != nil }
    private var totalPage = 1
    private var currentPage = 1
    private var isLoading = false
    private var movies: [Items] = [] {
        didSet { contenView.reloadTableView() }
    }
    
    private var yearPickerManager: YearPickerManager!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMovies(page: currentPage)
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
    
    private func configureCell(_ cell: MoviesTableViewCell, with movie: Items) {
        guard let posterUrl = movie.posterUrlPreview,
              let movieName = (movie.nameOriginal?.isEmpty ?? true) ? movie.nameRu : movie.nameOriginal,
              let genre = movie.genres,
              let country = movie.countries,
              let year = movie.year,
              let kinopoiskId = movie.kinopoiskId,
              let rating = movie.ratingKinopoisk else { return }
        
        NetworkManager.shared.loadImage(urlString: posterUrl) { [weak cell] image in
            DispatchQueue.main.async {
                guard let cell, let image else { return }
                
                let moviesData = MoviesModel(
                    movieName: movieName,
                    year: String(year),
                    country: country.compactMap { $0.country },
                    genre: genre.compactMap { $0.genre },
                    rating: String(rating),
                    poster: image,
                    kinopoiskId: kinopoiskId
                )
                cell.configureCell(viewData: moviesData)
            }
        }
    }
}

// MARK: - UIScrollViewDelegate -
extension MoviesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height - 100 && !isLoading {
            loadMoreMoviesIfNeeded(currentRow: movies.count - 1)
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
        guard !isLoading, page <= totalPage else { return }
        isLoading = true
        NetworkManager.shared.fetchRequest(page: page) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.refreshControl.endRefreshing()
                switch result {
                case .success(let response):
                    self.totalPage = response.totalPages ?? 1
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
    
    func loadMoreMoviesIfNeeded(currentRow: Int) {
        if currentRow == movies.count - 1 && currentPage < totalPage {
            currentPage += 1
            loadMovies(page: currentPage)
        }
    }
    
    func configureNavigationBarItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(logOutButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(logOutButtonTapped))
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
            searchController.searchBar.text = ""
            yearPickerManager.selectedYear = nil
            contenView.setTextTitleLabel(text: "Выберете год")
            filteredMovies = []
            currentPage = 1
            movies.removeAll()
            loadMovies(page: self.currentPage)
            hideLoadingIndicator()
        }
    }
}
