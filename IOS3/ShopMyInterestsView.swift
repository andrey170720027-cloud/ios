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
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Заголовок
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
                        // Действие поиска
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 16)
                
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

#Preview {
    NavigationView {
        ShopMyInterestsView()
    }
}
