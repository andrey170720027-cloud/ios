//
//  HomeView.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI
import UIKit

struct HomeView: View {
    @ObservedObject private var tabManager = TabManager.shared
    @State private var interests = Interest.sampleInterests
    @State private var recommendedProducts: [Product] = []
    @State private var isLoading = true
    @State private var isSearchActive = false
    @State private var searchText = ""
    @State private var searchResults: [SearchResult] = []
    @State private var allProducts: [Product] = []
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let isSmallScreen = screenWidth < 375
            let isLargeScreen = screenWidth > 414
            
            // Адаптивные размеры
            let titleFontSize: CGFloat = isSmallScreen ? 28 : (isLargeScreen ? 36 : 32)
            let searchIconSize: CGFloat = isSmallScreen ? 20 : (isLargeScreen ? 24 : 22)
            let sectionTitleFontSize: CGFloat = isSmallScreen ? 20 : (isLargeScreen ? 24 : 22)
            
            // Точные отступы
            let horizontalPadding: CGFloat = 20
            let topPadding: CGFloat = 16
            
            ZStack {
                VStack(spacing: 0) {
                    // Верхняя панель навигации или поиск
                    NavigationHeaderView(
                        title: "Home",
                        isSearchActive: $isSearchActive,
                        searchText: $searchText,
                        onSearchTap: {
                            withAnimation {
                                isSearchActive = true
                            }
                        }
                    )
                    .onChange(of: searchText) { _, newValue in
                        handleSearchQuery(newValue)
                    }
                    
                    // Контент: результаты поиска или обычный контент
                    if isSearchActive && !searchText.isEmpty {
                        // Результаты поиска
                        SearchResultsView(
                            searchResults: searchResults,
                            viewForSection: { sectionName in
                                AnyView(viewForSection(sectionName))
                            }
                        )
                    } else {
                        // Обычный контент
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 24) {
                                // Секция "Shop My Interests"
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("Shop My Interests")
                                            .font(.system(size: sectionTitleFontSize, weight: .bold))
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            // Действие добавления интереса
                                        }) {
                                            Text("Add Interest")
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding(.horizontal, horizontalPadding)
                                    
                                    // Горизонтальный список интересов
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 12) {
                                            ForEach(interests) { interest in
                                                NavigationLink(destination: ProductSectionView(
                                                    sectionTitle: interest.name,
                                                    productFilter: { product in
                                                        matchesProductInterest(product: product, interest: interest.name)
                                                    },
                                                    categoryFilter: nil
                                                )) {
                                                    ZStack {
                                                        loadImageFromBundle(name: interest.imageName, ext: "")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 150, height: 200)
                                                            .clipped()
                                                            .cornerRadius(12)
                                                        
                                                        // Затемнение
                                                        LinearGradient(
                                                            colors: [Color.clear, Color.black.opacity(0.6)],
                                                            startPoint: .top,
                                                            endPoint: .bottom
                                                        )
                                                        .cornerRadius(12)
                                                        
                                                        // Текст поверх
                                                        VStack {
                                                            Spacer()
                                                            Text(interest.name)
                                                                .font(.system(size: 18, weight: .bold))
                                                                .foregroundColor(.white)
                                                                .padding(.bottom, 16)
                                                        }
                                                    }
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                        .padding(.horizontal, horizontalPadding)
                                    }
                                }
                                
                                // Секция "Recommended for You"
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Recommended for You")
                                        .font(.system(size: sectionTitleFontSize, weight: .bold))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, horizontalPadding)
                                    
                                    // Горизонтальный список товаров
                                    if isLoading {
                                        ProgressView()
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 40)
                                    } else {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 16) {
                                                ForEach(recommendedProducts.prefix(10)) { product in
                                                    NavigationLink(destination: ProductDetailView(product: product)) {
                                                        VStack(alignment: .leading, spacing: 8) {
                                                            // Изображение товара
                                                            ProductImageView(
                                                                imageURL: product.imageURL,
                                                                imageName: product.imageName,
                                                                width: 150,
                                                                height: 150,
                                                                contentMode: .fill
                                                            )
                                                            .cornerRadius(8)
                                                            
                                                            Text(product.name)
                                                                .font(.system(size: 14, weight: .semibold))
                                                                .foregroundColor(.black)
                                                                .lineLimit(2)
                                                            
                                                            Text(product.price)
                                                                .font(.system(size: 14, weight: .semibold))
                                                                .foregroundColor(.black)
                                                        }
                                                        .frame(width: 150)
                                                    }
                                                    .buttonStyle(PlainButtonStyle())
                                                }
                                            }
                                            .padding(.horizontal, horizontalPadding)
                                        }
                                    }
                                }
                                .padding(.bottom, 80) // Отступ для TabBar
                            }
                            .padding(.top, 8)
                        }
                    }
                    
                    Spacer()
                }
                .background(Color.white)
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
            await MainActor.run {
                self.recommendedProducts = loadedProducts
                self.allProducts = loadedProducts
                self.isLoading = false
            }
        } catch {
            print("Ошибка загрузки товаров: \(error.localizedDescription)")
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
    
    private func handleSearchQuery(_ query: String) {
        guard query.count >= 2 else {
            searchResults = []
            return
        }
        
        let (foundProducts, foundSections) = SearchService.shared.search(query, in: allProducts)
        
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
    
    @ViewBuilder
    private func viewForSection(_ sectionName: String) -> some View {
        switch sectionName {
        case "Best Sellers":
            ProductSectionView(
                sectionTitle: "Best Sellers",
                productFilter: { $0.status == .bestseller },
                categoryFilter: nil
            )
        case "Featured in Nike Air":
            ProductSectionView(
                sectionTitle: "Featured in Nike Air",
                productFilter: { product in
                    product.brand.lowercased().contains("nike") &&
                    (product.name.lowercased().contains("air") || product.description.lowercased().contains("air"))
                },
                categoryFilter: nil
            )
        case "New & Featured":
            ProductSectionView(
                sectionTitle: "New & Featured",
                productFilter: nil,
                categoryFilter: nil
            )
        case "All Products":
            ProductSectionView(
                sectionTitle: "All Products",
                productFilter: nil,
                categoryFilter: nil
            )
        case "Shop My Interests":
            ShopMyInterestsView()
        case "Jordan Flight Essentials":
            JordanFlightEssentialsView()
        case "Running", "Lifestyle", "Basketball", "Training":
            ProductSectionView(
                sectionTitle: sectionName,
                productFilter: { product in
                    matchesProductInterest(product: product, interest: sectionName)
                },
                categoryFilter: nil
            )
        default:
            ProductSectionView(
                sectionTitle: sectionName,
                productFilter: nil,
                categoryFilter: nil
            )
        }
    }
}


#Preview {
    NavigationView {
        HomeView()
    }
}
