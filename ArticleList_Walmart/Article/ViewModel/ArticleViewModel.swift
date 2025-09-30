//
//  ArticleViewModel.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/8/25.
//

import Foundation

@propertyWrapper
struct Searchable<T> {
    private var items: [T] = []
    private(set) var filteredItems: [T] = []
    private var filter: (T, String) -> Bool
    
    var wrappedValue: [T] {
        get { filteredItems }
        set {
            items = newValue
            filteredItems = newValue
        }
    }
    
    var projectedValue: Searchable<T> {
        get { self }
    }
    
    init(filter: @escaping (T, String) -> Bool) {
        self.filter = filter
    }
    
    mutating func search(_ query: String) {
        if query.isEmpty {
            filteredItems = items
        } else {
            filteredItems = items.filter { filter($0, query) }
        }
    }
    
    mutating func reset() {
        filteredItems = items
    }
}

protocol ArticleViewModelProtocol {
    func getDataFromServer(closure: @escaping ((NetworkState?) -> Void))
    func getArticleCount() -> Int
    func getArticle(at index: Int) -> Article?
    var errorMessage: String { get }
    func searchArticles(with: String)
    func resetSearch()
    func updateArticle(at index: Int, with updatedArticle: Article)
    func deleteArticle(at index: Int)
}

class ArticleViewModel: ArticleViewModelProtocol {
    
    @Searchable<Article>(filter: { article, query in
        (article.author?.lowercased().contains(query.lowercased()) ?? false) ||
        (article.description?.lowercased().contains(query.lowercased()) ?? false)
    })
    
    var articles: [Article]
//    var filteredArticles: [Article] = []
//    var isSearching: Bool = false
    
    var errorState: NetworkState?
    
//    var networkManager = NetworkManager.shared
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        self.articles = []
    }

    func getDataFromServer(closure: @escaping (NetworkState?) -> Void) {
        networkManager.getData(from: Server.endPoint.rawValue) { [weak self] fetchedState in
            guard let self = self else { return }
            
//            print("Api call", Server.endPoint.rawValue)
            
            switch fetchedState {
            case .isLoading, .invalidURL, .errorFetchingData, .noDataFromServer:
                self.errorState = fetchedState
                break
            case .success(let fetchedData):
                if let fetchedList = self.networkManager.parse(data: fetchedData, type: ArticleList.self) {
                    self.articles = fetchedList.articles ?? []
//                    self.filteredArticles = self.articles
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
        return articles.count
    }

    func getArticle(at index: Int) -> Article? {
        guard index < articles.count else { return nil }
        return articles[index]
    }

    func searchArticles(with query: String) {
        _articles.search(query)
    }

    func resetSearch() {
        _articles.reset()
    }
    
    func updateArticle(at index: Int, with updatedArticle: Article) {
        if index < articles.count {
            articles[index] = updatedArticle
        }
        
//        if !filteredArticles.isEmpty && index < filteredArticles.count {
//            filteredArticles[index] = updatedArticle
//        }
    }
    
    func deleteArticle(at index: Int) {
        if index < articles.count {
            articles.remove(at: index)
        }
        
//        if !filteredArticles.isEmpty && index < filteredArticles.count {
//            filteredArticles.remove(at: index)
//        }
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
