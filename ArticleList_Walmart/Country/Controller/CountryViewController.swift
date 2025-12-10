//
//  CountryViewController.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/18/25.
//

import UIKit

class CountryViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var retryCount: Int = 0
    
    var countryLabel: UILabel!
    var searchBar: UISearchBar!
    var countryTableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    var countryViewModel: CountryViewModel!
    
    init(countryViewModel: CountryViewModel) {
        self.countryViewModel = countryViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupSearchBar()
        setupTableView()
        
        edgesForExtendedLayout = []
        navigationController?.navigationBar.isHidden = true
        
        fetchCountries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupUI() {
        countryLabel = UILabel()
        countryLabel.text = "Countries"
        countryLabel.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(countryLabel)
        
        NSLayoutConstraint.activate([
            countryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            countryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.placeholder = "Search by Name or Capital"
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: countryLabel.bottomAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupTableView() {
        countryTableView = UITableView()
        countryTableView.translatesAutoresizingMaskIntoConstraints = false
        countryTableView.delegate = self
        countryTableView.dataSource = self
        countryTableView.register(CountryTableViewCell.self, forCellReuseIdentifier: "countryCell")
        view.addSubview(countryTableView)
        
        NSLayoutConstraint.activate([
            countryTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            countryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            countryTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        countryTableView.refreshControl = refreshControl
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryViewModel.getCountryCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as? CountryTableViewCell else {
            return UITableViewCell()
        }
        
        let country = countryViewModel.getCountry(at: indexPath.row)
        cell.configure(with: country)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        countryViewModel.searchCountry(text: searchText)
        countryTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        countryViewModel.searchCountry(text: "")
        countryTableView.reloadData()
    }
    
    @objc private func refreshData() {
        fetchCountries(isRefreshing: true)
    }
}

extension CountryViewController : RetryAlertDelegate {
 
    func didTapTryAgain() {
        fetchCountries(isRefreshing: false, retryCount: (retryCount)+1)
    }
    
    func didTapOK() {
        navigationController?.popViewController(animated: true)
    }
}

extension CountryViewController {
    @MainActor
    func fetchCountries(isRefreshing: Bool = false, retryCount: Int = 0) {
        Task {
            
            if retryCount >= 3 {
                print("Using Core Data because retry limit reached")
                let loaded = countryViewModel.getCountriesFromCoreData()
                    
                if loaded {
                    countryTableView.reloadData()
                } else {
                    showAlert(title: "Error", message: "No offline data available.", retryCount: retryCount, delegate: self)
                }
                return
            }
            
            let errorState = await countryViewModel.getCountriesFromServer()
            
            if isRefreshing {
                refreshControl.endRefreshing()
            }
            
            if errorState == nil {
                self.retryCount = 0
                countryTableView.reloadData()
            }
            else {
                self.retryCount = retryCount
                showAlert(title: "Error", message: countryViewModel.errorMessage, retryCount: retryCount, delegate: self)
            }
        }
    }
}
