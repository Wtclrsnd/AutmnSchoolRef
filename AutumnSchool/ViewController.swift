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
        return textField
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пароль"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()

    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Зарегистрироваться", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleLoginButtonTap), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        
        return button
    }()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    // MARK: - UI Setup

    func setupLayout() {
        view.backgroundColor = .white

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true

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
        //loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2/5).isActive = true
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

        // Here you can implement your actual login logic
        // For now, let's just present a new view controller
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
