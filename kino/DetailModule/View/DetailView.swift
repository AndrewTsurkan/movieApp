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
    private let scrollView = UIScrollView()
    private let stillsLabel = UILabel()
    private let linkButton = UIButton()
    var linkButtonAction: (() -> ())?
    
    
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
        setupScrollView()
        setupStackView()
        setupStillsLabel()
        setupTitleDescriptionLabel()
        setupLinkButton()
        setupDescriptionLabel()
        setupGenreLabel()
        setupYearAndCountryLabel()
        backgroundColor = .black
    }
    
    func addSubviews() {
        addSubview(posterImageView)
        addSubview(filmNameLabel)
        addSubview(ratingLabel)
        addSubview(scrollView)
        addSubview(linkButton)
        scrollView.addSubview(titleDescriptionLabel)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(genreLabel)
        stackView.addArrangedSubview(yearAndCountryLabel)
        scrollView.addSubview(stillsLabel)
        scrollView.addSubview(collectionView)
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            posterImageView.leftAnchor.constraint(equalTo: leftAnchor),
            posterImageView.rightAnchor.constraint(equalTo: rightAnchor),
            
            ratingLabel.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -15),
            ratingLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            
            filmNameLabel.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -15),
            filmNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            filmNameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            scrollView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 5),
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleDescriptionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5),
            titleDescriptionLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20),
            titleDescriptionLabel.heightAnchor.constraint(equalToConstant: 25),
            
            linkButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5),
            linkButton.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20),
            linkButton.widthAnchor.constraint(equalToConstant: 30),
            linkButton.heightAnchor.constraint(equalToConstant: 30),
            
            stackView.topAnchor.constraint(equalTo: titleDescriptionLabel.bottomAnchor, constant: 5),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            
            stillsLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            stillsLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20),
            
            collectionView.topAnchor.constraint(equalTo: stillsLabel.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
            collectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    func setupPosterImageView() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.clipsToBounds = true
        posterImageView.contentMode = .scaleToFill
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
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
    
    func setupLinkButton() {
        linkButton.translatesAutoresizingMaskIntoConstraints = false
        linkButton.setImage(UIImage(systemName: "link"), for: .normal)
        linkButton.tintColor = #colorLiteral(red: 0.2640381753, green: 0.8696789742, blue: 0.8171131611, alpha: 1)
        linkButton.addTarget(self, action: #selector(linkButtonTapped), for: .touchUpInside)
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
    
    func setupStillsLabel() {
        //TODO: Добавлял хедер, почему то начинала скролиться даблица по вертикали, скрывая хедер и обратно
        stillsLabel.translatesAutoresizingMaskIntoConstraints = false
        stillsLabel.textColor = .white
        stillsLabel.font = UIFont.boldSystemFont(ofSize: 32)
        stillsLabel.textAlignment = .left
        stillsLabel.text = "Кадры"
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.identifier)
        collectionView.backgroundColor = .black
        collectionView.alwaysBounceHorizontal = true
        collectionView.alwaysBounceVertical = false
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        //item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.6))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 20
        return UICollectionViewCompositionalLayout(section: section)
    }
}

//MARK: - Public extension -
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
        collectionView.reloadData()
    }
    
    func updateStillLabelVisibility(isHidden: Bool) {
        stillsLabel.isHidden = isHidden
    }
}

//MARK: - Private extension -
private extension DetailView {
    @objc func linkButtonTapped() {
        linkButtonAction?()
    }
}
