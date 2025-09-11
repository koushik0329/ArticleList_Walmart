//
//  MockNetworkManager.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/11/25.
//

import Foundation

class MockNetworkManager: NetworkManagerProtocol {
    static let shared = MockNetworkManager()
    private init() {}
    
    func getData(from serverUrl: String, closure: @escaping (Data?) -> Void) {
        let articleJsonString: String = """
        {
         "status": "ok",
         "totalResults": 3457,
         "articles": [
           {
             "source": {
               "id": null,
               "name": "Seekingalpha.com"
             },
             "author": "Victor Dergunov",
             "title": "Tesla: The Top Is Here",
             "description": "To say that Tesla has been on fire lately is an understatement...",
             "url": "https://seekingalpha.com/article/4321590-tesla-top-is",
             "urlToImage": "https://static.seekingalpha.com/uploads/2020/2/5/48200183-15809104384836764_origin.jpg",
             "publishedAt": "2020-02-05T15:47:40Z",
             "content": "Image Source..."
           }
         ]
        }
        """
        
        let data = articleJsonString.data(using: .utf8)
        closure(data)
    }
    
    func parse(data: Data?) -> ArticleList? {
        guard let data = data else {
            print("No data to parse")
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let fetchedResult = try decoder.decode(ArticleList.self, from: data)
            return fetchedResult
        } catch {
            print("Mock parse error: \(error)")
            return nil
        }
    }
}
