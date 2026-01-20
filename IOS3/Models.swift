//
//  Models.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import Foundation

// Модель товара
struct Product: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let price: String
    let imageName: String
    let colors: Int
    let status: ProductStatus?
    let isFavorite: Bool
    
    enum ProductStatus {
        case soldOut
        case bestseller
    }
}

// Модель категории
struct Category: Identifiable {
    let id = UUID()
    let name: String
    let isActive: Bool
}

// Модель интереса
struct Interest: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
}

// Мок-данные для тестирования
extension Product {
    static let sampleProducts: [Product] = [
        Product(name: "Nike Elite Pro", description: "Basketball Backpack (32L)", price: "US$85", imageName: "2", colors: 3, status: .soldOut, isFavorite: false),
        Product(name: "Nike Heritage", description: "Basketball Backpack (32L)", price: "US$40.97", imageName: "2", colors: 4, status: .soldOut, isFavorite: false),
        Product(name: "Nike Therma", description: "Men's Pullover Training Hoodie", price: "US$33.97", imageName: "2", colors: 5, status: .bestseller, isFavorite: false),
        Product(name: "Nike Sportwear Club Fleece", description: "Men's Pants", price: "US$33.97", imageName: "2", colors: 3, status: .bestseller, isFavorite: false),
        Product(name: "Jordan Essentials", description: "Men Fleece Pullover Hoodie", price: "US$60", imageName: "2", colors: 5, status: nil, isFavorite: false),
        Product(name: "Jordan Essentials", description: "Men Fleece Pullover", price: "US$60", imageName: "2", colors: 6, status: nil, isFavorite: false),
        Product(name: "Nike Air Force 1 '07", description: "Classic Sneakers", price: "US$90", imageName: "2", colors: 2, status: nil, isFavorite: false)
    ]
}

extension Category {
    static let shopCategories: [Category] = [
        Category(name: "Men", isActive: true),
        Category(name: "Women", isActive: false),
        Category(name: "Kids", isActive: false)
    ]
    
    static let bestSellersCategories: [Category] = [
        Category(name: "Accessories & Equipment", isActive: true),
        Category(name: "Socks", isActive: false),
        Category(name: "Bags", isActive: false)
    ]
    
    static let jordanCategories: [Category] = [
        Category(name: "All", isActive: true),
        Category(name: "Tops & T-Shirts", isActive: false),
        Category(name: "Hoodies & Pullovers", isActive: false)
    ]
}

extension Interest {
    static let sampleInterests: [Interest] = [
        Interest(name: "Running", imageName: "2"),
        Interest(name: "Basketball", imageName: "2"),
        Interest(name: "Training", imageName: "2")
    ]
}
