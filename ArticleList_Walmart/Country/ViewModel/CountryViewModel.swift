//
//  CountryViewModel.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/18/25.
//

import Foundation

protocol CountryViewModelProtocol {
    func getCountriesFromServer() async -> NetworkState?
    var errorMessage: String { get }
    
}

class CountryViewModel: CountryViewModelProtocol {
    var countries: [Country] = []
    var filteredCountries: [Country] = []
    var isSearching: Bool = false
    
    private let networkManager: NetworkManagerProtocol
    var errorState: NetworkState?
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    

    func getCountriesFromServer() async -> NetworkState? {
        let fetchedState = await networkManager.getData(from: Server.countryEndPoint.rawValue)
        
        switch fetchedState {
            case .isLoading, .invalidURL, .errorFetchingData, .noDataFromServer:
                errorState = fetchedState
            case .success(let fetchedData):

                if let fetchedCountries = self.networkManager.parse(data: fetchedData, type: [Country].self) {
                    self.countries = fetchedCountries
                    self.filteredCountries = self.countries
                    self.errorState = nil
                } else {
                    self.errorState = .noDataFromServer
                }
        }
        return self.errorState
    }
    
    func getCountryCount() -> Int {
        return filteredCountries.count
    }
        
    func getCountry(at index: Int) -> Country {
        return filteredCountries[index]
    }
        
    func searchCountry(text: String) {
        isSearching = !text.isEmpty
        if isSearching {
            filteredCountries = countries.filter { country in
                guard let name = country.name else { return false }
                return name.lowercased().contains(text.lowercased()) ||
                    (country.capital?.lowercased().contains(text.lowercased()) ?? false) ||
                    (country.region?.lowercased().contains(text.lowercased()) ?? false)
            }
        } else {
            filteredCountries = countries
        }
    }
    
    var errorMessage: String {
        guard let errorState = errorState else { return "" }
        switch errorState {
        case .invalidURL:
            return "Invalid URL"
        case .errorFetchingData:
            return "Error fetching data"
        case .noDataFromServer:
            return "No data from server"
        default :
            return ""
        }
    }
}
