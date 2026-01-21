//
//  FavoritesView.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI

struct FavoritesView: View {
    @Binding var selectedTab: TabItem
    @ObservedObject private var favoritesService = FavoritesService.shared
    @State private var products: [Product] = []
    @State private var filteredProducts: [Product] = []
    @State private var isLoading = true
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let isSmallScreen = screenWidth < 375
            let isLargeScreen = screenWidth > 414
            
            let titleFontSize: CGFloat = isSmallScreen ? 28 : (isLargeScreen ? 36 : 32)
            
            ZStack {
                VStack(spacing: 0) {
                    // Заголовок
                    HStack {
                        Text("Favorites")
                            .font(.system(size: titleFontSize, weight: .bold))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button(action: {
                            // Действие поиска
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: isSmallScreen ? 20 : (isLargeScreen ? 24 : 22), weight: .regular))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                    
                    // Сетка товаров
                    ScrollView {
                        if isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(.top, 100)
                        } else if filteredProducts.isEmpty {
                            // Пустое состояние
                            VStack(spacing: 20) {
                                Image(systemName: "heart")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray.opacity(0.5))
                                
                                Text("Нет избранных товаров")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                Text("Добавьте товары в избранное, нажав на иконку сердца")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray.opacity(0.7))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
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
                .background(Color.white)
                
                // TabBar внизу
                VStack {
                    Spacer()
                    TabBarView(selectedTab: $selectedTab)
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            await loadProducts()
        }
        .onChange(of: favoritesService.favoriteIds) { _ in
            // Обновляем список при изменении избранного
            filterFavorites()
        }
    }
    
    private func loadProducts() async {
        isLoading = true
        do {
            let loadedProducts = try await ProductService.shared.fetchProducts()
            await MainActor.run {
                self.products = loadedProducts
                self.filterFavorites()
                self.isLoading = false
            }
        } catch {
            print("Ошибка загрузки товаров: \(error.localizedDescription)")
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    private func filterFavorites() {
        let favoriteIds = favoritesService.getFavoriteProductIds()
        filteredProducts = products.filter { product in
            favoriteIds.contains(product.stableId)
        }
    }
}

#Preview {
    NavigationView {
        FavoritesView(selectedTab: .constant(.favorites))
    }
}
