//
//  ShopView.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI

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
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        // Действие поиска
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 16)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Навигация по категориям
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 24) {
                                ForEach(categories) { category in
                                    Button(action: {
                                        selectedCategory = category.name
                                        // Обновляем активную категорию
                                        categories = categories.map { cat in
                                            Category(name: cat.name, isActive: cat.name == category.name)
                                        }
                                    }) {
                                        VStack(spacing: 4) {
                                            Text(category.name)
                                                .font(.system(size: 16, weight: category.isActive ? .bold : .regular))
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
                        .padding(.bottom, 8)
                        
                        // Заголовок секции
                        Text("Must-Haves, Best Sellers & More")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                        
                        // Две карточки товаров
                        HStack(spacing: 12) {
                            // Левая карточка - Best Sellers
                            NavigationLink(destination: ProductSectionView(
                                sectionTitle: "Best Sellers",
                                productFilter: { $0.status == .bestseller }
                            )) {
                                ZStack(alignment: .bottomLeading) {
                                    Image("3")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 200)
                                        .clipped()
                                        .cornerRadius(12)
                                    
                                    LinearGradient(
                                        colors: [Color.clear, Color.black.opacity(0.6)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                    .cornerRadius(12)
                                    
                                    Text("Best Sellers")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.leading, 16)
                                        .padding(.bottom, 16)
                                }
                            }
                            
                            // Правая карточка - Featured in Nike Air
                            NavigationLink(destination: ProductSectionView(
                                sectionTitle: "Featured in Nike Air",
                                productFilter: { product in
                                    product.brand.lowercased().contains("nike") && 
                                    (product.name.lowercased().contains("air") || product.description.lowercased().contains("air"))
                                }
                            )) {
                                ZStack(alignment: .bottomTrailing) {
                                    Image("4")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 200)
                                        .clipped()
                                        .cornerRadius(12)
                                    
                                    LinearGradient(
                                        colors: [Color.clear, Color.black.opacity(0.6)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                    .cornerRadius(12)
                                    
                                    Text("Featured in Nike Air")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.trailing, 16)
                                        .padding(.bottom, 16)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Широкий баннер - New & Featured
                        NavigationLink(destination: ProductSectionView(
                            sectionTitle: "New & Featured",
                            productFilter: nil
                        )) {
                            ZStack(alignment: .bottomLeading) {
                                Image("7")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 250)
                                    .clipped()
                                    .cornerRadius(12)
                                
                                LinearGradient(
                                    colors: [Color.clear, Color.black.opacity(0.6)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .cornerRadius(12)
                                
                                Text("New & Featured")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.leading, 20)
                                    .padding(.bottom, 20)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Дополнительный баннер (частично видимый)
                        NavigationLink(destination: ProductSectionView(
                            sectionTitle: "All Products",
                            productFilter: nil
                        )) {
                            Image("8")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .clipped()
                                .cornerRadius(12)
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

#Preview {
    NavigationView {
        ShopView()
    }
}
