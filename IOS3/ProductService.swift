//
//  ProductService.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import Foundation

class ProductService {
    static let shared = ProductService()
    
    private init() {}
    
    // Мокирование запроса к бэкенду
    func fetchProducts() async throws -> [Product] {
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
            
            return products
        } catch {
            throw ProductServiceError.decodingError(error)
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
