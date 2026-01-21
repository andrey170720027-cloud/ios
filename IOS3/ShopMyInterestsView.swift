//
//  ShopMyInterestsView.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI

struct ShopMyInterestsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: TabItem = .shop
    @State private var interests = Interest.sampleInterests
    @State private var recommendedProducts: [Product] = []
    @State private var isLoading = true
    @State private var isSearchActive = false
    @State private var searchText = ""
    @State private var searchResults: [SearchResult] = []
    @State private var allProducts: [Product] = []
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Заголовок или поиск
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
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 16)
                } else {
                    // Обычный заголовок
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Text("Shop")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
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
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
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
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 20)
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
                                                .padding(.horizontal, 20)
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
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 20)
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
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                        .padding(.bottom, 80)
                    }
                } else {
                    // Обычный контент
                    ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Секция "Shop My Interests"
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Shop My Interests")
                                    .font(.system(size: 24, weight: .bold))
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
                            .padding(.horizontal, 20)
                            
                            // Горизонтальный список интересов
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(interests) { interest in
                                        ZStack {
                                            Image(interest.imageName)
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
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // Секция "Recommended for You"
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recommended for You")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                            
                            // Горизонтальный список товаров
                            if isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 40)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(recommendedProducts.prefix(5)) { product in
                                            NavigationLink(destination: ProductDetailView(product: product)) {
                                                VStack(alignment: .leading, spacing: 8) {
                                                    // Используем AsyncImage для URL или обычный Image для локальных
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
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                        .padding(.bottom, 80) // Отступ для TabBar
                    }
                    .padding(.top, 8)
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
        ShopMyInterestsView()
    }
}
