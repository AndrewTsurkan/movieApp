import UIKit

final class DetailViewController: UIViewController {
    
    //MARK: - Private properties -
    private let paginationManager = PaginationManager()
    private var id = 0
    private var scrollDebounceTimer: Timer?
    private var viewData: DetailScreenResponse?
    
    private var stillsFilmURL: [StillsItems] = []
    private let contentView = DetailView()
    //MARK: = Lifecycle -
    
    init(kinopoiskId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.loadDetailFilmsImages(id: kinopoiskId)
        self.loadDetailData(id: kinopoiskId)
        self.id = kinopoiskId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
}

//MARK: - UICollectioViewDelegate, UICollectionViewDataSource -
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stillsFilmURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.identifier,
                                                            for: indexPath) as? DetailCollectionViewCell else { return UICollectionViewCell() }
        guard let posterURL = stillsFilmURL[indexPath.item].previewUrl else { return UICollectionViewCell() }
        Task {
            let image = try await NetworkService.shared.loadImage(urlString: posterURL)
            await MainActor.run {
                cell.configureCell(poster: image)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == stillsFilmURL.count - 1 {
            paginationManager.loadMoreIfNeeded(currentRow: indexPath.row, totalItemsCount: stillsFilmURL.count)
        }
    }
}

//MARK: - Private extension -
private extension DetailViewController {
    func loadDetailFilmsImages(id: Int) {
        guard !paginationManager.isLoading else { return }
        
        paginationManager.setLoadingState(true)
        
        Task {
            let response = try await NetworkService.shared.fetchData(id: id,
                                                                     images: "images",
                                                                     page: paginationManager.currentPage,
                                                                     decodingType: DetailScreenStillsFilms.self)
            
            stillsFilmURL += response.items ?? []
            paginationManager.setLoadingState(false)
            paginationManager.updatePages(totalPages: response.totalPages ?? 1)
            
            await MainActor.run {
                contentView.reloadCollectionView()
                contentView.updateStillLabelVisibility(isHidden: stillsFilmURL.isEmpty)
            }
        }
    }
    
    func loadDetailData(id: Int) {
        Task {
            let response = try await NetworkService.shared.fetchData(id: id , decodingType: DetailScreenResponse.self)
            viewData = response
            await MainActor.run {
                configureView()
            }
        }
    }
    
    func configureView() {
        guard let posterURL = viewData?.posterUrlPreview,
              let name = viewData?.nameOriginal ?? viewData?.nameRu,
              let genre = viewData?.genres,
              let country = viewData?.countries else { return }
        
        let year = ([viewData?.startYear, viewData?.endYear].compactMap { $0 }.isEmpty)
        ? [viewData?.year].compactMap { $0 }.map { "\($0)"}
        : [viewData?.startYear, viewData?.endYear].compactMap { $0 }.map { "\($0)"}
        
        let rating = viewData?.ratingKinopoisk
        let description  = viewData?.description
        Task {
            let image = try await NetworkService.shared.loadImage(urlString: posterURL)
            await MainActor.run {
                contentView.configure(viewData: .init(
                    poster: image,
                    name: name,
                    rating: rating != nil ? String(rating!) : "",
                    description: description != nil ? description! : "",
                    genre: genre.compactMap { $0.genre },
                    year: year,
                    country: country.compactMap { $0.country }))
            }
        }
    }
    
    func setDelegate() {
        contentView.setDelegate(delegate: self, dataSource: self)
    }
    
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
            navigationBar.tintColor = .white
            let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(backButtonAction))
            navigationItem.leftBarButtonItem = backButton
        }
    }
    
    func setAction() {
        
        paginationManager.loadMoreAction = { [weak self] page in
            guard let self else { return }
            loadDetailFilmsImages(id: id)
        }
        
        contentView.linkButtonAction = { [weak self] in
            guard let self, let urlString = viewData?.webUrl else { return }
            guard let url = URL(string: urlString) else { return }
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
