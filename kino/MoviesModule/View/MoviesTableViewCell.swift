import UIKit

final class MoviesTableViewCell: UITableViewCell {
    
    struct Movie {
        let movieName: String
        let year: String
        let country: [String]
        let genre: [String]
        let rating: String
        let poster: UIImage
        let kinopoiskId: Int
    }
    
    static var reuseIdentifier: String {
        String(describing: self)
    }
    //MARK: - Private properties -
    private let movieName = UILabel()
    private let genresLabel = UILabel()
    private let yearAndCountriesLabel = UILabel()
    private let posterImageView = UIImageView()
    private let ratingLabel = UILabel()
    private let stackView = UIStackView()
    
    //MARK: - lifeCycle -
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        movieName.text = nil
        genresLabel.text = nil
        yearAndCountriesLabel.text = nil
        posterImageView.image = nil
        ratingLabel.text = nil 
    }
}

//MARK: - UI -
private extension MoviesTableViewCell {
    func setupUI() {
        addSubview()
        makeConstraints()
        setupPosterImageView()
        setupStackView()
        setupMovieNameLabel()
        setupGenresLabel()
        setupYearAndCountriesLabel()
        setupRatingLabel()
        contentView.backgroundColor = .black
    }
    
    func addSubview() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(movieName)
        stackView.addArrangedSubview(genresLabel)
        stackView.addArrangedSubview(yearAndCountriesLabel)
        contentView.addSubview(ratingLabel)
    }
    
    func makeConstraints() {
        let screenWidth = UIScreen.main.bounds.width
        NSLayoutConstraint.activate([
            posterImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalToConstant: screenWidth/3),
            
            ratingLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            ratingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            stackView.leftAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: 8),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: ratingLabel.topAnchor, constant: -5),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
    }
    
    func setupPosterImageView() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.clipsToBounds = true
    }
    
    func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
    }
    
    func setupMovieNameLabel() {
        movieName.translatesAutoresizingMaskIntoConstraints = false
        movieName.textColor = .white
        movieName.textAlignment = .left
        movieName.font = UIFont.boldSystemFont(ofSize: 24)
        movieName.numberOfLines = 1
    }
    
    func setupGenresLabel() {
        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        genresLabel.textColor = .gray
        genresLabel.textAlignment = .left
        genresLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    func setupYearAndCountriesLabel() {
        yearAndCountriesLabel.translatesAutoresizingMaskIntoConstraints = false
        yearAndCountriesLabel.textColor = .gray
        yearAndCountriesLabel.textAlignment = .left
        yearAndCountriesLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    func setupRatingLabel() {
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.textColor = #colorLiteral(red: 0.2640381753, green: 0.8696789742, blue: 0.8171131611, alpha: 1)
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 24)
        ratingLabel.textAlignment = .right
    }
}

//MARK: - Public -
extension MoviesTableViewCell {
    func configureCell(viewData: Movie) {
        posterImageView.image = viewData.poster
        movieName.text = viewData.movieName
        yearAndCountriesLabel.text = "\(viewData.year), \(viewData.country.joined(separator: ", "))"
        genresLabel.text = viewData.genre.joined(separator: ", ")
        ratingLabel.text = viewData.rating
    }
}
