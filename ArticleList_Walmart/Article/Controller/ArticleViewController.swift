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
    var articleCoordinatorProtocol: ArticleCoordinatorProtocol!
    
    private let refreshControl = UIRefreshControl()
    private let spinner = UIActivityIndicatorView(style: .large)
    private var pendingRequestWorkItem: DispatchWorkItem?

    init(viewModel: ArticleViewModelProtocol, coordinator: ArticleCoordinatorProtocol? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.articleCoordinatorProtocol = coordinator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var searchBar: UISearchBar!
    var articleTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        edgesForExtendedLayout = []
        navigationController?.navigationBar.isHidden = true
        
        setupSearchBar()
        setupTableView()
        
        viewModel.getDataFromServer { [weak self] errorState in
            DispatchQueue.main.async {
                guard let self = self else { return }
        
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.spinner.stopAnimating()
                    guard let _ = errorState else {
                        self.articleTableView.reloadData()
                        return
                    }
                    self.showAlert(title: "Error", message: self.viewModel.errorMessage)
                }
            }
        }

        if articleCoordinatorProtocol == nil {
            articleCoordinatorProtocol = ArticleCoordinator(navigationController: navigationController)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search News"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.showsCancelButton = true
//        navigationItem.titleView = searchBar

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
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            articleTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            articleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            articleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            articleTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        articleTableView.refreshControl = refreshControl
        
        spinner.startAnimating()
//        spinner.hidesWhenStopped = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getArticleCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        if let article = viewModel.getArticle(at: indexPath.row) {
                cell.configure(with: article)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedArticle = viewModel.getArticle(at: indexPath.row)

//        let closure :((Article?) -> Void)? = { [weak self] updatedArticle in
//            guard let self = self,
//                  let updatedArticle = updatedArticle else { return }
//            
//            self.viewModel.updateArticle(at: indexPath.row, with: updatedArticle)
//            
//            DispatchQueue.main.async {
//                self.articleTableView.reloadRows(at: [indexPath], with: .none)
//            }
//        }
//        
//        articleCoordinatorProtocol?.showDetailScreen(article: selectedArticle, closure: closure)
        
        let detailsVC = DetailsViewController()
        detailsVC.article = selectedArticle
        detailsVC.indexPath = indexPath
        detailsVC.delegate = self
            
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension ArticleViewController {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pendingRequestWorkItem?.cancel()

                let requestWorkItem = DispatchWorkItem { [weak self] in
                    guard let self = self else { return }
                    self.viewModel.searchArticles(with: searchText)
                    DispatchQueue.main.async {
                        self.articleTableView.reloadData()
                    }
                }

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

extension ArticleViewController {
    
    @objc private func refreshData() {
        viewModel.getDataFromServer { [weak self] errorState in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.refreshControl.endRefreshing()  // stop spinner
                
                guard let _ = errorState else {
                    self.articleTableView.reloadData()
                    return
                }
                
                self.showAlert(title: "Error", message: self.viewModel.errorMessage)
            }
        }
    }

}

extension ArticleViewController: DetailsElementDelegate {
    func didUpdateArticle(_ article: Article, at indexPath: IndexPath) {
        viewModel.updateArticle(at: indexPath.row, with: article)
        
        print(article.author)
        print(article.comment)
        
        DispatchQueue.main.async {
            self.articleTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

extension ArticleViewController: ArticleTableViewCellDelegate {
    func didTapDeleteButton(for cell: ArticleTableViewCell) {
        guard let indexPath = articleTableView.indexPath(for: cell) else { return }
       
        viewModel.deleteArticle(at: indexPath.row)
                
        articleTableView.deleteRows(at: [indexPath], with: .fade)
    }
}
