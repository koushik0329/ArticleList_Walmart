//
//  Country.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/18/25.
//

//https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json

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

