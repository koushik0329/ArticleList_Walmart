//
//  MockArticleViewModel.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/11/25.
//


@testable import ArticleList_Walmart

class MockArticleViewModel: ArticleViewModelProtocol {
    var articleList: [Article] = []
    var visibleList: [Article] = []
    
    func getArticleCount() -> Int {
        articleList.count
    }
    
    func getArticle(at index: Int) -> Article? {
        if articleList.count > index {
            return articleList[index]
        }
        return Article(author: "koushik",
                       comment: "Mock Title",
                       description: "he is a working professional",
                       urlToImage: "image",
                       publishedAt: "today")
    }
    
    func getDataFromServer(closure: @escaping (() -> Void)) {
        // Mock some data
        articleList = [
            Article(author: "Test Author",
                    comment: "Mock Title",
                    description: "Mock description",
                    urlToImage: "mock.png",
                    publishedAt: "2025-09-11")
        ]
        closure()
    }
    
    func searchArticles(with query: String) {
        visibleList = articleList.filter {
            ($0.author ?? "").contains(query) ||
            ($0.description ?? "").contains(query)
        }
    }
    
    func resetSearch() {
        visibleList = articleList
    }
    
    func updateArticle(at index: Int, with updatedArticle: Article) {
        if index < articleList.count {
            articleList[index] = updatedArticle
        }
    }
}
