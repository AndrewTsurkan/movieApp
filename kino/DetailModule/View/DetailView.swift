import UIKit

final class DetailView: UIView {
    
    struct DetailFilm {
        let poster: UIImage
        let name: String
        let rating: String
        let description: String
        let genre: [String]
        let year: [String]
        let country: [String]
    }
    
    //MARK: - Private properties -
    
    private let posterImageView = UIImageView()
    private let filmNameLabel = UILabel()
    private let ratingLabel = UILabel()
    private let titleDescriptionLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let genreLabel = UILabel()
    private let yearAndCountryLabel = UILabel()
    private var collectionView: UICollectionView!
    private let stackView = UIStackView()
    
    
    //MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI -
private extension DetailView {
    func setupUI() {
        setupCollectionView()
        addSubviews()
        makeConstraints()
        setupPosterImageView()
        setupFilmNameLabel()
        setupRatingLabel()
        setupStackView()
        setupTitleDescriptionLabel()
        setupDescriptionLabel()
        setupGenreLabel()
        setupYearAndCountryLabel()
        backgroundColor = .black
    }
    
    func addSubviews() {
        addSubview(posterImageView)
        addSubview(filmNameLabel)
        addSubview(ratingLabel)
        addSubview(titleDescriptionLabel)
        addSubview(stackView)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(genreLabel)
        stackView.addArrangedSubview(yearAndCountryLabel)
        addSubview(collectionView)
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            posterImageView.leftAnchor.constraint(equalTo: leftAnchor),
            posterImageView.rightAnchor.constraint(equalTo: rightAnchor),
            
            filmNameLabel.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -15),
            filmNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            
            ratingLabel.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -15),
            ratingLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            
            titleDescriptionLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 5),
            titleDescriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            titleDescriptionLabel.heightAnchor.constraint(equalToConstant: 25),
            
            stackView.topAnchor.constraint(equalTo: titleDescriptionLabel.bottomAnchor, constant: 5),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20),
            
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 5)
        ])
    }
    
    func setupPosterImageView() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
//        posterImageView.clipsToBounds = true
        posterImageView.contentMode = .scaleToFill
    }
    
    func setupFilmNameLabel() {
        filmNameLabel.translatesAutoresizingMaskIntoConstraints = false
        filmNameLabel.textColor = .white
        filmNameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        filmNameLabel.textAlignment = .left
        filmNameLabel.numberOfLines = 1
    }
    
    func setupRatingLabel() {
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.textColor = #colorLiteral(red: 0.2640381753, green: 0.8696789742, blue: 0.8171131611, alpha: 1)
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 24)
        ratingLabel.textAlignment = .right
    }
    
    func setupTitleDescriptionLabel() {
        titleDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        titleDescriptionLabel.textColor = .white
        titleDescriptionLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleDescriptionLabel.textAlignment = .left
        titleDescriptionLabel.text = "Описание"
    }
    
    func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
    }
    
    func setupDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
    }
    
    func setupGenreLabel() {
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.textColor = .gray
        genreLabel.font = UIFont.systemFont(ofSize: 16)
        genreLabel.textAlignment = .left
        genreLabel.numberOfLines = 1
    }
    
    func setupYearAndCountryLabel() {
        yearAndCountryLabel.translatesAutoresizingMaskIntoConstraints = false
        yearAndCountryLabel.textColor = .gray
        yearAndCountryLabel.font = UIFont.systemFont(ofSize: 16)
        yearAndCountryLabel.textAlignment = .left
        yearAndCountryLabel.numberOfLines = 1
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.identifier)
        collectionView.register(CollectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CollectionHeaderView.identifier)
        collectionView.backgroundColor = .white
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        //section
        let section = NSCollectionLayoutSection(group: group)
        
        // header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

//MARK: - Public -
extension DetailView {
    func setDelegate(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
    }
    
    func configure(viewData: DetailFilm) {
        posterImageView.image = viewData.poster
        filmNameLabel.text = viewData.name
        ratingLabel.text = viewData.rating
        descriptionLabel.text = viewData.description
        genreLabel.text = viewData.genre.joined(separator: ", ")
        let yearAndCountriesString = "\(viewData.year.joined(separator: "-")), \(viewData.country.joined(separator: ", "))"
        yearAndCountryLabel.text = yearAndCountriesString
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}
