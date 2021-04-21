//
//  LoginViewController.swift
//  Frameworks.geekbrains
//
//  Created by Nikolai Ivanov on 07.04.2021.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    
    private lazy var loginView: LoginView = {
        LoginView()
    }()
    private let realm = try? Realm()

    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        hideKeyboardWhenTappedAround()
        
        setupLoginButton()
        loginView.signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    }
    
    private func setupLoginButton() {
        Observable
            .combineLatest(
                loginView.loginTextField.rx.text,
                loginView.passwordTextField.rx.text
            )
            .map { login, password in
                return !(login ?? "").isEmpty && (password ?? "").count >= 6
            }
            .bind { [weak self] inputFilled in
                self?.loginView.loginButton.backgroundColor = inputFilled ? .systemBlue : .systemGray
                self?.loginView.loginButton.isEnabled = inputFilled
            }
        
        loginView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    @objc private func login() {
        guard let login = loginView.loginTextField.text?.lowercased(), let password = loginView.passwordTextField.text?.lowercased()
        else { return }
        checkUser(login: login, password: password)
    }
    
    private func checkUser(login: String, password: String) {
        if let user = realm?.object(ofType: User.self, forPrimaryKey: login) {
            if user.password == password {
                presentMapViewController()
            } else {
                showWrongLoginData()
            }
        } else {
            showWrongLoginData()
        }
    }
    
    private func presentMapViewController() {
        let navigationController = UINavigationController(rootViewController: MapViewController())
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    private func showWrongLoginData() {
        let alert = UIAlertController(title: "Error", message: "Wrong data", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        clearTextFields()
    }
    
    @objc private func signUp() {
        guard let login = loginView.loginTextField.text?.lowercased(), let password = loginView.passwordTextField.text?.lowercased()
        else { return }
        
        if let user = realm?.object(ofType: User.self, forPrimaryKey: login) {
            try? realm?.write {
                user.password = password
                realm?.add(user, update: .all)
            }
            clearTextFields()
        } else {
            registerNewUser(login: login, password: password)
        }
    }
    
    private func registerNewUser(login: String, password: String) {
        let user = User()
        user.login = login
        user.password = password
        
        try? realm?.write {
            realm?.add(user)
        }
        
        clearTextFields()
    }
    
    private func clearTextFields() {
        loginView.loginTextField.text = ""
        loginView.passwordTextField.text = ""
    }
}
