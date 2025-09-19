//
//  CountryTableViewCell.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/18/25.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    let countryNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    let codeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    let capitalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        contentView.addSubview(countryNameLabel)
        contentView.addSubview(codeLabel)
        contentView.addSubview(capitalLabel)
        
        countryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        capitalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
               countryNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
               countryNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),

               codeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
               codeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

               capitalLabel.topAnchor.constraint(equalTo: countryNameLabel.bottomAnchor, constant: 7),
               capitalLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
           ])
    }
    
    func configure(with country: Country){
        countryNameLabel.text = "\(country.name ?? ""), \(country.region ?? "")"
        codeLabel.text = country.code
        capitalLabel.text = country.capital
    }
}
