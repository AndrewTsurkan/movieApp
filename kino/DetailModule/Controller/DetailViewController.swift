import UIKit

final class DetailViewController: UIViewController {
    
    //MARK: - Private properties -
    private let contentView = DetailView()
    //MARK: = Lifecycle -
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

