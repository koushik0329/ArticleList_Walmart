//
//  ArticleTableViewCell.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/8/25.
//

import UIKit

protocol ArticleTableViewCellDelegate: AnyObject {
    func didTapDeleteButton(for cell: ArticleTableViewCell)
}

class ArticleTableViewCell: UITableViewCell {
    
    weak var delegate: ArticleTableViewCellDelegate?
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let publishedDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let squareIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "square.and.arrow.up")
        imageView.tintColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.systemRed, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupCell() {
        contentView.addSubview(authorLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(articleImageView)
        contentView.addSubview(publishedDateLabel)
        contentView.addSubview(squareIcon)
        contentView.addSubview(deleteButton)
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: articleImageView.leadingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: articleImageView.leadingAnchor, constant: -8),
            
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            articleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            articleImageView.heightAnchor.constraint(equalToConstant: 90),
            articleImageView.widthAnchor.constraint(equalToConstant: 90),
  
            deleteButton.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 4),
            deleteButton.centerXAnchor.constraint(equalTo: articleImageView.centerXAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 60),
            deleteButton.heightAnchor.constraint(equalToConstant: 25),
            
            squareIcon.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            squareIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            squareIcon.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            squareIcon.heightAnchor.constraint(equalToConstant: 16),
            squareIcon.widthAnchor.constraint(equalToConstant: 16),
            
            publishedDateLabel.centerYAnchor.constraint(equalTo: squareIcon.centerYAnchor),
            publishedDateLabel.leadingAnchor.constraint(equalTo: squareIcon.trailingAnchor, constant: 8),
            publishedDateLabel.trailingAnchor.constraint(equalTo: articleImageView.leadingAnchor, constant: -8),

            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: deleteButton.bottomAnchor, constant: 8)
        ])
    }
    
    
    // MARK: Configure Cell
    @MainActor
    func configure(with article: Article) {
        authorLabel.text = article.author
        descriptionLabel.text = article.description
        publishedDateLabel.text = article.publishedDateOnly
        
        Task {
            guard let urlString = article.urlToImage else {
                self.articleImageView.image = UIImage(systemName: "photo.trianglebadge.exclamationmark.fill")
                return
            }
            
            let fetchedState = await NetworkManager.shared.getData(from: urlString)
            switch fetchedState {
            case .isLoading, .invalidURL, .errorFetchingData, .noDataFromServer:
                self.articleImageView.image = UIImage(systemName: "photo.trianglebadge.exclamationmark.fill")
            case .success(let fetchedData):
                self.articleImageView.image = UIImage(data: fetchedData)

            }
        }
    }
    
    @objc private func deleteButtonTapped() {
        delegate?.didTapDeleteButton(for: self)
    }
}

