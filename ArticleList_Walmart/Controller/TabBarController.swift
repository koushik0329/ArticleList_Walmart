//
//  TabBarController.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/17/25.
//


import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        
    }
    
    func setupTabBar() {
        let networkManager = NetworkManager.shared
        let viewModel = ArticleViewModel(networkManager: networkManager)

        let articleViewController = ArticleViewController(viewModel: viewModel)
        let articleNavController = UINavigationController(rootViewController: articleViewController)
        articleNavController.tabBarItem = UITabBarItem(
            title: "Article",
            image: UIImage(systemName: "newspaper"),
            tag: 0
        )
        
        let countryViewModel = CountryViewModel(networkManager: networkManager)
        let countryViewController = CountryViewController(countryViewModel: countryViewModel)
        let countryNavController = UINavigationController(rootViewController: countryViewController)
        countryNavController.tabBarItem = UITabBarItem(
            title: "Country",
            image: UIImage(systemName: "flag"),
            tag: 1
        )

        let addProductViewController = EmpViewController(viewModel : EmpViewModel())
        let addNavController = UINavigationController(rootViewController: addProductViewController)
        addNavController.tabBarItem = UITabBarItem(
            title: "Add",
            image: UIImage(systemName: "plus"),
            tag: 2
        )

        let profileViewController = ProfileViewController()
        let profileNavController = UINavigationController(rootViewController: profileViewController)
        profileNavController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            tag: 3
        )

        self.viewControllers = [articleNavController, countryNavController, addNavController, profileNavController]

    }
}
