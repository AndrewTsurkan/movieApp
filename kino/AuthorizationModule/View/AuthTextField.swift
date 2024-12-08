import UIKit

final class AuthTextField: UITextField {
    
    //MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Public extension -

extension AuthTextField {
    func settingPlaceholder(text: String) {
        self.placeholder = text
        setupAttribute()
    }
    
    func setMode(_ mode: Bool) {
        isSecureTextEntry = mode
    }
    
    func setDelagate(dalegate: UITextFieldDelegate) {
        delegate = dalegate
    }
    
    func setTag(tag: Int) {
        self.tag = tag
    }
    
    func textFieldData() -> String? {
        self.text
    }
}

//MARK: - Private extension -

private extension AuthTextField {
    func setupTextField() {
        layer.borderWidth = 1
        let textFieldPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        leftView = textFieldPadding
        leftViewMode = .always
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 5
        textColor = .white
        backgroundColor = .clear
    }
    
    func setupAttribute() {
        let placeholderText = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        attributedPlaceholder = placeholderText
    }
}
