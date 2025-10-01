//
//  NetworkState.swift
//  ArticleList
//
//  Created by Shobhakar Tiwari on 9/15/25.
//

import Foundation

enum NetworkState {
    case isLoading
    case invalidURL
    case errorFetchingData
    case noDataFromServer
    case success(Data)
}
