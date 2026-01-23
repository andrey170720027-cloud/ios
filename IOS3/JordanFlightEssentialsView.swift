//
//  JordanFlightEssentialsView.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI

struct JordanFlightEssentialsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ProductListViewModel(productFilter: { product in
        product.brand.lowercased().contains("jordan") || 
        product.name.lowercased().contains("jordan")
    })
    @State private var categories = Category.jordanCategories
    @ObservedObject private var tabManager = TabManager.shared
    @State private var isSearchActive = false
    @State private var searchText = ""
    @State private var searchResults: [Product] = []
    @State private var previousTab: TabItem = .shop
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Заголовок с кнопками или поиск
                NavigationHeaderView(
                    title: "Jordan Flight Essentials",
                    isSearchActive: $isSearchActive,
                    searchText: $searchText,
                    onSearchTap: {
                        withAnimation {
                            isSearchActive = true
                        }
                    },
                    onBack: { dismiss() },
                    showBackButton: true,
                    rightButtons: [
                        NavigationHeaderView.HeaderButton(
                            icon: "line.3.horizontal.decrease",
                            action: {
                                // Действие фильтра
                            }
                        )
                    ]
                )
                .onChange(of: searchText) { _, newValue in
                    handleSearchQuery(newValue)
                }
                
                // Навигация по категориям (скрываем при поиске)
                if !isSearchActive {
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
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 100)
                    } else {
                        let productsToShow = isSearchActive && !searchText.isEmpty ? searchResults : viewModel.filteredProducts
                        
                        if isSearchActive && !searchText.isEmpty && searchResults.isEmpty {
                            EmptyStateView(
                                icon: "magnifyingglass",
                                title: "Ничего не найдено"
                            )
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
                TabBarView(selectedTab: $tabManager.selectedTab)
            }
        }
        .navigationBarHidden(true)
        .onChange(of: tabManager.selectedTab) { oldValue, newValue in
            // Если переключились на другую вкладку, закрываем навигацию
            if newValue != previousTab {
                dismiss()
            }
            previousTab = newValue
        }
        .onAppear {
            previousTab = tabManager.selectedTab
        }
        .task {
            await viewModel.loadProducts()
            // Применяем фильтр для активной категории при первой загрузке
            if let activeCategory = categories.first(where: { $0.isActive }) {
                filterProductsByCategory(activeCategory.name)
            }
        }
    }
    
    private func filterProductsByCategory(_ categoryName: String) {
        viewModel.filterByCategory(categoryName, productTypeCategories: categories)
    }
    
    private func handleSearchQuery(_ query: String) {
        guard query.count >= 2 else {
            searchResults = []
            return
        }
        
        searchResults = SearchService.shared.searchProducts(query, in: viewModel.filteredProducts)
    }
}

#Preview {
    NavigationView {
        JordanFlightEssentialsView()
    }
}
