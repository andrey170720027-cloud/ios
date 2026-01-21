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
                    // Верхняя панель навигации
                    HStack {
                        Spacer()
                        
                        Text("Shop")
                            .font(.system(size: titleFontSize, weight: .bold))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button(action: {
                            // Действие поиска
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: searchIconSize, weight: .regular))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, topPadding)
                    .padding(.bottom, 16)
                    
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
                                            Button(action: {
                                                // Переход к товарам по интересу
                                                selectedTab = .shop
                                            }) {
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
                self.isLoading = false
            }
        } catch {
            print("Ошибка загрузки товаров: \(error.localizedDescription)")
            await MainActor.run {
                self.isLoading = false
            }
        }
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
