//
//  BestSellersView.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI

struct BestSellersView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var categories = Category.bestSellersCategories
    @State private var selectedTab: TabItem = .shop
    @State private var products: [Product] = []
    @State private var filteredProducts: [Product] = []
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Заголовок с кнопками
                HStack {
                    // Кнопка назад
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Text("Best Sellers")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        // Кнопка фильтра
                        Button(action: {
                            // Действие фильтра
                        }) {
                            Image(systemName: "line.3.horizontal.decrease")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                        }
                        
                        // Кнопка поиска
                        Button(action: {
                            // Действие поиска
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 16)
                
                // Навигация по категориям
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 24) {
                        ForEach(categories) { category in
                            Button(action: {
                                // Обновляем активную категорию
                                categories = categories.map { cat in
                                    Category(name: cat.name, isActive: cat.name == category.name)
                                }
                                // Фильтруем товары по выбранной категории
                                filterProductsByCategory(category.name)
                            }) {
                                VStack(spacing: 4) {
                                    Text(category.name)
                                        .font(.system(size: 14, weight: category.isActive ? .bold : .regular))
                                        .foregroundColor(category.isActive ? .black : .gray)
                                    
                                    if category.isActive {
                                        Rectangle()
                                            .fill(Color.black)
                                            .frame(width: 20, height: 2)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 16)
                
                // Сетка товаров
                ScrollView {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 100)
                    } else {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 12),
                            GridItem(.flexible(), spacing: 12)
                        ], spacing: 16) {
                            ForEach(filteredProducts) { product in
                                NavigationLink(destination: ProductDetailView(product: product)) {
                                    ProductCardView(product: product)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 80) // Отступ для TabBar
                    }
                }
                
                Spacer()
            }
            
            // TabBar внизу
            VStack {
                Spacer()
                TabBarView(selectedTab: $selectedTab)
            }
        }
        .navigationBarHidden(true)
        .task {
            await loadProducts()
        }
    }
    
    private func loadProducts() async {
        isLoading = true
        do {
            let loadedProducts = try await ProductService.shared.fetchProducts()
            // Фильтруем только bestseller товары
            let bestsellerProducts = loadedProducts.filter { $0.status == .bestseller }
            await MainActor.run {
                self.products = bestsellerProducts
                // Применяем фильтр для активной категории при первой загрузке
                if let activeCategory = categories.first(where: { $0.isActive }) {
                    self.filteredProducts = bestsellerProducts.filter { product in
                        guard let productType = product.productType else { return false }
                        // Нормализуем строки: убираем пробелы и приводим к нижнему регистру
                        let normalizedProductType = productType.lowercased().trimmingCharacters(in: .whitespaces)
                        let normalizedCategoryName = activeCategory.name.lowercased().trimmingCharacters(in: .whitespaces)
                        return normalizedProductType == normalizedCategoryName
                    }
                } else {
                    self.filteredProducts = bestsellerProducts
                }
                self.isLoading = false
            }
        } catch {
            print("Ошибка загрузки товаров: \(error.localizedDescription)")
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    private func filterProductsByCategory(_ categoryName: String) {
        filteredProducts = products.filter { product in
            guard let productType = product.productType else { return false }
            // Нормализуем строки: убираем пробелы и приводим к нижнему регистру
            let normalizedProductType = productType.lowercased().trimmingCharacters(in: .whitespaces)
            let normalizedCategoryName = categoryName.lowercased().trimmingCharacters(in: .whitespaces)
            return normalizedProductType == normalizedCategoryName
        }
    }
}

#Preview {
    NavigationView {
        BestSellersView()
    }
}
