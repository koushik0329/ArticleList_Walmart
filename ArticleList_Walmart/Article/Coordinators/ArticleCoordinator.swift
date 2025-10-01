//
//  ArticleCoordinator.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/15/25.
//


import UIKit

protocol ArticleCoordinatorProtocol {
    func showDetailScreen(article : Article?)
}

final class ArticleCoordinator: ArticleCoordinatorProtocol {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func showDetailScreen(article : Article?) {
        guard let navigationController = navigationController else { return }
        let detailsVC = DetailsViewController()
        detailsVC.article = article
        navigationController.pushViewController(detailsVC, animated: true)
    }
}
