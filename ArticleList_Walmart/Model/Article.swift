//
//  Artist.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/8/25.
//

//https://gist.githubusercontent.com/congsun/600f3ad57298f9dbc23fedf6b2b25450/raw/73d7a8ed589652339ae3646d0a595298ce5e72c2/newsFeed.json

struct ArticleList : Decodable {
    var articles : [Article]?
}

struct Article: Decodable {
    let author: String?
    var comment: String
    let description: String?
    let urlToImage: String?
    let publishedAt: String?
    
    var publishedDateOnly: String {
        guard let publishedAt = publishedAt, publishedAt.count >= 10 else { return "" }
        return String(publishedAt.prefix(10))
    }

    enum CodingKeys: String, CodingKey {
        case author, description
        case urlToImage
        case publishedAt
        case comment = "title"
    }
}

