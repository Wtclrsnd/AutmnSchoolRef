//
//  EnterViewController.swift
//  AutmnSchoolRef
//
//  Created by Emil Shpeklord on 20.07.2024.
//

import UIKit

final class EnterViewController: UIViewController {
    
    private let leadingInset: CGFloat = 20
    
    // MARK: - ELEMENTS
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Зарегистрируйтесь\n в приложении, чтобы\n получить доступ к данным"
        label.font = .styleruSemibold
        label.numberOfLines = 3
        label.textAlignment = .left
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.customSpacing(after: passwordTextField)
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var loginTextField: UITextField = { //mainStackView
        let textField = UITextField()
        textField.placeholder = "Логин"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        
        
        textField.backgroundColor = .styleruLightGray
        textField.layer.borderColor = UIColor.styleruBorderGray.cgColor
        
        textField.layer.cornerRadius = Constants.cornerRadiusTextField // выносим в структ Constants
        
        textField.font = .styleruRegular
        
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = { //mainStackView
        let textField = UITextField()
        textField.placeholder = "Пароль"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        
        textField.backgroundColor = .styleruLightGray
        textField.layer.cornerRadius = Constants.cornerRadiusTextField // выносим в структ Constants
        
        return textField
    }()
    
    private lazy var loginButton: UIButton = { //mainStackView
        let button = UIButton()
        button.setTitle("Зарегистрироваться", for: .normal)
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.cornerRadiusButton // выносим в структ Constants
        button.addTarget(self, action: #selector(moveToNextScene), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        addObservers()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func setupLayout() {
        setupTitle()
        setupMainStackView()
    }
    
    private func setupTitle() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingInset).isActive = true
    }
    
    private func setupLoginButton() {
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/5).isActive = true
    }
    
    private func setupMainStackView() {
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(loginTextField)
        mainStackView.addArrangedSubview(passwordTextField)
        
        mainStackView.setCustomSpacing(40, after: passwordTextField)
    
        mainStackView.addArrangedSubview(loginButton)
        //setupLoginButton()
        
        mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingInset).isActive = true
    }
    // MARK: - Observers
    
    func addObservers() {
        passwordTextField.addTarget(self, action: #selector(handlePasswordChange), for: .editingChanged)
    }
    
    // MARK: - Actions
    func passwordIsValid(password: String) -> Bool {
        let pattern = "^(?=.+[A-Z])(?=.+[0-9])(?=.+[.,?!():;]).{8,}$"
        
        guard password.range(of: pattern, options: .regularExpression) != nil else {
            return false
        }
        return true
    }
    
    func textFieldsCheck() -> Bool {
        guard let login = loginTextField.text, let password = passwordTextField.text else {
            print("Please fill in both login and password fields")
            return false
        }
        
        if login.isEmpty || password.isEmpty {
            print("Please fill in both login and password fields")
            return false
        }
        
        if passwordIsValid(password: password) {
            print("password correct")
            return true
        }
        
        dismiss(animated: true)
        
        print("Password incorrect")
        return false
    }
    
    @objc func moveToNextScene() {
        if textFieldsCheck() {
            let AnimationVC = EnterViewController()
            self.navigationController?.pushViewController(AnimationVC, animated: true)
            print("MOVE!!!!")
        }
    }
    
    @objc func handlePasswordChange() {
        guard let password = passwordTextField.text else { return }
        
        if password.count < 8 { // вынос парамсов в Constants и заверни ка кейсы покрасивше в функ
            passwordTextField.layer.borderWidth = 1
            passwordTextField.layer.borderColor = UIColor.red.cgColor
        } else {
            passwordTextField.layer.borderWidth = 0
            passwordTextField.layer.borderColor = nil
        }
    }
    
    struct Constants {
        static let cornerRadiusTextField: CGFloat = 15
        static let cornerRadiusButton: CGFloat = 10
        static let customSpacing: CGFloat = 40
    }
}
