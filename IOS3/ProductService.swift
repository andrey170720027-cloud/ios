//
//  ProductService.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import Foundation

class ProductService {
    static let shared = ProductService()
    
    private var cachedProducts: [Product]?
    private let cacheQueue = DispatchQueue(label: "com.ios3.productservice.cache")
    
    private init() {}
    
    /// Загружает товары из JSON файла с кэшированием
    /// - Returns: Массив товаров
    /// - Throws: ProductServiceError при ошибках загрузки или декодирования
    func fetchProducts() async throws -> [Product] {
        // Проверяем кэш
        if let cached = await getCachedProducts() {
            return cached
        }
        
        // Небольшая задержка для имитации сетевого запроса
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 секунды
        
        // Загружаем JSON файл
        guard let url = Bundle.main.url(forResource: "products", withExtension: "json") else {
            throw ProductServiceError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let responses = try decoder.decode([ProductResponse].self, from: data)
            
            // Конвертируем ProductResponse в Product
            let products = responses.map { Product(from: $0) }
            
            // Сохраняем в кэш
            await setCachedProducts(products)
            
            return products
        } catch {
            if let decodingError = error as? DecodingError {
                throw ProductServiceError.decodingError(decodingError)
            }
            throw ProductServiceError.decodingError(error)
        }
    }
    
    /// Очищает кэш товаров
    func clearCache() {
        cacheQueue.sync {
            cachedProducts = nil
        }
    }
    
    private func getCachedProducts() async -> [Product]? {
        return await withCheckedContinuation { continuation in
            cacheQueue.async {
                continuation.resume(returning: self.cachedProducts)
            }
        }
    }
    
    private func setCachedProducts(_ products: [Product]) async {
        await withCheckedContinuation { continuation in
            cacheQueue.async {
                self.cachedProducts = products
                continuation.resume()
            }
        }
    }
}

enum ProductServiceError: Error {
    case fileNotFound
    case decodingError(Error)
    
    var localizedDescription: String {
        switch self {
        case .fileNotFound:
            return "Файл products.json не найден"
        case .decodingError(let error):
            return "Ошибка декодирования: \(error.localizedDescription)"
        }
    }
}
