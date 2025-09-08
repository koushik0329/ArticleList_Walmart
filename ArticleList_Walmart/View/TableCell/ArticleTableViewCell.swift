//
//  ArticleTableViewCell.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/8/25.
//
import UIKit

class ArticleTableViewCell : UITableViewCell {
    
    let authorLabel = UILabel()
    let descriptionLabel = UILabel()
    let articleImageView = UIImageView()
    let publishedDateLabel = UILabel()
    let sqaureIcon = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        authorLabel.font = UIFont.systemFont(ofSize: 16)
        authorLabel.textColor = .systemBlue
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(authorLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .label
        contentView.addSubview(descriptionLabel)
        
        articleImageView.contentMode = .scaleAspectFit
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(articleImageView)
        
        publishedDateLabel.font = UIFont.systemFont(ofSize: 14)
        publishedDateLabel.textColor = .label
        contentView.addSubview(publishedDateLabel)
        
        sqaureIcon.image = UIImage(systemName: "square.and.arrow.up")
        sqaureIcon.tintColor = .systemBlue
        sqaureIcon.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sqaureIcon)
        
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            authorLabel.heightAnchor.constraint(equalToConstant: 20),
            
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            
            articleImageView.leadingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor, constant: 10),
            articleImageView.heightAnchor.constraint(equalToConstant: 60),
            articleImageView.widthAnchor.constraint(equalToConstant: 60),
            
            sqaureIcon.topAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: 8),
            sqaureIcon.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            sqaureIcon.heightAnchor.constraint(equalToConstant: 20),
            sqaureIcon.widthAnchor.constraint(equalToConstant: 20),
            
            publishedDateLabel.leadingAnchor.constraint(equalTo: sqaureIcon.trailingAnchor, constant: 10),
            
        ])
    }
    
    func configure(with article: Article) {
        authorLabel.text = article.author
        descriptionLabel.text = article.description
//        articleImageView.image = UIImage(named: article.image)
        publishedDateLabel.text = article.published_date
    }
}
