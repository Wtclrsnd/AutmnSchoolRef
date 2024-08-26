//
//  ValidatableTextField.swift
//  AutumnSchool
//
//  Created by Polina Popova on 19/08/2024.
//

import UIKit

class ValidatableTextField: UIStackView {
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.layer.borderColor = CGColor(red: 231, green: 233, blue: 237, alpha: 1)
        
        
        textField.borderStyle = .roundedRect
        layer.cornerRadius = 15
        textField.layer.cornerRadius = 15
       
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.layer.borderColor = CGColor(red: 134, green: 137, blue: 139, alpha: 1)
        
        return textField
    }()
    
    var text: String? {
        get {
            textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    var underlyingTextField: UITextField {
        textField
    }
    
    init() {
        super.init(frame:.zero)
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("ERROR ValidatableTextField")
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setup(placeholder: String?) {
        textField.placeholder = placeholder
        textField.frame = CGRect(x: 10, y: 10, width: 200, height: 46)
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        
    }
    
    private func setupLayout() {
        backgroundColor = .white
        spacing = 16
        axis = .vertical
        
        addArrangedSubview(textField)
        setCustomSpacing(8, after: textField)
        
    }
    
}
