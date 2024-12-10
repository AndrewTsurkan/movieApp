import UIKit

final class DetailCollectionViewCell: UICollectionViewCell {
    static var identifier: String {
        String(describing: self)
    }
    
    //MARK: - Private property -
    
    private let posterImageView = UIImageView()
    
    //MARK: - Lifrcycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil 
    }
}

//MARK: - UI -
private extension DetailCollectionViewCell {
    func setupImageView() {
        contentView.addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.clipsToBounds = true
        posterImageView.contentMode = .scaleToFill
        makeConstraint()
    }
    
    func makeConstraint() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
        posterImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        posterImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}

//MARK: - Public extension -

extension DetailCollectionViewCell {
    func configureCell(poster: UIImage) {
        posterImageView.image = poster
    }
}
