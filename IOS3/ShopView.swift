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
    @State private var selectedTab: TabItem = .shop
    @State private var categories = Category.shopCategories
    @State private var isSearchActive = false
    @State private var searchText = ""
    @State private var searchResults: [SearchResult] = []
    @State private var allProducts: [Product] = []
    
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
                    HomeView(selectedTab: $selectedTab)
                        .zIndex(0)
                } else if selectedTab == .favorites {
                    FavoritesView(selectedTab: $selectedTab)
                        .zIndex(0)
                } else if selectedTab == .profile {
                    ProfileView(selectedTab: $selectedTab)
                        .zIndex(0)
                } else {
                    VStack(spacing: 0) {
                        // Заголовок с поиском или строка поиска
                        if isSearchActive {
                            // Строка поиска
                            HStack(spacing: 12) {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                    
                                    TextField("Поиск товаров и разделов", text: $searchText)
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
                            .padding(.horizontal, horizontalPadding)
                            .padding(.top, topPadding)
                            .padding(.bottom, 16)
                        } else {
                            // Обычный заголовок
                            HStack {
                                Text("Shop")
                                    .font(.system(size: titleFontSize, weight: .bold))
                                    .foregroundColor(.black)

                                Spacer()

                                Button(action: {
                                    withAnimation {
                                        isSearchActive = true
                                    }
                                }) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: searchIconSize, weight: .regular))
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(.horizontal, horizontalPadding)
                            .padding(.top, topPadding)
                            .padding(.bottom, 16)
                        }
                        
                        // Контент: результаты поиска или обычный контент
                        if isSearchActive && !searchText.isEmpty {
                            // Результаты поиска
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack(alignment: .leading, spacing: 16) {
                                    if searchResults.isEmpty {
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
                                        // Разделы
                                        let sections = searchResults.filter {
                                            if case .section = $0.type { return true }
                                            return false
                                        }
                                        
                                        if !sections.isEmpty {
                                            Text("Разделы")
                                                .font(.system(size: sectionTitleFontSize, weight: .bold))
                                                .foregroundColor(.black)
                                                .padding(.horizontal, horizontalPadding)
                                                .padding(.top, 8)
                                            
                                            ForEach(sections) { result in
                                                if case .section(let sectionName) = result.type {
                                                    NavigationLink(destination: destinationForSection(sectionName)) {
                                                        HStack {
                                                            Image(systemName: "folder.fill")
                                                                .foregroundColor(.blue)
                                                                .frame(width: 24)
                                                            Text(sectionName)
                                                                .font(.system(size: 16))
                                                                .foregroundColor(.black)
                                                            Spacer()
                                                            Image(systemName: "chevron.right")
                                                                .font(.system(size: 12))
                                                                .foregroundColor(.gray)
                                                        }
                                                        .padding(.horizontal, horizontalPadding)
                                                        .padding(.vertical, 12)
                                                        .background(Color.white)
                                                    }
                                                    .buttonStyle(PlainButtonStyle())
                                                }
                                            }
                                        }
                                        
                                        // Товары
                                        let products = searchResults.filter {
                                            if case .product = $0.type { return true }
                                            return false
                                        }
                                        
                                        if !products.isEmpty {
                                            Text("Товары")
                                                .font(.system(size: sectionTitleFontSize, weight: .bold))
                                                .foregroundColor(.black)
                                                .padding(.horizontal, horizontalPadding)
                                                .padding(.top, sections.isEmpty ? 8 : 16)
                                            
                                            LazyVGrid(columns: [
                                                GridItem(.flexible(), spacing: 12),
                                                GridItem(.flexible(), spacing: 12)
                                            ], spacing: 16) {
                                                ForEach(products) { result in
                                                    if case .product(let product) = result.type {
                                                        NavigationLink(destination: ProductDetailView(product: product)) {
                                                            ProductCardView(product: product)
                                                        }
                                                    }
                                                }
                                            }
                                            .padding(.horizontal, horizontalPadding)
                                        }
                                    }
                                }
                                .padding(.bottom, 80)
                            }
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
                                                shopImage(name: "Shop1", ext: "png")
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
                                                shopImage(name: "Shop2", ext: "png")
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
                                            shopImage(name: "Shop3", ext: "png")
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
                                            shopImage(name: "e88b428413ae0b9db685ec0152d088f2c5df61e1", ext: "png")
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
                    TabBarView(selectedTab: $selectedTab)
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
    
    private func performSearch(query: String) {
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
    private func destinationForSection(_ sectionName: String) -> some View {
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
                    filterProductByInterest(product: product, interest: sectionName)
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

private func shopImage(name: String, ext: String) -> Image {
    let extsToTry: [String] = {
        let normalized = ext.lowercased()
        if normalized.isEmpty { return ["png", "jpg", "jpeg"] }
        if normalized == "jpeg" { return ["jpeg", "jpg"] }
        if normalized == "jpg" { return ["jpg", "jpeg"] }
        return [normalized]
    }()

    let subdirsToTry: [String?] = ["images", nil]

    for subdir in subdirsToTry {
        for candidateExt in extsToTry {
            if let url = Bundle.main.url(forResource: name, withExtension: candidateExt, subdirectory: subdir),
               let uiImage = UIImage(contentsOfFile: url.path) {
                return Image(uiImage: uiImage)
            }
        }
    }

    // Иногда файлы попадают в bundle как "<name>.<ext>"
    for candidateExt in extsToTry {
        if let uiImage = UIImage(named: "\(name).\(candidateExt)") {
            return Image(uiImage: uiImage)
        }
    }

    if let uiImage = UIImage(named: name) {
        return Image(uiImage: uiImage)
    }

    return Image(systemName: "photo")
}

// Функция фильтрации товаров по интересам
private func filterProductByInterest(product: Product, interest: String) -> Bool {
    let productName = (product.name + " " + product.description).lowercased()
    let productType = (product.productType ?? "").lowercased()
    let brand = product.brand.lowercased()
    let interestLower = interest.lowercased()
    
    switch interestLower {
    case "running":
        return productName.contains("running") ||
               productName.contains("miler") ||
               productName.contains("dri-fit") ||
               productName.contains("run ") ||
               (productName.contains("run") && !productName.contains("basketball"))
    
    case "basketball":
        return productName.contains("basketball") ||
               brand.contains("jordan") ||
               productName.contains("jordan")
    
    case "training":
        return productName.contains("training") ||
               productName.contains("pullover") ||
               productName.contains("hoodie") ||
               productName.contains("fleece") ||
               productName.contains("sportswear") ||
               productName.contains("sportswear club")
    
    case "lifestyle":
        let isRunning = productName.contains("running") ||
                       productName.contains("miler") ||
                       productName.contains("dri-fit") ||
                       (productName.contains("run ") && !productName.contains("basketball"))
        let isBasketball = productName.contains("basketball") ||
                          brand.contains("jordan") ||
                          productName.contains("jordan")
        let isTraining = productName.contains("training") ||
                        productName.contains("pullover") ||
                        productName.contains("hoodie") ||
                        productName.contains("fleece") ||
                        productName.contains("sportswear")
        
        return !isRunning && !isBasketball && !isTraining
    
    default:
        return false
    }
}

#Preview {
    NavigationView {
        ShopView()
    }
}
