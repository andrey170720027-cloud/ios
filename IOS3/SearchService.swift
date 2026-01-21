//
//  SearchService.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import Foundation

class SearchService {
    static let shared = SearchService()
    
    private init() {}
    
    // Список доступных разделов для поиска
    private let availableSections: [String] = [
        "Best Sellers",
        "Featured in Nike Air",
        "New & Featured",
        "All Products",
        "Shop My Interests",
        "Jordan Flight Essentials",
        "Running",
        "Lifestyle",
        "Basketball",
        "Training"
    ]
    
    // Поиск товаров по запросу
    func searchProducts(_ query: String, in products: [Product]) -> [Product] {
        guard query.count >= 2 else { return [] }
        
        let lowercasedQuery = query.lowercased().trimmingCharacters(in: .whitespaces)
        
        return products.filter { product in
            let nameMatch = product.name.lowercased().contains(lowercasedQuery)
            let descriptionMatch = product.description.lowercased().contains(lowercasedQuery)
            let brandMatch = product.brand.lowercased().contains(lowercasedQuery)
            let categoryMatch = (product.category?.lowercased() ?? "").contains(lowercasedQuery)
            let productTypeMatch = (product.productType?.lowercased() ?? "").contains(lowercasedQuery)
            
            return nameMatch || descriptionMatch || brandMatch || categoryMatch || productTypeMatch
        }
    }
    
    // Поиск разделов по запросу
    func searchSections(_ query: String) -> [String] {
        guard query.count >= 2 else { return [] }
        
        let lowercasedQuery = query.lowercased().trimmingCharacters(in: .whitespaces)
        
        return availableSections.filter { section in
            section.lowercased().contains(lowercasedQuery)
        }
    }
    
    // Объединенный поиск товаров и разделов
    func search(_ query: String, in products: [Product]) -> (products: [Product], sections: [String]) {
        let foundProducts = searchProducts(query, in: products)
        let foundSections = searchSections(query)
        
        return (foundProducts, foundSections)
    }
}
