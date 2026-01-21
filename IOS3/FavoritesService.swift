//
//  FavoritesService.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import Foundation
import Combine
import SwiftUI

class FavoritesService: ObservableObject {
    static let shared = FavoritesService()
    
    @Published var favoriteIds: Set<String> = []
    private let userDefaultsKey = "favoriteProductIds"
    
    private init() {
        loadFavorites()
    }
    
    // Добавить товар в избранное
    func addToFavorites(productId: String) {
        favoriteIds.insert(productId)
        saveFavorites()
    }
    
    // Удалить товар из избранного
    func removeFromFavorites(productId: String) {
        favoriteIds.remove(productId)
        saveFavorites()
    }
    
    // Переключить статус избранного
    func toggleFavorite(productId: String) {
        if isFavorite(productId: productId) {
            removeFromFavorites(productId: productId)
        } else {
            addToFavorites(productId: productId)
        }
    }
    
    // Проверить, находится ли товар в избранном
    func isFavorite(productId: String) -> Bool {
        return favoriteIds.contains(productId)
    }
    
    // Получить все ID избранных товаров
    func getFavoriteProductIds() -> Set<String> {
        return favoriteIds
    }
    
    // Загрузить избранное из UserDefaults
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let idsArray = try? JSONDecoder().decode([String].self, from: data) {
            favoriteIds = Set(idsArray)
        }
    }
    
    // Сохранить избранное в UserDefaults
    private func saveFavorites() {
        let idsArray = Array(favoriteIds)
        if let data = try? JSONEncoder().encode(idsArray) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
}
