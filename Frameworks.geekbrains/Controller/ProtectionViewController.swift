//
//  ProtectionViewController.swift
//  Frameworks.geekbrains
//
//  Created by Nikolai Ivanov on 12.04.2021.
//

import UIKit

class ProtectionViewController: UIViewController {
    
    private lazy var protectionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Durex"
        label.textColor = .systemBlue
        label.font = UIFont.systemFont(ofSize: 40)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(protectionLabel)
        
        NSLayoutConstraint.activate([
            protectionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            protectionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
