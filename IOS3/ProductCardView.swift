//
//  ProductCardView.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI

struct ProductCardView: View {
    let product: Product
    @ObservedObject private var favoritesService = FavoritesService.shared
    @ObservedObject private var cartService = CartService.shared
    @ObservedObject private var tabManager = TabManager.shared
    @Environment(\.dismiss) private var dismiss
    
    private var isFavorite: Bool {
        favoritesService.isFavorite(productId: product.stableId)
    }
    
    private var isInCart: Bool {
        cartService.isInCart(productId: product.stableId)
    }
    
    private var cartQuantity: Int {
        cartService.getCartItem(productId: product.stableId)?.quantity ?? 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Изображение товара
            ZStack(alignment: .topTrailing) {
                // Используем AsyncImage для URL или обычный Image для локальных изображений
                Group {
                    if let imageURL = product.imageURL, let url = URL(string: imageURL) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(height: 200)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.gray)
                                    .frame(height: 200)
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
                            .frame(height: 200)
                    }
                }
                .frame(height: 200)
                .clipped()
                .cornerRadius(8)
                
                // Иконка избранного
                Button(action: {
                    favoritesService.toggleFavorite(productId: product.stableId)
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 18))
                        .foregroundColor(isFavorite ? .red : .black)
                        .padding(8)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                }
                .padding(8)
            }
            
            // Статус товара
            if let status = product.status {
                Text(statusText(status))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(statusColor(status))
                    .padding(.top, 4)
            }
            
            // Название товара
            Text(product.name)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.black)
            
            // Описание
            Text(product.description)
                .font(.system(size: 12))
                .foregroundColor(.gray)
            
            // Количество цветов (показываем только если есть)
            if product.colors > 0 {
                Text("\(product.colors) Colours")
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
            }
            
            // Цена
            Text(product.price)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black)
                .padding(.top, 2)
            
            // Кнопка добавления в корзину или управление количеством
            if isInCart {
                // Если товар в корзине - показываем управление количеством и кнопку перехода
                VStack(spacing: 8) {
                    // Управление количеством
                    HStack(spacing: 12) {
                        // Кнопка уменьшения
                        Button(action: {
                            if cartQuantity > 1 {
                                cartService.updateQuantity(productId: product.stableId, quantity: cartQuantity - 1)
                            } else {
                                cartService.removeFromCart(productId: product.stableId)
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                        }
                        
                        // Количество
                        Text("\(cartQuantity)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(minWidth: 30)
                        
                        // Кнопка увеличения
                        Button(action: {
                            cartService.updateQuantity(productId: product.stableId, quantity: cartQuantity + 1)
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 4)
                    
                    // Кнопка перехода в корзину
                    Button(action: {
                        // Закрываем текущий view (если находимся в навигации) и переключаемся на вкладку корзины
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            tabManager.selectedTab = .bag
                        }
                    }) {
                        HStack {
                            Spacer()
                            Text("Перейти в корзину")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .background(Color.black)
                        .cornerRadius(8)
                    }
                    .padding(.top, 4)
                }
            } else {
                // Если товара нет в корзине - показываем кнопку добавления
                Button(action: {
                    cartService.addToCart(product: product)
                }) {
                    HStack {
                        Spacer()
                        Text("Добавить в корзину")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .background(Color.black)
                    .cornerRadius(8)
                }
                .padding(.top, 4)
            }
        }
    }
    
    private func statusText(_ status: Product.ProductStatus) -> String {
        switch status {
        case .soldOut:
            return "Sold Out"
        case .bestseller:
            return "Bestseller"
        }
    }
    
    private func statusColor(_ status: Product.ProductStatus) -> Color {
        switch status {
        case .soldOut:
            return .orange
        case .bestseller:
            return .orange
        }
    }
}

#Preview {
    ProductCardView(product: Product.sampleProducts[0])
        .frame(width: 180)
        .padding()
}
