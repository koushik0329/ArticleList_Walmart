//
//  ArticleViewModel.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/8/25.
//

import Foundation

protocol ArticleViewModelProtocol {
    func getDataFromServer(closure: @escaping ((NetworkState?) -> Void))
    func getArticleCount() -> Int
    func getArticle(at index: Int) -> Article?
    var errorMessage: String { get }
    func searchArticles(with: String)
    func resetSearch()
    func updateArticle(at index: Int, with updatedArticle: Article)
}

class ArticleViewModel: ArticleViewModelProtocol {
    var articles: [Article] = []
    var filteredArticles: [Article] = []
    var isSearching: Bool = false
    
    var errorState: NetworkState?
    
//    var networkManager = NetworkManager.shared
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func getDataFromServer(closure: @escaping (NetworkState?) -> Void) {
        networkManager.getData(from: Server.endPoint.rawValue) { [weak self] fetchedState in
            guard let self = self else { return }
            
            sleep(1)
            print("Api call", Server.endPoint.rawValue)
            
            switch fetchedState {
            case .isLoading, .invalidURL, .errorFetchingData, .noDataFromServer:
                self.errorState = fetchedState
                break
            case .success(let fetchedData):
                if let fetchedList = self.networkManager.parse(data: fetchedData) {
                    self.articles = fetchedList.articles ?? []
                    self.filteredArticles = self.articles
                }
                else {
                    self.errorState = .noDataFromServer
                }
            }
            
            DispatchQueue.main.async {
                closure(self.errorState)
            }
            
//            let fetchedList = self.networkManager.parse(data: data)
//            self.articles = fetchedList?.articles ?? []
//            self.filteredArticles = self.articles
            
//            DispatchQueue.main.async {
//                closure(self.errorState)
//            }
        }
    }

    func getArticleCount() -> Int {
        return filteredArticles.count
    }

    func getArticle(at index: Int) -> Article? {
        guard index < filteredArticles.count else { return nil }
        return filteredArticles[index]
    }

    func searchArticles(with query: String) {
        if query.isEmpty {
            filteredArticles = articles
            isSearching = false
        } else {
            filteredArticles = articles.filter { article in
                (article.author?.lowercased().contains(query.lowercased()) ?? false) ||
                (article.description?.lowercased().contains(query.lowercased()) ?? false)
            }
            isSearching = true
        }
    }

    func resetSearch() {
        filteredArticles = articles
        isSearching = false
    }
    
    func updateArticle(at index: Int, with updatedArticle: Article) {
        if index < articles.count {
            articles[index] = updatedArticle
        }
        
        if !filteredArticles.isEmpty && index < filteredArticles.count {
            filteredArticles[index] = updatedArticle
        }
    }
}

extension ArticleViewModel {
    var errorMessage: String {
        guard let errorState = errorState else { return "" }
        switch errorState {
        case .invalidURL:
            return "Invalid URL"
        case .errorFetchingData:
            return "Error fetching data"
        case .noDataFromServer:
            return "No data from server"
        default :
            return ""
        }
    }
}
