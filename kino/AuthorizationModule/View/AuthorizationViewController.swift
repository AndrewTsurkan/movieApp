import UIKit

final class AuthorizationViewController: UIViewController {
//MARK: - Private properties -
    private let contentView = AuthorizationContentView()
    //MARK: - Life cycle -
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
    }
}

//MARK: - UITextFieldDelegate -
extension AuthorizationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - Private -
private extension AuthorizationViewController {
    func setupAction() {
        contentView.enterButtonAction = { [weak self] in
            print("oopopopopop")
        }
    }
}
