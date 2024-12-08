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
}

//MARK: - UI -
private extension DetailCollectionViewCell {
    func setupImageView() {
        contentView.addSubview(posterImageView)
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.clipsToBounds = true
        makeConstraint()
    }
    
    func makeConstraint() {
        NSLayoutConstraint.activate([
        posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
        posterImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        posterImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
