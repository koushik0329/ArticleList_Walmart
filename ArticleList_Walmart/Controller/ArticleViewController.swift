//
//  ArticleViewController.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/8/25.
//

import UIKit

class ArticleViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
//    private let viewModel = ArticleViewModel()
    
    var viewModel: ArticleViewModelProtocol!

    init(viewModel: ArticleViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private var searchTimer: Timer?
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    var updateClosure: ((Article?) -> Void?)? = nil
    
    var searchBar: UISearchBar!
    var articleTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupSearchBar()
        setupTableView()
        
        viewModel.getDataFromServer { [weak self] errorState in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                                
//                    self.articleTableView.reloadData()
                    guard let _ = errorState else {
                        self.articleTableView.reloadData()
                        return
                    }
                    
                    self.showAlert(title: "Error", message: self.viewModel.errorMessage)
                }
            }
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search News"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.showsCancelButton = true
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = DetailsViewController()
        
        let selectedArticle = viewModel.getArticle(at: indexPath.row)
        
        detailsVC.article = selectedArticle
        detailsVC.closure = { [weak self] updatedArticle in
            guard let self = self,
                  let updatedArticle = updatedArticle else { return }

            self.viewModel.updateArticle(at: indexPath.row, with: updatedArticle)

            DispatchQueue.main.async {
                self.articleTableView.reloadRows(at: [indexPath], with: .none)
            }
                            }
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension ArticleViewController {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchTimer?.invalidate()
//            
//        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in guard let self = self else { return }
//                
//        self.viewModel.searchArticles(with: searchText)
//        self.articleTableView.reloadData()
//        }
        
        // Cancel the currently pending item (if any)
        pendingRequestWorkItem?.cancel()
                
        // Wrap the new request in a work item
        let requestWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.viewModel.searchArticles(with: searchText)
            self.articleTableView.reloadData()
        }
                
        // Save the new work item and execute it after a delay (debounce interval)
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: requestWorkItem)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.resetSearch()
        articleTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
