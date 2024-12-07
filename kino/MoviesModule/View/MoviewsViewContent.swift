import UIKit

final class MoviesViewContent: UIView {
    //MARK: - Private properties -
    private let tableView = UITableView()
    
    //MARK: - Life cycle -
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UI -
private extension MoviesViewContent {
    func setupUI() {
        
    }
    
    func addSubviews() {
        addSubview(tableView)
    }
    
    func makeConstraints() {
        
    }
    
    func setupTableView() {
        
    }

}

//MARK: - Public -
extension MoviesViewContent {
    func setDelegateAndDataSource(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
        tableView.delegate = delegate
    }
}
//MARK: - Private -
private extension MoviesViewContent {

}
