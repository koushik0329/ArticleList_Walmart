//
//  NetworkState.swift
//  ArticleList
//
//  Created by Shobhakar Tiwari on 9/15/25.
//

import Foundation

enum ServiceError: Error {
    case networkState(NetworkState)
}

enum NetworkState {
    case isLoading
    case invalidResponse(statusCode: Int)
    case errorFetchingData
    case errorFetchingDat(Error)
    case invalidURL
//    case errorFetchingData
    case noDataFromServer
    case success(Data)
}
