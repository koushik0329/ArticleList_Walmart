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
            title: "DashBoard",
            image: UIImage(systemName: "house"),
            tag: 0
        )

        let cartViewController = CartViewController()
        let cartNavController = UINavigationController(rootViewController: cartViewController)
        cartNavController.tabBarItem = UITabBarItem(
            title: "Cart",
            image: UIImage(systemName: "cart"),
            tag: 1
        )

        let addProductViewController = AddProductViewController()
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

        self.viewControllers = [articleNavController, cartNavController, addNavController, profileNavController]

    }
}
