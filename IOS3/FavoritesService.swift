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
    
    @Published var favoriteIdsArray: [String] = []
    private let userDefaultsKey = "favoriteProductIds"
    
    private var favoriteIds: Set<String> {
        get { Set(favoriteIdsArray) }
        set { favoriteIdsArray = Array(newValue) }
    }
    
    private init() {
        loadFavorites()
    }
    
    // Добавить товар в избранное
    func addToFavorites(productId: String) {
        var ids = favoriteIds
        ids.insert(productId)
        favoriteIds = ids
        saveFavorites()
    }
    
    // Удалить товар из избранного
    func removeFromFavorites(productId: String) {
        var ids = favoriteIds
        ids.remove(productId)
        favoriteIds = ids
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
            favoriteIdsArray = idsArray
        }
    }
    
    // Сохранить избранное в UserDefaults
    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favoriteIdsArray) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
}
