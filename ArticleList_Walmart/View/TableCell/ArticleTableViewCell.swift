//
//  ArticleTableViewCell.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/8/25.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
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
        
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: articleImageView.leadingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: articleImageView.leadingAnchor, constant: -8),
            
            articleImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            articleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            articleImageView.heightAnchor.constraint(equalToConstant: 90),
            articleImageView.widthAnchor.constraint(equalToConstant: 90),
            
            squareIcon.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            squareIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            squareIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            squareIcon.heightAnchor.constraint(equalToConstant: 16),
            squareIcon.widthAnchor.constraint(equalToConstant: 16),
            
            publishedDateLabel.centerYAnchor.constraint(equalTo: squareIcon.centerYAnchor),
            publishedDateLabel.leadingAnchor.constraint(equalTo: squareIcon.trailingAnchor, constant: 8),
            publishedDateLabel.trailingAnchor.constraint(equalTo: articleImageView.leadingAnchor, constant: -8)
        ])
    }
    
    
    // MARK: Configure Cell
    func configure(with article: Article) {
        authorLabel.text = article.author
        descriptionLabel.text = article.description
        publishedDateLabel.text = article.publishedDateOnly
        
        guard let imageUrl = article.urlToImage else {
                articleImageView.image = UIImage(systemName: "photo") // fallback image
                return
            }
            
        NetworkManager.shared.getData(from: imageUrl) { [weak self] data in
            guard let self = self, let data = data, let image = UIImage(data: data) else { return }
                
            DispatchQueue.main.async {
                self.articleImageView.image = image
            }
        }
    }
}
