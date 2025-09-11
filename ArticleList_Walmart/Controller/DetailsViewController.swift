//
//  DetailsViewController.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/10/25.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private let commentTextField: UITextField = {
        let commentTextField = UITextField()
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        commentTextField.font = UIFont.systemFont(ofSize: 14)
        commentTextField.textColor = .label
        commentTextField.backgroundColor = .systemGray6
        commentTextField.placeholder = "Enter your comment"
        return commentTextField
    }()
    
    private var authorTextField: UITextField = {
        var authorTextField = UITextField()
        authorTextField.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        authorTextField.textColor = .systemBlue
        authorTextField.translatesAutoresizingMaskIntoConstraints = false
        authorTextField.borderStyle = .roundedRect
        authorTextField.placeholder = "Enter author name"
        return authorTextField
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .systemGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    private let articleImageView: UIImageView = {
        let articleImageView = UIImageView()
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        articleImageView.layer.cornerRadius = 8
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        return articleImageView
    }()
        
    var article: Article?
    var closure: ((Article?) -> Void)?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureDetails()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(authorTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(articleImageView)
        view.addSubview(commentTextField)
        
        // AutoLayout
        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            articleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            articleImageView.widthAnchor.constraint(equalToConstant: 100),
            articleImageView.heightAnchor.constraint(equalToConstant: 100),
            
            authorTextField.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 20),
            authorTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            authorTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: authorTextField.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: authorTextField.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: authorTextField.trailingAnchor),
            
            commentTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            commentTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            commentTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            commentTextField.heightAnchor.constraint(equalToConstant: 120)
        ])
            
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(backToPreviousScreen)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveAction)
        )
    }
    
    private func configureDetails() {
        authorTextField.text = article?.author
        descriptionLabel.text = article?.description
        
        if let imageUrlString = article?.urlToImage, let imageUrl = URL(string: imageUrlString) {
            NetworkManager.shared.getData(from: imageUrl.absoluteString) { [weak self] data in
                guard let self = self,
                      let data = data,
                      let image = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    self.articleImageView.image = image
                }
            }
        } else {
            articleImageView.image = UIImage(systemName: "photo")
        }
    }

    @objc private func backToPreviousScreen() {
        article?.comment =  commentTextField.text!
        closure?(article)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveAction() {
        article?.author = authorTextField.text ?? ""
        closure?(article)
        navigationController?.popViewController(animated: true)
    }
}
