//
//  BagView.swift
//  IOS3
//
//  Created by krupchakd on 23.01.2026.
//

import SwiftUI

struct BagView: View {
    @ObservedObject private var tabManager = TabManager.shared
    @ObservedObject private var cartService = CartService.shared
    @State private var products: [Product] = []
    @State private var showCheckoutAlert = false
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let isSmallScreen = screenWidth < 375
            let isLargeScreen = screenWidth > 414
            
            let titleFontSize: CGFloat = isSmallScreen ? 28 : (isLargeScreen ? 36 : 32)
            
            ZStack {
                VStack(spacing: 0) {
                    // Заголовок
                    HStack {
                        Text("Bag")
                            .font(.system(size: titleFontSize, weight: .bold))
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        Button(action: {
                            // Действие поиска
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: isSmallScreen ? 20 : (isLargeScreen ? 24 : 22), weight: .regular))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                    
                    // Контент корзины
                    if cartService.cartItems.isEmpty {
                        // Пустое состояние
                        ScrollView {
                            VStack(spacing: 20) {
                                Image(systemName: "bag")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray.opacity(0.5))
                                
                                Text("Ваша корзина пуста")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                Text("Добавьте товары в корзину, чтобы они появились здесь")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray.opacity(0.7))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 100)
                            .padding(.bottom, 80)
                        }
                    } else {
                        ScrollView {
                            VStack(spacing: 16) {
                                // Список товаров
                                ForEach(cartService.cartItems) { item in
                                    CartItemRowView(
                                        item: item,
                                        onQuantityChange: { newQuantity in
                                            cartService.updateQuantity(productId: item.id, quantity: newQuantity)
                                        },
                                        onRemove: {
                                            cartService.removeFromCart(productId: item.id)
                                        },
                                        product: findProduct(for: item)
                                    )
                                }
                                
                                // Итоговая сумма
                                VStack(spacing: 12) {
                                    HStack {
                                        Text("Итого")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        
                                        Text(calculateTotal())
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.black)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.top, 16)
                                    
                                    // Кнопка оформления заказа
                                    Button(action: {
                                        showCheckoutAlert = true
                                    }) {
                                        HStack {
                                            Spacer()
                                            Text("Оформить заказ")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.white)
                                            Spacer()
                                        }
                                        .padding(.vertical, 16)
                                        .background(Color.black)
                                        .cornerRadius(8)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 20)
                                }
                                .padding(.top, 8)
                            }
                            .padding(.top, 8)
                            .padding(.bottom, 80) // Отступ для TabBar
                        }
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
        .alert("Заказ оформлен", isPresented: $showCheckoutAlert) {
            Button("OK", role: .cancel) {
                cartService.clearCart()
            }
        } message: {
            Text("Ваш заказ успешно оформлен! Спасибо за покупку.")
        }
    }
    
    private func loadProducts() async {
        do {
            let loadedProducts = try await ProductService.shared.fetchProducts()
            await MainActor.run {
                self.products = loadedProducts
            }
        } catch {
            print("Ошибка загрузки товаров: \(error.localizedDescription)")
        }
    }
    
    private func findProduct(for cartItem: CartItem) -> Product? {
        return products.first { $0.stableId == cartItem.id }
    }
    
    private func calculateTotal() -> String {
        let total = cartService.cartItems.reduce(0.0) { sum, item in
            let priceValue = parsePrice(item.price)
            return sum + (priceValue * Double(item.quantity))
        }
        
        if total.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "US$%.0f", total)
        } else {
            return String(format: "US$%.2f", total)
        }
    }
    
    private func parsePrice(_ priceString: String) -> Double {
        // Удаляем "US$" и пробелы, затем парсим число
        let cleaned = priceString.replacingOccurrences(of: "US$", with: "")
            .replacingOccurrences(of: " ", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        return Double(cleaned) ?? 0.0
    }
}

// Компонент для отображения товара в корзине
struct CartItemRowView: View {
    let item: CartItem
    let onQuantityChange: (Int) -> Void
    let onRemove: () -> Void
    let product: Product?
    
    @State private var showProductDetail = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Изображение товара
            Group {
                if let imageURL = item.image, let url = URL(string: imageURL) {
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
                } else if let imageName = item.image {
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
            
            // Информация о товаре
            VStack(alignment: .leading, spacing: 8) {
                // Название товара (кликабельное для навигации)
                if let product = product {
                    Button(action: {
                        showProductDetail = true
                    }) {
                        Text(item.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                } else {
                    Text(item.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                
                // Цена
                Text(item.price)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                
                // Управление количеством
                HStack(spacing: 12) {
                    // Кнопка уменьшения
                    Button(action: {
                        if item.quantity > 1 {
                            onQuantityChange(item.quantity - 1)
                        } else {
                            onRemove()
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                    
                    // Количество
                    Text("\(item.quantity)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(minWidth: 30)
                    
                    // Кнопка увеличения
                    Button(action: {
                        onQuantityChange(item.quantity + 1)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    // Кнопка удаления
                    Button(action: {
                        onRemove()
                    }) {
                        Image(systemName: "trash")
                            .font(.system(size: 18))
                            .foregroundColor(.red)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.white)
        .sheet(isPresented: $showProductDetail) {
            if let product = product {
                NavigationView {
                    ProductDetailView(product: product)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        BagView()
    }
}
