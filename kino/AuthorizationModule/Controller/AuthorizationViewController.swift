import UIKit

final class AuthorizationViewController: UIViewController {
    
    //MARK: - Private properties -
    
    private let contentView = AuthorizationView()
    
    //MARK: - Lifecycle -
    
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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

//MARK: - Private extension -

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
                openMoviesScreen()
            } else {
                showAlert()
            }
        } else {
            if KeychainManager.shared.savePassword(password: password, for: login) {
                openMoviesScreen()
            } else {
                print("Ошибка")
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Уведомление", message: "Введен неверный пароль", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        navigationController?.present(alert, animated: true)
    }
    
    func openMoviesScreen() {
        let moviesViewController = MoviesViewController()
        navigationController?.pushViewController(moviesViewController, animated: true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        let keyboardHeight = keyboardSize.height / 2
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3

        UIView.animate(withDuration: duration) {
            self.view.frame.origin.y = -keyboardHeight
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3

        UIView.animate(withDuration: duration) {
            self.view.frame.origin.y = 0
        }
    }
}

