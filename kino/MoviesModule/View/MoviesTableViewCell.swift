import UIKit

final class MoviesTableViewCell: UITableViewCell {
    
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
    }
    
    func addSubview() {
        addSubview(posterImageView)
        addSubview(stackView)
        stackView.addArrangedSubview(movieName)
        stackView.addArrangedSubview(genresLabel)
        stackView.addArrangedSubview(yearAndCountriesLabel)
        addSubview(ratingLabel)
    }
    
    func makeConstraints() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        NSLayoutConstraint.activate([
            posterImageView.leftAnchor.constraint(equalTo: leftAnchor),
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalToConstant: screenWidth/3),
            
            stackView.leftAnchor.constraint(equalTo: posterImageView.leftAnchor, constant: 8),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: ratingLabel.topAnchor, constant: -5),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            ratingLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            ratingLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    func setupPosterImageView() {
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.clipsToBounds = true
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
    }
    
    func setupMovieNameLabel() {
        movieName.textColor = .white
        movieName.textAlignment = .left
        movieName.font = UIFont.boldSystemFont(ofSize: 24)
        movieName.numberOfLines = 1
    }
    
    func setupGenresLabel() {
        yearAndCountriesLabel.textColor = .gray
        yearAndCountriesLabel.textAlignment = .left
        yearAndCountriesLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    func setupYearAndCountriesLabel() {
        yearAndCountriesLabel.textColor = .gray
        yearAndCountriesLabel.textAlignment = .left
        yearAndCountriesLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    func setupRatingLabel() {
        genresLabel.textColor = #colorLiteral(red: 0.2640381753, green: 0.8696789742, blue: 0.8171131611, alpha: 1)
        genresLabel.font = UIFont.boldSystemFont(ofSize: 24)
        genresLabel.textAlignment = .right
    }
}
