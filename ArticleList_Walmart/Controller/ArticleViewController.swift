//
//  ArticleViewController.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/8/25.
//

import UIKit

class ArticleViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private let viewModel = ArticleViewModel()
    
    var searchBar: UISearchBar!
    var articleTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupSearchBar()
        setupTableView()
        
        viewModel.getDataFromServer { [weak self] in
                DispatchQueue.main.async {
                    self?.articleTableView.reloadData()
                }
            }
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search News"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupTableView() {
        articleTableView = UITableView()
        articleTableView.translatesAutoresizingMaskIntoConstraints = false
        articleTableView.dataSource = self
        articleTableView.delegate = self
        articleTableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "ArticleCell")
        view.addSubview(articleTableView)
        
        NSLayoutConstraint.activate([
            articleTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            articleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            articleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            articleTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getArticleCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleTableViewCell else {
            return UITableViewCell()
        }
        
        if let article = viewModel.getArticle(at: indexPath.row) {
                cell.configure(with: article)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
