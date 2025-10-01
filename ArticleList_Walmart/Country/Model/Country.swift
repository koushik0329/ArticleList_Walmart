//
//  Country.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/18/25.
//


struct Country: Decodable {
    let capital: String?
    let code: String?
    let name: String?
    let region: String?

    enum CodingKeys: String, CodingKey {
        case capital = "capital"
        case code = "code"
        case name = "name"
        case region = "region"   
    }
}

