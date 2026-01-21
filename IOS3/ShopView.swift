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
        ZStack {
            VStack(spacing: 0) {
                // Заголовок с поиском
                HStack {
                    Text("Shop")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)

                    Spacer()

                    Button(action: {
                        // Действие поиска
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 22))
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 12)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Навигация по категориям
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 28) {
                                ForEach(categories) { category in
                                    Button(action: {
                                        selectedCategory = category.name
                                        // Обновляем активную категорию
                                        categories = categories.map { cat in
                                            Category(name: cat.name, isActive: cat.name == category.name)
                                        }
                                    }) {
                                        VStack(spacing: 8) {
                                            Text(category.name)
                                                .font(.system(size: 18, weight: category.isActive ? .bold : .regular))
                                                .foregroundColor(category.isActive ? .black : .gray)

                                            if category.isActive {
                                                Rectangle()
                                                    .fill(Color.black)
                                                    .frame(width: 28, height: 2)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom, 12)
                        
                        // Заголовок секции
                        Text("Must-Haves, Best Sellers & More")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                        
                        // Две карточки товаров
                        HStack(spacing: 12) {
                            // Левая карточка - Best Sellers
                            NavigationLink(destination: ProductSectionView(
                                sectionTitle: "Best Sellers",
                                productFilter: { $0.status == .bestseller }
                            )) {
                                VStack(alignment: .leading, spacing: 10) {
                                    Image("Shop1")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 170)
                                        .clipped()
                                        .cornerRadius(8)

                                    Text("Best Sellers")
                                        .font(.system(size: 16, weight: .bold))
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
                                VStack(alignment: .leading, spacing: 10) {
                                    Image("Shop2")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 170)
                                        .clipped()
                                        .cornerRadius(8)

                                    Text("Featured in Nike Air")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.black)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Широкий баннер - New & Featured
                        NavigationLink(destination: ProductSectionView(
                            sectionTitle: "New & Featured",
                            productFilter: nil
                        )) {
                            ZStack(alignment: .bottomLeading) {
                                Image("Shop3")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 190)
                                    .clipped()
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Дополнительный баннер (частично видимый)
                        NavigationLink(destination: ProductSectionView(
                            sectionTitle: "All Products",
                            productFilter: nil
                        )) {
                            shopImage(name: "8", ext: "jpg")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 160)
                                .clipped()
                                .cornerRadius(8)
                        }
                        .padding(.horizontal, 20)
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
