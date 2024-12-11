import UIKit

final class AuthorizationView: UIView {
    
    //MARK: - Private properties -
    
    private let logoLabel = UILabel()
    private let loginTextField = AuthTextField()
    private let passwordTextField = AuthTextField()
    private let enterButton = UIButton()
    var enterButtonAction: (() -> Void)?
    
    //MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Public extension -

extension AuthorizationView {
    func getLogintext() -> String? {
        loginTextField.textFieldData()
    }
    
    func getPasswordText() -> String? {
        passwordTextField.textFieldData()
    }
}

//MARK: - UI -

private extension AuthorizationView {
    func setupUI() {
        addSubViews()
        makeConstraints()
        setupLogoLabel()
        setupLoginTextField()
        setupPasswordTextField()
        setupEnterButton()
        backgroundColor = .black
    }
    
    func addSubViews() {
        addSubview(logoLabel)
        addSubview(loginTextField)
        addSubview(passwordTextField)
        addSubview(enterButton)
    }
    
    func makeConstraints() {
        let screenHeight = UIScreen.main.bounds.height
        
        NSLayoutConstraint.activate([
            loginTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -15),
            loginTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            loginTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            loginTextField.heightAnchor.constraint(equalToConstant: 47),
            
            loginTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            passwordTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            passwordTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 47),
            
            logoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoLabel.bottomAnchor.constraint(equalTo: loginTextField.topAnchor, constant: -100),
            
            enterButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            enterButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            enterButton.heightAnchor.constraint(equalToConstant: 47),
            enterButton.topAnchor.constraint(equalTo: bottomAnchor, constant: -(screenHeight/4))
        ])
    }
    
    func setupLogoLabel() {
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.text = "KinoPoisk"
        logoLabel.textAlignment = .center
        logoLabel.font = UIFont.systemFont(ofSize: 50)
        logoLabel.textColor = #colorLiteral(red: 0.2640381753, green: 0.8696789742, blue: 0.8171131611, alpha: 1)
    }
    
    func setupLoginTextField() {
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        loginTextField.settingPlaceholder(text: "Логин")
        loginTextField.setTag(tag: 0)
    }
    
    func setupPasswordTextField() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.settingPlaceholder(text: "Пароль")
        passwordTextField.setMode(true)
        passwordTextField.setTag(tag: 1)
        
    }
    
    func setupEnterButton() {
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        enterButton.setTitle("Войти", for: .normal)
        enterButton.backgroundColor = #colorLiteral(red: 0.2640381753, green: 0.8696789742, blue: 0.8171131611, alpha: 1)
        enterButton.titleLabel?.textColor = .white
        enterButton.layer.cornerRadius = 5
        enterButton.addTarget(self, action: #selector(enterButtonTapped), for: .touchUpInside)
    }
    
    @objc func enterButtonTapped() {
         enterButtonAction?()
    }
}

