import UIKit

final class DetailView: UIView {
    
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
        addSubviews()
        makeConstraints()
        setupPosterImageView()
        setupFilmNameLabel()
        setupRatingLabel()
        setupTitleDescriptionLabel()
        setupDescriptionLabel()
        setupGenreLabel()
        setupYearAndCountryLabel()
        setupCollectionView()
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
            ratingLabel.leftAnchor.constraint(equalTo: rightAnchor, constant: -20),
            
            titleDescriptionLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 5),
            titleDescriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            
            stackView.topAnchor.constraint(equalTo: titleDescriptionLabel.bottomAnchor, constant: 10),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20),
            
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 4)
        ])
    }
    
    func setupPosterImageView() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.clipsToBounds = true
    }
    
    func setupFilmNameLabel() {
        filmNameLabel.translatesAutoresizingMaskIntoConstraints = false
        filmNameLabel.textColor = .white
        filmNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        filmNameLabel.textAlignment = .left
        filmNameLabel.numberOfLines = 1
    }
    
    func setupRatingLabel() {
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.textColor = #colorLiteral(red: 0.2640381753, green: 0.8696789742, blue: 0.8171131611, alpha: 1)
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 16)
        ratingLabel.textAlignment = .right
    }
    
    func setupTitleDescriptionLabel() {
        titleDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        titleDescriptionLabel.textColor = .white
        titleDescriptionLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleDescriptionLabel.textAlignment = .left
    }
    
    func setupDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
    }
    
    func setupGenreLabel() {
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.textColor = .gray
        genreLabel.font = UIFont.systemFont(ofSize: 14)
        genreLabel.textAlignment = .left
        genreLabel.numberOfLines = 1
    }
    
    func setupYearAndCountryLabel() {
        yearAndCountryLabel.translatesAutoresizingMaskIntoConstraints = false
        yearAndCountryLabel.textColor = .gray
        yearAndCountryLabel.font = UIFont.systemFont(ofSize: 14)
        yearAndCountryLabel.textAlignment = .left
        yearAndCountryLabel.numberOfLines = 1
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
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
}
