//
//  ProductListViewModel.swift
//  IOS3
//
//  ViewModel для управления списком товаров
//

import Foundation
import Combine
import SwiftUI

class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var filteredProducts: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let productService = ProductService.shared
    private var productFilter: ((Product) -> Bool)?
    private var categoryFilter: String?
    
    init(productFilter: ((Product) -> Bool)? = nil, categoryFilter: String? = nil) {
        self.productFilter = productFilter
        self.categoryFilter = categoryFilter
    }
    
    @MainActor
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let loadedProducts = try await productService.fetchProducts()
            
            // Применяем фильтр товаров, если указан
            var filtered = loadedProducts
            if let filter = productFilter {
                filtered = filtered.filter(filter)
            }
            
            // Применяем фильтр по категории (Men/Women/Kids), если указан
            if let category = categoryFilter {
                filtered = filtered.filter { product in
                    product.category?.lowercased() == category.lowercased()
                }
            }
            
            await MainActor.run {
                self.products = filtered
                self.filteredProducts = filtered
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
            print("Ошибка загрузки товаров: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func filterByCategory(_ categoryName: String, productTypeCategories: [Category]? = nil) {
        guard let productTypeCategories = productTypeCategories else {
            // Если нет категорий по типу товара, показываем все товары
            filteredProducts = products
            return
        }
        
        if categoryName == "All" {
            filteredProducts = products
        } else {
            filteredProducts = products.filter { product in
                guard let productType = product.productType else { return false }
                let normalizedProductType = productType.lowercased().trimmingCharacters(in: .whitespaces)
                let normalizedCategoryName = categoryName.lowercased().trimmingCharacters(in: .whitespaces)
                return normalizedProductType == normalizedCategoryName
            }
        }
    }
    
    @MainActor
    func applyProductFilter(_ filter: @escaping (Product) -> Bool) {
        filteredProducts = products.filter(filter)
    }
}
