//
//  ServiceManager.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/30/25.
//

import Foundation

protocol ServiceManagerProtocol {
    func getData<T: Decodable>(from serverUrl: String, type: T.Type) async throws -> T
}

class ServiceManager: ServiceManagerProtocol {
    static let shared = ServiceManager()

    
    func getData<T: Decodable>(from serverUrl: String, type: T.Type) async throws -> T {
        guard let serverURL = URL(string: serverUrl) else {
            throw ServiceError.networkState(.invalidURL)
        }

        let (data, response) = try await URLSession.shared.data(from: serverURL)

        guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
            throw ServiceError.networkState(.invalidResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1))
        }

        return try JSONDecoder().decode(T.self, from: data)
        
    }
}
