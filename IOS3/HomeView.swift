//
//  HomeView.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI
import UIKit

struct HomeView: View {
    @Binding var selectedTab: TabItem
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
                        // Обычная панель навигации
                        HStack {
                            Spacer()
                            
                            Text("Home")
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
                                                    filterProductByInterest(product: product, interest: interest.name)
                                                },
                                                categoryFilter: nil
                                            )) {
                                                ZStack {
                                                    homeImage(name: interest.imageName, ext: "")
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
                                                        Group {
                                                            if let imageURL = product.imageURL, let url = URL(string: imageURL) {
                                                                AsyncImage(url: url) { phase in
                                                                    switch phase {
                                                                    case .empty:
                                                                        ProgressView()
                                                                            .frame(width: 150, height: 150)
                                                                    case .success(let image):
                                                                        image
                                                                            .resizable()
                                                                            .aspectRatio(contentMode: .fill)
                                                                    case .failure:
                                                                        Image(systemName: "photo")
                                                                            .resizable()
                                                                            .aspectRatio(contentMode: .fit)
                                                                            .foregroundColor(.gray)
                                                                            .frame(width: 150, height: 150)
                                                                    @unknown default:
                                                                        EmptyView()
                                                                    }
                                                                }
                                                            } else if let imageName = product.imageName {
                                                                Image(imageName)
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fill)
                                                            } else {
                                                                Image(systemName: "photo")
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fit)
                                                                    .foregroundColor(.gray)
                                                                    .frame(width: 150, height: 150)
                                                            }
                                                        }
                                                        .frame(width: 150, height: 150)
                                                        .clipped()
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
                    filterProductByInterest(product: product, interest: sectionName)
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

// Функция фильтрации товаров по интересам
private func filterProductByInterest(product: Product, interest: String) -> Bool {
    let productName = (product.name + " " + product.description).lowercased()
    let productType = (product.productType ?? "").lowercased()
    let brand = product.brand.lowercased()
    let interestLower = interest.lowercased()
    
    switch interestLower {
    case "running":
        // Фильтруем товары, связанные с бегом
        return productName.contains("running") || 
               productName.contains("miler") || 
               productName.contains("dri-fit") ||
               productName.contains("run ") ||
               (productName.contains("run") && !productName.contains("basketball"))
    
    case "basketball":
        // Фильтруем товары, связанные с баскетболом
        return productName.contains("basketball") ||
               brand.contains("jordan") ||
               productName.contains("jordan")
    
    case "training":
        // Фильтруем товары для тренировок
        return productName.contains("training") ||
               productName.contains("pullover") ||
               productName.contains("hoodie") ||
               productName.contains("fleece") ||
               productName.contains("sportswear") ||
               productName.contains("sportswear club")
    
    case "lifestyle":
        // Фильтруем товары для повседневной жизни (все остальное, что не относится к конкретным видам спорта)
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

// Helper функция для загрузки изображений из папки images
private func homeImage(name: String, ext: String) -> Image {
    // Пробуем разные расширения
    let extsToTry: [String] = {
        let normalized = ext.lowercased()
        if normalized.isEmpty { return ["png", "jpg", "jpeg"] }
        if normalized == "jpeg" { return ["jpeg", "jpg"] }
        if normalized == "jpg" { return ["jpg", "jpeg"] }
        return [normalized]
    }()
    
    let subdirsToTry: [String?] = ["images", nil]
    
    // Пробуем найти в поддиректориях
    for subdir in subdirsToTry {
        for candidateExt in extsToTry {
            if let url = Bundle.main.url(forResource: name, withExtension: candidateExt, subdirectory: subdir),
               let uiImage = UIImage(contentsOfFile: url.path) {
                return Image(uiImage: uiImage)
            }
        }
    }
    
    // Пробуем найти как "<name>.<ext>" в bundle
    for candidateExt in extsToTry {
        if let uiImage = UIImage(named: "\(name).\(candidateExt)") {
            return Image(uiImage: uiImage)
        }
    }
    
    // Пробуем найти просто по имени
    if let uiImage = UIImage(named: name) {
        return Image(uiImage: uiImage)
    }
    
    // Fallback
    return Image(systemName: "photo")
}

#Preview {
    NavigationView {
        HomeView(selectedTab: .constant(.home))
    }
}
