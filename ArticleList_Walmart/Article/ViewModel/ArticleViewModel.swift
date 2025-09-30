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
    func getDataFromServer() async
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
    
    var errorState: ServiceError?
    
//    var networkManager = NetworkManager.shared
//    private let networkManager: NetworkManagerProtocol
    private let serviceManager: ServiceManagerProtocol

    init(serviceManager: ServiceManagerProtocol = ServiceManager.shared) {
        self.serviceManager = serviceManager
        self.articles = []
    }

    @MainActor
    func getDataFromServer() async {
        do {
            let fetchedList: ArticleList = try await serviceManager.getData(from: Server.endPoint.rawValue, type: ArticleList.self)
            self.articles = fetchedList.articles ?? []
        } catch let error as ServiceError {
            self.errorState = error
        } catch {
            self.errorState = .networkState(.errorFetchingDat(error))
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
        case .networkState(let state):
            switch state {
            case .invalidURL:
                return "Invalid URL"
            case .invalidResponse(let statusCode):
                return "Invalid response with status code \(statusCode)."
            case .errorFetchingDat(let err):
                return "Error fetching data: \(err.localizedDescription)"
            case .noDataFromServer:
                return "No data from server"
            default:
                return ""
            }
        }
    }
}
