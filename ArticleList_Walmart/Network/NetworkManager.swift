//
//  NetworkManager.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/8/25.
//

import Foundation

protocol NetworkManagerProtocol {
    func getData(from serverUrl: String, closure: @escaping (Data?) -> Void)
    func parse(data: Data?) -> ArticleList?
}

// MARK: - Network Manager with parse
class NetworkManager : NetworkManagerProtocol {
    static let shared = NetworkManager()
    init() {}
    
    func getData(from serverUrl: String, closure: @escaping (Data?) -> Void) {
        guard let serverURL = URL(string: serverUrl) else {
            print("Invalid URL")
            closure(nil)
            return
        }
        
        URLSession.shared.dataTask(with: serverURL) { data, _, error in
            if let error = error {
                print("Network error: \(error)")
                closure(nil)
                return
            }
            closure(data)
        }.resume()
    }
    
    func parse(data: Data?) -> ArticleList? {
        guard let data = data else { return nil }
        do {
            return try JSONDecoder().decode(ArticleList.self, from: data)
        } catch {
            print("Parsing error: \(error)")
            return nil
        }
    }
}
