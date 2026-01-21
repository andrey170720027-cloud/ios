//
//  ProductResponse.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import Foundation

// Модель для декодирования JSON ответа от API
struct ProductResponse: Codable {
    let brand: String
    let product_name: String
    let price: Double
    let items_left: Int
    let image_url: String
    let is_liked: Bool
    let is_bestseller: Bool
    let category: String?
    let product_type: String?
}
