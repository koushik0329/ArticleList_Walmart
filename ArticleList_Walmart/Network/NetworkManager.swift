//
//  NetworkManager.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/8/25.
//

import Foundation

protocol NetworkManagerProtocol {
        func getData(from serverUrl: String, closure: @escaping (NetworkState) -> Void)
        func parse<T: Decodable>(data: Data?, type: T.Type) -> T?
}


// MARK: - Network Manager with parse
class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    var state: NetworkState = .isLoading
    
    init() {}
    
    func getData(from serverUrl: String, closure: @escaping (NetworkState) -> Void) {
        guard let serverURL = URL(string: serverUrl) else {
            state = .invalidURL
            closure(state)
            return
        }
        
        URLSession.shared.dataTask(with: serverURL) { data, _, error in
            if let _ = error {
                self.state = .errorFetchingData
                closure(self.state)
                return
            }
            
            guard let data else {
                self.state = .noDataFromServer
                closure(self.state)
                return
            }
            self.state = .success(data)
            closure(self.state)
        }.resume()
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
