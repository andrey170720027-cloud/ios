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
            
            let horizontalPadding: CGFloat = isSmallScreen ? 16 : (isLargeScreen ? 24 : 20)
            let topPadding: CGFloat = isSmallScreen ? 16 : (isLargeScreen ? 32 : 24)
            let cardSpacing: CGFloat = isSmallScreen ? 8 : (isLargeScreen ? 16 : 12)
            let cardImageHeight: CGFloat = isSmallScreen ? 150 : (isLargeScreen ? 200 : 170)
            let bannerHeight: CGFloat = isSmallScreen ? 170 : (isLargeScreen ? 220 : 190)
            let bottomBannerHeight: CGFloat = isSmallScreen ? 140 : (isLargeScreen ? 180 : 160)
            
            ZStack {
                VStack(spacing: 0) {
                    // Заголовок с поиском
                    HStack {
                        Text("Shop")
                            .font(.system(size: titleFontSize, weight: .bold))
                            .foregroundColor(.black)

                        Spacer()

                        Button(action: {
                            // Действие поиска
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: searchIconSize))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, topPadding)
                    .padding(.bottom, isSmallScreen ? 8 : 12)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: isSmallScreen ? 16 : 20) {
                            // Навигация по категориям
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: isSmallScreen ? 20 : (isLargeScreen ? 32 : 28)) {
                                    ForEach(categories) { category in
                                        Button(action: {
                                            selectedCategory = category.name
                                            // Обновляем активную категорию
                                            categories = categories.map { cat in
                                                Category(name: cat.name, isActive: cat.name == category.name)
                                            }
                                        }) {
                                            VStack(spacing: isSmallScreen ? 6 : 8) {
                                                Text(category.name)
                                                    .font(.system(size: categoryFontSize, weight: category.isActive ? .bold : .regular))
                                                    .foregroundColor(category.isActive ? .black : .gray)

                                                if category.isActive {
                                                    Rectangle()
                                                        .fill(Color.black)
                                                        .frame(width: isSmallScreen ? 24 : (isLargeScreen ? 32 : 28), height: 2)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, horizontalPadding)
                            }
                            .padding(.bottom, isSmallScreen ? 8 : 12)
                            
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
                                    productFilter: { $0.status == .bestseller }
                                )) {
                                    VStack(alignment: .leading, spacing: isSmallScreen ? 8 : 10) {
                                        shopImage(name: "Shop1", ext: "png")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: cardImageHeight)
                                            .clipped()
                                            .cornerRadius(8)

                                        Text("Best Sellers")
                                            .font(.system(size: cardTitleFontSize, weight: .bold))
                                            .foregroundColor(.black)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                // Правая карточка - Featured in Nike Air
                                NavigationLink(destination: ProductSectionView(
                                    sectionTitle: "Featured in Nike Air",
                                    productFilter: { product in
                                        product.brand.lowercased().contains("nike") && 
                                        (product.name.lowercased().contains("air") || product.description.lowercased().contains("air"))
                                    }
                                )) {
                                    VStack(alignment: .leading, spacing: isSmallScreen ? 8 : 10) {
                                        shopImage(name: "Shop2", ext: "png")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: cardImageHeight)
                                            .clipped()
                                            .cornerRadius(8)

                                        Text("Featured in Nike Air")
                                            .font(.system(size: cardTitleFontSize, weight: .bold))
                                            .foregroundColor(.black)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(.horizontal, horizontalPadding)
                            
                            // Широкий баннер - New & Featured
                            NavigationLink(destination: ProductSectionView(
                                sectionTitle: "New & Featured",
                                productFilter: nil
                            )) {
                                ZStack(alignment: .bottomLeading) {
                                    shopImage(name: "Shop3", ext: "png")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: bannerHeight)
                                        .clipped()
                                        .cornerRadius(8)

                                    Text("New & Featured")
                                        .font(.system(size: bannerTitleFontSize, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.leading, isSmallScreen ? 12 : (isLargeScreen ? 20 : 16))
                                        .padding(.bottom, isSmallScreen ? 12 : (isLargeScreen ? 20 : 16))
                                }
                            }
                            .padding(.horizontal, horizontalPadding)
                            
                            // Дополнительный баннер (частично видимый)
                            NavigationLink(destination: ProductSectionView(
                                sectionTitle: "All Products",
                                productFilter: nil
                            )) {
                                shopImage(name: "8", ext: "jpg")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: bottomBannerHeight)
                                    .clipped()
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal, horizontalPadding)
                            .padding(.bottom, isSmallScreen ? 70 : (isLargeScreen ? 90 : 80)) // Отступ для TabBar
                        }
                        .padding(.top, isSmallScreen ? 6 : 8)
                    }
                    
                    Spacer()
                }
                
                // TabBar внизу
                VStack {
                    Spacer()
                    TabBarView(selectedTab: $selectedTab)
                }
            }
        }
        .navigationBarHidden(true)
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

#Preview {
    NavigationView {
        ShopView()
    }
}
