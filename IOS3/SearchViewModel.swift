//
//  SearchViewModel.swift
//  IOS3
//
//  ViewModel для управления поиском
//

import Foundation
import Combine
import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [SearchResult] = []
    @Published var isSearchActive = false
    
    private let searchService = SearchService.shared
    private var allProducts: [Product] = []
    
    @MainActor
    func setProducts(_ products: [Product]) {
        self.allProducts = products
    }
    
    @MainActor
    func handleSearchQuery(_ query: String) {
        guard query.count >= 2 else {
            searchResults = []
            return
        }
        
        let (foundProducts, foundSections) = searchService.search(query, in: allProducts)
        
        var results: [SearchResult] = []
        
        // Добавляем разделы
        for section in foundSections {
            results.append(SearchResult(type: .section(section)))
        }
        
        // Добавляем товары
        for product in foundProducts {
            results.append(SearchResult(type: .product(product)))
        }
        
        searchResults = results
    }
    
    @MainActor
    func clearSearch() {
        searchText = ""
        searchResults = []
        isSearchActive = false
    }
}
