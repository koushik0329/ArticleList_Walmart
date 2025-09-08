//
//  Artist.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/8/25.
//

//https://gist.githubusercontent.com/congsun/600f3ad57298f9dbc23fedf6b2b25450/raw/73d7a8ed589652339ae3646d0a595298ce5e72c2/newsFeed.json

struct ArtistList : Codable {
    var articles : [Artist]?
}

struct Artist : Codable {
    let author : String?
    let description : String?
    let image : String?
    let published_date : String?
}
