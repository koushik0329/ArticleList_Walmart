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
        authorLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        authorLabel.textColor = .systemBlue
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(authorLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .systemGray
        contentView.addSubview(descriptionLabel)
        
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        articleImageView.layer.cornerRadius = 8
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(articleImageView)
        
        publishedDateLabel.font = UIFont.systemFont(ofSize: 13)
        publishedDateLabel.textColor = .lightGray
        publishedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(publishedDateLabel)
        
        sqaureIcon.image = UIImage(systemName: "square.and.arrow.up")
        sqaureIcon.tintColor = .systemBlue
        sqaureIcon.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sqaureIcon)
        
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
            
            sqaureIcon.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            sqaureIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sqaureIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            sqaureIcon.heightAnchor.constraint(equalToConstant: 16),
            sqaureIcon.widthAnchor.constraint(equalToConstant: 16),
            
            publishedDateLabel.centerYAnchor.constraint(equalTo: sqaureIcon.centerYAnchor),
            publishedDateLabel.leadingAnchor.constraint(equalTo: sqaureIcon.trailingAnchor, constant: 8),
            publishedDateLabel.trailingAnchor.constraint(equalTo: articleImageView.leadingAnchor, constant: -8)
        ])
    }
    
    func configure(with article: Article) {
        authorLabel.text = article.author
        descriptionLabel.text = article.description

        if let urlString = article.urlToImage, let url = URL(string: urlString) {
            loadImage(from: url)
        }

        if let publishedAt = article.publishedAt {
            publishedDateLabel.text = formatDate(publishedAt)
        }
    }

    
    private func loadImage(from url: URL) {
        articleImageView.image = UIImage(systemName: "photo")
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self?.articleImageView.image = image
            }
        }.resume()
    }
    
    private func formatDate(_ dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd-MM-yyyy"

        if let date = isoFormatter.date(from: dateString) {
            return displayFormatter.string(from: date)
        }

        // fallback if fractional seconds exist
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: dateString) {
            return displayFormatter.string(from: date)
        }

        return dateString
    }

}
