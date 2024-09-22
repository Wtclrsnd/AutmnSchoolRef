import UIKit

class ViewController: UIViewController {

    // MARK: - UI Components

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Зарегистрируйтесь\n в приложении, чтобы\n получить доступ к данным"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 3
        label.textAlignment = .left
        return label
    }()

    let loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Логин"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        
        
        textField.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        textField.layer.borderColor = CGColor(red: 134, green: 137, blue: 139, alpha: 1)
        
        textField.layer.cornerRadius = 15
       
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        
        return textField
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пароль"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        
        textField.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
        textField.layer.cornerRadius = 15
        
        return textField
    }()

    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Зарегистрироваться", for: .normal)
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(ViewController.self, action: #selector(handleLoginButtonTap), for: .touchUpInside)
        
        return button
    }()

    // MARK: - 

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        addObservers()
    }

    // MARK: - UI Setup

    func setupLayout() {
        view.backgroundColor = .white

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true

        view.addSubview(loginTextField)
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        loginTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true

        view.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 20).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true

        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40).isActive = true
        loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/5).isActive = true
    }

    // MARK: - Observers

    func addObservers() {
        passwordTextField.addTarget(self, action: #selector(handlePasswordChange), for: .editingChanged)
    }

    // MARK: - Actions

    @objc func handleLoginButtonTap() {
        guard let login = loginTextField.text, let password = passwordTextField.text else {
            print("Please fill in both login and password fields")
            return
        }

        if login.isEmpty || password.isEmpty {
            print("Please fill in both login and password fields")
            return
        }

        if password.count < 8 {
            print("Password should be at least 8 characters long")
            return
        }

        let nextViewController = NextViewController()
        nextViewController.modalPresentationStyle = .fullScreen
        present(nextViewController, animated: true, completion: nil)
    }

    @objc func handlePasswordChange() {
        guard let password = passwordTextField.text else { return }

        if password.count < 8 {
            passwordTextField.layer.borderWidth = 1
            passwordTextField.layer.borderColor = UIColor.red.cgColor
        } else {
            passwordTextField.layer.borderWidth = 0
            passwordTextField.layer.borderColor = nil
        }
    }
}

class NextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
}
