//
//  ShopView.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI
import UIKit

struct ShopView: View {
    @State private var selectedCategory: String = "Men"
    @ObservedObject private var tabManager = TabManager.shared
    @State private var categories = Category.shopCategories
    @State private var isSearchActive = false
    @State private var searchText = ""
    @State private var searchResults: [SearchResult] = []
    @State private var allProducts: [Product] = []
    
    private var selectedTab: TabItem {
        tabManager.selectedTab
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let isSmallScreen = screenWidth < 375 // iPhone SE, iPhone 8
            let isLargeScreen = screenWidth > 414 // iPhone Pro Max, iPad
            
            // Адаптивные размеры
            let titleFontSize: CGFloat = isSmallScreen ? 28 : (isLargeScreen ? 36 : 32)
            let searchIconSize: CGFloat = isSmallScreen ? 20 : (isLargeScreen ? 24 : 22)
            let categoryFontSize: CGFloat = isSmallScreen ? 16 : (isLargeScreen ? 20 : 18)
            let sectionTitleFontSize: CGFloat = isSmallScreen ? 20 : (isLargeScreen ? 24 : 22)
            let cardTitleFontSize: CGFloat = isSmallScreen ? 14 : (isLargeScreen ? 18 : 16)
            let bannerTitleFontSize: CGFloat = isSmallScreen ? 20 : (isLargeScreen ? 24 : 22)
            
            // Точные отступы как на шаблоне
            let horizontalPadding: CGFloat = 20
            let topPadding: CGFloat = 16
            let cardSpacing: CGFloat = 12
            
            // Расчет размеров карточек: каждая карточка = (ширина экрана - 2*отступы - промежуток) / 2
            // Соотношение сторон карточек примерно 1:1 (квадратное) или слегка вытянутое 4:5
            let availableCardWidth = (screenWidth - 2 * horizontalPadding - cardSpacing) / 2
            let cardImageHeight: CGFloat = availableCardWidth * 1.0 // Квадратное соотношение 1:1
            
            // Баннер "New & Featured" - альбомная ориентация (ширина:высота = 2:1)
            let bannerWidth = screenWidth - 2 * horizontalPadding
            let bannerHeight: CGFloat = bannerWidth / 2.0 // Соотношение 2:1 (альбомная ориентация)
            
            // Нижний баннер - также альбомная ориентация
            let bottomBannerHeight: CGFloat = bannerWidth / 2.0
            
            ZStack {
                // Условное отображение между Home, Shop, Favorites и Profile
                if selectedTab == .home {
                    HomeView()
                        .zIndex(0)
                } else if selectedTab == .favorites {
                    FavoritesView()
                        .zIndex(0)
                } else if selectedTab == .profile {
                    ProfileView()
                        .zIndex(0)
                } else if selectedTab == .bag {
                    BagView()
                        .zIndex(0)
                } else {
                    VStack(spacing: 0) {
                        // Заголовок с поиском или строка поиска
                        NavigationHeaderView(
                            title: "Shop",
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
                                VStack(alignment: .leading, spacing: 20) {
                                    // Навигация по категориям
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 30) {
                                            ForEach(categories) { category in
                                                Button(action: {
                                                    withAnimation(.easeInOut(duration: 0.2)) {
                                                        selectedCategory = category.name
                                                        // Обновляем активную категорию
                                                        categories = categories.map { cat in
                                                            Category(name: cat.name, isActive: cat.name == category.name)
                                                        }
                                                    }
                                                }) {
                                                    VStack(spacing: 6) {
                                                        Text(category.name)
                                                            .font(.system(size: categoryFontSize, weight: category.isActive ? .bold : .regular))
                                                            .foregroundColor(category.isActive ? .black : Color(red: 0.6, green: 0.6, blue: 0.6))

                                                        if category.isActive {
                                                            Rectangle()
                                                                .fill(Color.black)
                                                                .frame(width: 35, height: 2)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.horizontal, horizontalPadding)
                                    }
                                    .padding(.bottom, 6)
                                    
                                    // Заголовок секции
                                    Text("Must-Haves, Best Sellers & More")
                                        .font(.system(size: sectionTitleFontSize, weight: .bold))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, horizontalPadding)
                                    
                                    // Две карточки товаров
                                    HStack(spacing: cardSpacing) {
                                        // Левая карточка - Best Sellers
                                        NavigationLink(destination: ProductSectionView(
                                            sectionTitle: "Best Sellers",
                                            productFilter: { $0.status == .bestseller },
                                            categoryFilter: selectedCategory
                                        )) {
                                            VStack(alignment: .leading, spacing: 12) {
                                                loadImageFromBundle(name: "Shop1", ext: "png")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: availableCardWidth, height: cardImageHeight)
                                                    .clipped()
                                                    .cornerRadius(0)

                                                Text("Best Sellers")
                                                    .font(.system(size: cardTitleFontSize, weight: .semibold))
                                                    .foregroundColor(.black)
                                                    .padding(.top, 2)
                                            }
                                            .frame(width: availableCardWidth, alignment: .leading)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        
                                        // Правая карточка - Featured in Nike Air
                                        NavigationLink(destination: ProductSectionView(
                                            sectionTitle: "Featured in Nike Air",
                                            productFilter: { product in
                                                product.brand.lowercased().contains("nike") && 
                                                (product.name.lowercased().contains("air") || product.description.lowercased().contains("air"))
                                            },
                                            categoryFilter: selectedCategory
                                        )) {
                                            VStack(alignment: .leading, spacing: 12) {
                                                loadImageFromBundle(name: "Shop2", ext: "png")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: availableCardWidth, height: cardImageHeight)
                                                    .clipped()
                                                    .cornerRadius(0)

                                                Text("Featured in Nike Air")
                                                    .font(.system(size: cardTitleFontSize, weight: .semibold))
                                                    .foregroundColor(.black)
                                                    .padding(.top, 2)
                                            }
                                            .frame(width: availableCardWidth, alignment: .leading)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    .padding(.horizontal, horizontalPadding)
                                    .padding(.top, 6)
                                    .id("cards-\(selectedCategory)")
                                    
                                    // Широкий баннер - New & Featured (альбомная ориентация)
                                    NavigationLink(destination: ProductSectionView(
                                        sectionTitle: "New & Featured",
                                        productFilter: nil,
                                        categoryFilter: selectedCategory
                                    )) {
                                        ZStack(alignment: .bottomLeading) {
                                            loadImageFromBundle(name: "Shop3", ext: "png")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: bannerWidth, height: bannerHeight)
                                                .clipped()
                                                .cornerRadius(0)

                                            Text("New & Featured")
                                                .font(.system(size: bannerTitleFontSize, weight: .bold))
                                                .foregroundColor(.white)
                                                .padding(.leading, 20)
                                                .padding(.bottom, 20)
                                        }
                                    }
                                    .padding(.horizontal, horizontalPadding)
                                    .padding(.top, 8)
                                    .buttonStyle(PlainButtonStyle())
                                    .id("banner-new-\(selectedCategory)")
                                    
                                    // Дополнительный баннер (частично видимый) - альбомная ориентация
                                    NavigationLink(destination: ProductSectionView(
                                        sectionTitle: "All Products",
                                        productFilter: nil,
                                        categoryFilter: selectedCategory
                                    )) {
                                        ZStack(alignment: .topLeading) {
                                            loadImageFromBundle(name: "e88b428413ae0b9db685ec0152d088f2c5df61e1", ext: "png")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: bannerWidth, height: bottomBannerHeight)
                                                .clipped()
                                                .cornerRadius(0)
                                            
                                            Text("All products")
                                                .font(.system(size: bannerTitleFontSize, weight: .bold))
                                                .foregroundColor(.black)
                                                .shadow(color: .white, radius: 4, x: 0, y: 0)
                                                .shadow(color: .white, radius: 4, x: 1, y: 1)
                                                .shadow(color: .white, radius: 4, x: -1, y: -1)
                                                .padding(.leading, 20)
                                                .padding(.top, 20)
                                        }
                                    }
                                    .padding(.horizontal, horizontalPadding)
                                    .padding(.top, 8)
                                    .padding(.bottom, 80) // Отступ для TabBar
                                    .buttonStyle(PlainButtonStyle())
                                    .id("banner-all-\(selectedCategory)")
                                }
                                .padding(.top, 10)
                            }
                        }
                    }
                    .background(Color.white)
                    .zIndex(0)
                }
                
                // TabBar внизу (отображается для всех вкладок)
                VStack {
                    Spacer()
                    TabBarView(selectedTab: $tabManager.selectedTab)
                        .zIndex(1)
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            await loadProducts()
        }
    }
    
    private func loadProducts() async {
        do {
            let loadedProducts = try await ProductService.shared.fetchProducts()
            await MainActor.run {
                self.allProducts = loadedProducts
            }
        } catch {
            print("Ошибка загрузки товаров: \(error.localizedDescription)")
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
                categoryFilter: selectedCategory
            )
        case "Featured in Nike Air":
            ProductSectionView(
                sectionTitle: "Featured in Nike Air",
                productFilter: { product in
                    product.brand.lowercased().contains("nike") &&
                    (product.name.lowercased().contains("air") || product.description.lowercased().contains("air"))
                },
                categoryFilter: selectedCategory
            )
        case "New & Featured":
            ProductSectionView(
                sectionTitle: "New & Featured",
                productFilter: nil,
                categoryFilter: selectedCategory
            )
        case "All Products":
            ProductSectionView(
                sectionTitle: "All Products",
                productFilter: nil,
                categoryFilter: selectedCategory
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
                categoryFilter: selectedCategory
            )
        }
    }
}


#Preview {
    NavigationView {
        ShopView()
    }
}
