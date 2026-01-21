//
//  CartService.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import Foundation
import Combine
import SwiftUI

class CartService: ObservableObject {
    static let shared = CartService()
    
    @Published var cartItems: [CartItem] = []
    private let userDefaultsKey = "cartItems"
    
    private init() {
        loadCart()
    }
    
    // Добавить товар в корзину или увеличить количество
    func addToCart(product: Product) {
        let productId = product.stableId
        let image = product.imageURL ?? product.imageName
        
        if let existingIndex = cartItems.firstIndex(where: { $0.id == productId }) {
            // Товар уже есть в корзине - увеличиваем количество
            var existingItem = cartItems[existingIndex]
            existingItem.quantity += 1
            cartItems[existingIndex] = existingItem
        } else {
            // Новый товар - добавляем в корзину
            let newItem = CartItem(
                id: productId,
                name: product.name,
                price: product.price,
                image: image,
                quantity: 1
            )
            cartItems.append(newItem)
        }
        saveCart()
    }
    
    // Удалить товар из корзины
    func removeFromCart(productId: String) {
        cartItems.removeAll { $0.id == productId }
        saveCart()
    }
    
    // Изменить количество товара
    func updateQuantity(productId: String, quantity: Int) {
        guard let index = cartItems.firstIndex(where: { $0.id == productId }) else {
            return
        }
        
        if quantity <= 0 {
            removeFromCart(productId: productId)
        } else {
            var item = cartItems[index]
            item.quantity = quantity
            cartItems[index] = item
            saveCart()
        }
    }
    
    // Получить элемент корзины по ID
    func getCartItem(productId: String) -> CartItem? {
        return cartItems.first { $0.id == productId }
    }
    
    // Получить общее количество товаров в корзине
    func getTotalItems() -> Int {
        return cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    // Проверить, есть ли товар в корзине
    func isInCart(productId: String) -> Bool {
        return cartItems.contains { $0.id == productId }
    }
    
    // Очистить корзину
    func clearCart() {
        cartItems.removeAll()
        saveCart()
    }
    
    // Загрузить корзину из UserDefaults
    private func loadCart() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let items = try? JSONDecoder().decode([CartItem].self, from: data) {
            cartItems = items
        }
    }
    
    // Сохранить корзину в UserDefaults
    private func saveCart() {
        if let data = try? JSONEncoder().encode(cartItems) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
}
