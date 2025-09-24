//
//  EmpTableViewCell.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/21/25.
//
import UIKit

class EmpTableViewCell: UITableViewCell {
    
    var empNameLabel: UILabel!
    var empIdLabel: UILabel!
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTable() {
        empNameLabel = UILabel()
        empNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        empNameLabel.textColor = .label
        empNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(empNameLabel)
        
        empIdLabel = UILabel()
        empIdLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        empIdLabel.textColor = .secondaryLabel
        empIdLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(empIdLabel)
        
        NSLayoutConstraint.activate([
            empNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            empNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            empIdLabel.topAnchor.constraint(equalTo: empNameLabel.bottomAnchor, constant: 4),
            empIdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
    }
    
    func configure(with employee: Emp) {
        empNameLabel.text = employee.name
        empIdLabel.text = "Employee ID: \(employee.id)"
    }
    
}
