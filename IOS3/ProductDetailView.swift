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
    @State private var isAddedToCart = false
    @ObservedObject private var tabManager = TabManager.shared
    @ObservedObject private var favoritesService = FavoritesService.shared
    @ObservedObject private var cartService = CartService.shared
    @State private var previousTab: TabItem?
    
    private var isFavorite: Bool {
        favoritesService.isFavorite(productId: product.stableId)
    }
    
    private var isInCart: Bool {
        cartService.isInCart(productId: product.stableId)
    }
    
    private var cartQuantity: Int {
        cartService.getCartItem(productId: product.stableId)?.quantity ?? 0
    }
    
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
                    
                    HStack(spacing: 16) {
                        // Кнопка избранного
                        Button(action: {
                            favoritesService.toggleFavorite(productId: product.stableId)
                        }) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 18))
                                .foregroundColor(isFavorite ? .red : .black)
                        }
                        
                        // Кнопка поиска
                        Button(action: {
                            // Действие поиска
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 16)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Большое изображение продукта
                        Group {
                            if !productImageURLs.isEmpty {
                                VStack(spacing: 20) {
                                    TabView(selection: $selectedImageIndex) {
                                        ForEach(0..<productImageURLs.count, id: \.self) { index in
                                            ProductImageView(
                                                imageURL: productImageURLs[index],
                                                imageName: productImageURLs[index],
                                                height: 400,
                                                contentMode: .fit
                                            )
                                            .tag(index)
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
                                                    ProductImageView(
                                                        imageURL: productImageURLs[index],
                                                        imageName: productImageURLs[index],
                                                        width: 100,
                                                        height: 100,
                                                        contentMode: .fill
                                                    )
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
                                }
                            } else {
                                // Fallback если нет изображений
                                ProductImageView(height: 400, contentMode: .fit)
                            }
                        }
                        
                        // Информация о товаре
                        VStack(alignment: .leading, spacing: 16) {
                            // Название товара
                            Text(product.name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                            
                            // Описание товара
                            if !product.description.isEmpty {
                                Text(product.description)
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .lineSpacing(4)
                            }
                            
                            // Цена товара
                            Text(product.price)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                                .padding(.top, 4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        
                        // Кнопка добавления в корзину или управление количеством
                        if isInCart {
                            // Если товар в корзине - показываем управление количеством и кнопку перехода
                            VStack(spacing: 12) {
                                // Управление количеством
                                CartQuantityControl(
                                    quantity: cartQuantity,
                                    onDecrease: {
                                        if cartQuantity > 1 {
                                            cartService.updateQuantity(productId: product.stableId, quantity: cartQuantity - 1)
                                        } else {
                                            cartService.removeFromCart(productId: product.stableId)
                                        }
                                    },
                                    onIncrease: {
                                        cartService.updateQuantity(productId: product.stableId, quantity: cartQuantity + 1)
                                    },
                                    onRemove: {
                                        cartService.removeFromCart(productId: product.stableId)
                                    },
                                    showRemoveButton: false
                                )
                                .padding(.horizontal, 20)
                                
                                // Кнопка перехода в корзину
                                Button(action: {
                                    withAnimation {
                                        tabManager.selectedTab = .bag
                                    }
                                }) {
                                    HStack {
                                        Spacer()
                                        Text("Перейти в корзину")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                        Spacer()
                                    }
                                    .padding(.vertical, 16)
                                    .background(Color.black)
                                    .cornerRadius(8)
                                }
                                .padding(.horizontal, 20)
                            }
                            .padding(.top, 8)
                        } else {
                            // Если товара нет в корзине - показываем кнопку добавления
                            Button(action: {
                                cartService.addToCart(product: product)
                                isAddedToCart = true
                                
                                // Сбрасываем флаг через 2 секунды
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    isAddedToCart = false
                                }
                            }) {
                                HStack {
                                    Spacer()
                                    Text(isAddedToCart ? "Добавлено в корзину" : "Добавить в корзину")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding(.vertical, 16)
                                .background(isAddedToCart ? Color.green : Color.black)
                                .cornerRadius(8)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                        }
                    }
                    .padding(.bottom, 100) // Отступ для TabBar и кнопки
                }
                
                Spacer()
            }
            
            // TabBar внизу
            VStack {
                Spacer()
                TabBarView(selectedTab: $tabManager.selectedTab)
            }
        }
        .navigationBarHidden(true)
        .onChange(of: tabManager.selectedTab) { oldValue, newValue in
            // Если переключились на другую вкладку, закрываем текущий view
            if let prevTab = previousTab, newValue != prevTab {
                dismiss()
            }
            previousTab = newValue
        }
        .onAppear {
            previousTab = tabManager.selectedTab
        }
    }
}

#Preview {
    NavigationView {
        ProductDetailView(product: Product.sampleProducts[0])
    }
}
