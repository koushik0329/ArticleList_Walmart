//
//  EmpViewController.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/21/25.
//

import UIKit

class EmpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var empLabel : UILabel!
    var empTableView : UITableView!
    
    var viewModel : EmpViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
        setupTableView()
    }
    
    init(viewModel : EmpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel(){
        empLabel = UILabel()
        empLabel.text = "Employee List"
        empLabel.textAlignment = .center
        empLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        empLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(empLabel)
        
        NSLayoutConstraint.activate([
            empLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            empLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func setupTableView(){
        empTableView = UITableView()
        empTableView.delegate = self
        empTableView.dataSource = self
        empTableView.register(EmpTableViewCell.self, forCellReuseIdentifier: "cell")
        empTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(empTableView)
        
        NSLayoutConstraint.activate([
            empTableView.topAnchor.constraint(equalTo: empLabel.bottomAnchor, constant: 5),
            empTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            empTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            empTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getEmpCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EmpTableViewCell
        let emp = viewModel.getEmpList(at: indexPath.row)
        cell.configure(with: emp)
        return cell
    }
}
