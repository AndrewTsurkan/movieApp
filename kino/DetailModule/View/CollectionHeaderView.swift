import UIKit

final class CollectionHeaderView: UICollectionReusableView {
    
    static var identifier: String {
        String(describing: self)
    }
    //MARK: - Private property -
    
    private let titleLabel = UILabel()
    
    //MARK: - Livecycle - 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI -
private extension CollectionHeaderView {
    func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Кадры"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textColor = .white
        makeConstrant()
    }
    
    func makeConstrant() {
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
