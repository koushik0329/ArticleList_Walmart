//
//  NetworkManager.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/8/25.
//

import Foundation

protocol NetworkManagerProtocol {
        func getData(from serverUrl: String) async -> NetworkState
        func parse<T: Decodable>(data: Data?, type: T.Type) -> T?
}


// MARK: - Network Manager with parse
class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    var state: NetworkState = .isLoading
    
    init() {}
    
    func getData(from serverUrl: String) async -> NetworkState {
        guard let serverURL = URL(string: serverUrl) else {
            state = .invalidURL
            return state
        }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: serverURL)
            
            state = .success(data)
            return state
        } catch {
            state = .errorFetchingData
            return state
        }
    }
    
    func parse<T: Decodable>(data: Data?, type: T.Type) -> T? {
        guard let data = data else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Parsing error: \(error)")
            return nil
        }
    }
}
