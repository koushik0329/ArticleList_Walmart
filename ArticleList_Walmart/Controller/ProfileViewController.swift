//
//  LandingViewController.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 10/1/25.
//

import UIKit

class ProfileViewController : UIViewController {
    let textLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let logoutButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(textLabel)
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            logoutButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 20),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        if let username = UserDefaults.standard.string(forKey: "userName") {
            textLabel.text = "Hello, \(username)"
        } else {
            textLabel.text = "Hello, Guest"
        }
    }
    
    @objc func logoutTapped() {
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let window = sceneDelegate.window
            window?.rootViewController = LoginViewController()
            window?.makeKeyAndVisible()
        }
    }
}
