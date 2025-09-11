//
//  ArticleViewModel.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/8/25.
//

protocol ArticleViewModelProtocol {
    func getDataFromServer(closure: @escaping (() -> Void))
    func getArticleCount() -> Int
    func getArticle(at index: Int) -> Article?
    func searchArticles(with: String)
    func resetSearch()
}

class ArticleViewModel: ArticleViewModelProtocol {
    var articles: [Article] = []
    var filteredArticles: [Article] = []
    var isSearching: Bool = false
    
    var networkManager = NetworkManager.shared

    func getDataFromServer(closure: @escaping (() -> Void)) {
        networkManager.getData(from: Server.endPoint.rawValue) { [weak self] data in
            guard let self = self else { return }
            
            let fetchedList = self.networkManager.parse(data: data)
            self.articles = fetchedList?.articles ?? []
            self.filteredArticles = self.articles
            
            closure()
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

