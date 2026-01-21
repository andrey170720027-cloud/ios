//
//  ProductSectionView.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI

struct ProductSectionView: View {
    let sectionTitle: String
    let productFilter: ((Product) -> Bool)?
    let categoryFilter: String?
    
    @Environment(\.dismiss) private var dismiss
    @State private var categories = Category.bestSellersCategories
    @State private var selectedTab: TabItem = .shop
    @State private var products: [Product] = []
    @State private var filteredProducts: [Product] = []
    @State private var isLoading = true
    @State private var isSearchActive = false
    @State private var searchText = ""
    @State private var searchResults: [Product] = []
    
    init(sectionTitle: String, productFilter: ((Product) -> Bool)? = nil, categoryFilter: String? = nil) {
        self.sectionTitle = sectionTitle
        self.productFilter = productFilter
        self.categoryFilter = categoryFilter
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Заголовок с кнопками или поиск
                if isSearchActive {
                    // Строка поиска
                    HStack(spacing: 12) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                        }
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            TextField("Поиск товаров", text: $searchText)
                                .font(.system(size: 16))
                                .onChange(of: searchText) { _, newValue in
                                    performSearch(query: newValue)
                                }
                            
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                    searchResults = []
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        
                        Button(action: {
                            withAnimation {
                                isSearchActive = false
                                searchText = ""
                                searchResults = []
                            }
                        }) {
                            Text("Отмена")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 16)
                } else {
                    // Обычный заголовок
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
                        
                        Text(sectionTitle)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        
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
                                withAnimation {
                                    isSearchActive = true
                                }
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
                }
                
                // Навигация по категориям (скрываем для "All Products" и при поиске)
                if categoryFilter != nil && !isSearchActive {
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
                }
                
                // Сетка товаров или результаты поиска
                ScrollView {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 100)
                    } else {
                        let productsToShow = isSearchActive && !searchText.isEmpty ? searchResults : filteredProducts
                        
                        if isSearchActive && !searchText.isEmpty && searchResults.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 48))
                                    .foregroundColor(.gray)
                                Text("Ничего не найдено")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 100)
                        } else {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ], spacing: 16) {
                                ForEach(productsToShow) { product in
                                    NavigationLink(destination: ProductDetailView(product: product)) {
                                        ProductCardView(product: product)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 80) // Отступ для TabBar
                        }
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
            // Применяем фильтр, если он указан
            var filtered: [Product] = loadedProducts
            if let filter = productFilter {
                filtered = filtered.filter(filter)
            }
            
            // Применяем фильтр по категории (Men/Women/Kids), если указан
            // Если categoryFilter = nil, показываем все товары из всех категорий
            if let category = categoryFilter {
                filtered = filtered.filter { product in
                    product.category?.lowercased() == category.lowercased()
                }
            }
            
            await MainActor.run {
                self.products = filtered
                // Применяем фильтр для активной категории при первой загрузке
                // Если categoryFilter = nil (All Products), показываем все товары без фильтрации по productType
                if categoryFilter == nil {
                    // Для "All Products" показываем все товары
                    self.filteredProducts = filtered
                } else {
                    // Для других секций применяем фильтр по productType
                    if let activeCategory = categories.first(where: { $0.isActive }) {
                        if activeCategory.name == "All" {
                            self.filteredProducts = filtered
                        } else {
                            self.filteredProducts = filtered.filter { product in
                                guard let productType = product.productType else { return false }
                                // Нормализуем строки: убираем пробелы и приводим к нижнему регистру
                                let normalizedProductType = productType.lowercased().trimmingCharacters(in: .whitespaces)
                                let normalizedCategoryName = activeCategory.name.lowercased().trimmingCharacters(in: .whitespaces)
                                return normalizedProductType == normalizedCategoryName
                            }
                        }
                    } else {
                        self.filteredProducts = filtered
                    }
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
        // Если categoryFilter = nil (All Products), не применяем фильтр по productType
        if categoryFilter == nil {
            filteredProducts = products
        } else {
            // Для других секций применяем фильтр по productType
            if categoryName == "All" {
                filteredProducts = products
            } else {
                filteredProducts = products.filter { product in
                    guard let productType = product.productType else { return false }
                    // Нормализуем строки: убираем пробелы и приводим к нижнему регистру
                    let normalizedProductType = productType.lowercased().trimmingCharacters(in: .whitespaces)
                    let normalizedCategoryName = categoryName.lowercased().trimmingCharacters(in: .whitespaces)
                    return normalizedProductType == normalizedCategoryName
                }
            }
        }
    }
    
    private func performSearch(query: String) {
        guard query.count >= 2 else {
            searchResults = []
            return
        }
        
        searchResults = SearchService.shared.searchProducts(query, in: filteredProducts)
    }
}

#Preview {
    NavigationView {
        ProductSectionView(sectionTitle: "Best Sellers", productFilter: { $0.status == .bestseller })
    }
}
