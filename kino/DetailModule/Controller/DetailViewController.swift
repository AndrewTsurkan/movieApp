import UIKit

final class DetailViewController: UIViewController {
    
    //MARK: - Private properties -
    private let paginationManager = PaginationManager()
    private var viewData: DetailScreenResponse? = nil {
        didSet {
            configureView()
        }
    }
    private var stillsFilmURL: [StillsItems] = [] {
        didSet {
            contentView.reloadCollectionView()
        }
    }
    
    private let contentView = DetailView()
    //MARK: = Lifecycle -
    
    init(kinopoiskId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.loadDetailFilmsImages(id: kinopoiskId)
        self.loadDetailData(id: kinopoiskId)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
            navigationBar.tintColor = .white
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
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
        NetworkManager.shared.loadImage(urlString: posterURL) { [weak cell] image in
            guard let image, let cell else { return }
            cell.configureCell(poster: image)
        }
        return cell
    }
}

//MARK: - Private extension -
private extension DetailViewController {
    func loadDetailFilmsImages(id: Int) {
        guard !paginationManager.isLoading else { return }
        
        paginationManager.setLoadingState(true)
        
        NetworkManager.shared.getStillsFilm(id: id, page: paginationManager.currentPage) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                paginationManager.setLoadingState(false)
                switch result {
                case .success(let response):
                    paginationManager.updatePages(totalPages: response.totalPages ?? 1)
                    stillsFilmURL += response.items ?? []
                case .failure(let error):
                    print("Ошибка при загрузке кадров: \(error)")
                }
            }
        }
    }
    
    func loadDetailData(id: Int) {
        NetworkManager.shared.getDetailFilm(id: id) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                switch result {
                case .success(let response):
                    viewData = response
                case .failure(let error):
                    print("Ошибка при загрузке информации о фильме: \(error)")
                }
            }
        }
    }
    
    func configureView() {
        guard let viewData else { return }
        guard let posterURL = viewData.posterUrlPreview,
              let name = viewData.nameOriginal ?? viewData.nameRu,
              let rating = viewData.ratingKinopoisk,
              let description  = viewData.description,
              let genre = viewData.genres,
              let country = viewData.countries else { return }
        
        let year = ([viewData.startYear, viewData.endYear].compactMap { $0 }.isEmpty)
            ? [viewData.year].compactMap { $0 }.map { "\($0)"}
            : [viewData.startYear, viewData.endYear].compactMap { $0 }.map { "\($0)"}
        
        NetworkManager.shared.loadImage(urlString: posterURL) { [weak self] image in
            DispatchQueue.main.async { [weak self] in
                guard let image, let self else { return }
                contentView.configure(viewData: .init(
                    poster: image,
                    name: name,
                    rating: String(rating),
                    description: description,
                    genre: genre.compactMap { $0.genre},
                    year: year,
                    country: country.compactMap { $0.country}))
            }
        }
    }
    
    func setDelegate() {
        contentView.setDelegate(delegate: self, dataSource: self)
    }
}
