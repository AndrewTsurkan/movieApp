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
            self?.pressLogginButton()
        }
    }
    
    func pressLogginButton() {
        guard let login = contentView.getLogintext(),
              let password = contentView.getPasswordText() else { return }
        
        if KeychainManager.shared.isPasswordExists(for: login) {
            if let savedPassword = KeychainManager.shared.getPassword(for: login),
               savedPassword == password {
                print("Open new screen")
            } else {
                showAlert()
            }
        } else {
            if KeychainManager.shared.savePassword(password: password, for: login) {
                print("Open new screen")
            } else {
                print("Ошмбка")
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Уведомление", message: "Введен неверный пароль", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        navigationController?.present(alert, animated: true)
    }
}
