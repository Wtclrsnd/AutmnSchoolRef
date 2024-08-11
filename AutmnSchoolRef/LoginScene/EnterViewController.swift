//
//  EnterViewController.swift
//  AutmnSchoolRef
//
//  Created by Emil Shpeklord on 20.07.2024.
//

import UIKit

class EnterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        dismiss(animated: true)
    }

}

