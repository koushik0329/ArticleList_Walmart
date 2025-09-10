//
//  DetailsViewController.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/10/25.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var textField: UITextField! = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        return textField
    }()
        
    var article: Article?
    var closure: ((Article?) -> Void)?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
            
        textField.text = article?.title ?? ""
        view.addSubview(textField)
    
        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 120)
        ])
            
        navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .cancel,
                target: self,
                action: #selector(backToPreviousScreen)
            )
    }
    
    @objc func backToPreviousScreen() {
        article?.title = textField.text ?? ""
        
        guard let closure = closure else { return }
        closure(article)
        self.navigationController?.popViewController(animated: true)
    }
}
