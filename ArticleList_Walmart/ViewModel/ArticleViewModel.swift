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
}

class ArticleViewModel : ArticleViewModelProtocol{
    var articles: [Article] = []
    
    var networkManager = NetworkManager.shared

    func getDataFromServer(closure: @escaping (() -> Void)) {
            networkManager.getData(from: Server.endPoint.rawValue) { [weak self] (fetchedList: ArticleList?) in
                guard let self = self else { return }
                self.articles = fetchedList?.articles ?? []
                closure()
        }
    }
        
    func getArticleCount() -> Int {
        return articles.count
    }
        
    func getArticle(at index: Int) -> Article? {
        guard index < articles.count else { return nil }
        return articles[index]
    }
}
