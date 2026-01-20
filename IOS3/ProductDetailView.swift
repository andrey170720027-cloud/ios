//
//  ProductDetailView.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @Environment(\.dismiss) private var dismiss
    @State private var selectedImageIndex = 0
    @State private var selectedTab: TabItem = .shop
    
    // Массив URL изображений (используем тот же URL несколько раз для разных вариантов)
    private var productImageURLs: [String?] {
        if let imageURL = product.imageURL {
            // Для демонстрации используем тот же URL 3 раза (в реальном приложении это были бы разные варианты)
            return [imageURL, imageURL, imageURL]
        } else if let imageName = product.imageName {
            // Для обратной совместимости с локальными изображениями
            return [imageName, imageName, imageName]
        }
        return []
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Заголовок с кнопками
                HStack {
                    // Кнопка назад
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Text(product.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Spacer()
                    
                    // Кнопка поиска
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
                    VStack(spacing: 20) {
                        // Большое изображение продукта
                        if !productImageURLs.isEmpty {
                            TabView(selection: $selectedImageIndex) {
                                ForEach(0..<productImageURLs.count, id: \.self) { index in
                                    if let imageURL = productImageURLs[index], let url = URL(string: imageURL) {
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(height: 400)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            case .failure:
                                                Image(systemName: "photo")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .foregroundColor(.gray)
                                                    .frame(height: 400)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                        .frame(height: 400)
                                        .tag(index)
                                    } else if let imageName = productImageURLs[index] {
                                        Image(imageName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 400)
                                            .tag(index)
                                    }
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            .frame(height: 400)
                            
                            // Индикатор прокрутки изображений
                            HStack(spacing: 4) {
                                ForEach(0..<productImageURLs.count, id: \.self) { index in
                                    Rectangle()
                                        .fill(selectedImageIndex == index ? Color.black : Color.gray.opacity(0.3))
                                        .frame(width: selectedImageIndex == index ? 20 : 8, height: 2)
                                        .animation(.easeInOut, value: selectedImageIndex)
                                }
                            }
                            .padding(.top, -10)
                            
                            // Миниатюры вариантов продукта
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(0..<productImageURLs.count, id: \.self) { index in
                                        Button(action: {
                                            selectedImageIndex = index
                                        }) {
                                            Group {
                                                if let imageURL = productImageURLs[index], let url = URL(string: imageURL) {
                                                    AsyncImage(url: url) { phase in
                                                        switch phase {
                                                        case .empty:
                                                            ProgressView()
                                                                .frame(width: 100, height: 100)
                                                        case .success(let image):
                                                            image
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fill)
                                                        case .failure:
                                                            Image(systemName: "photo")
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .foregroundColor(.gray)
                                                                .frame(width: 100, height: 100)
                                                        @unknown default:
                                                            EmptyView()
                                                        }
                                                    }
                                                } else if let imageName = productImageURLs[index] {
                                                    Image(imageName)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                } else {
                                                    Image(systemName: "photo")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .foregroundColor(.gray)
                                                        .frame(width: 100, height: 100)
                                                }
                                            }
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(selectedImageIndex == index ? Color.black : Color.clear, lineWidth: 2)
                                            )
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                        } else {
                            // Fallback если нет изображений
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.gray)
                                .frame(height: 400)
                        }
                        .padding(.bottom, 80) // Отступ для TabBar
                    }
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
        ProductDetailView(product: Product.sampleProducts[0])
    }
}
