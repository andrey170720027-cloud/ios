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
    let imageName: String? // Для обратной совместимости
    let imageURL: String? // URL изображения из API
    let brand: String
    let colors: Int
    let status: ProductStatus?
    let isFavorite: Bool
    let category: String?
    let productType: String?
    
    // Стабильный идентификатор товара для избранного
    var stableId: String {
        let components = [
            brand,
            name,
            description,
            imageURL ?? imageName ?? ""
        ]
        return components.joined(separator: "|")
    }
    
    enum ProductStatus {
        case soldOut
        case bestseller
    }
    
    // Инициализатор из ProductResponse
    init(from response: ProductResponse) {
        self.brand = response.brand.isEmpty ? "Nike" : response.brand
        
        // Парсим product_name для извлечения названия и описания
        let productNameParts = response.product_name.components(separatedBy: " ")
        var nameParts: [String] = []
        var descriptionParts: [String] = []
        var foundColors = false
        
        // Ищем количество цветов в названии
        var colorsCount = 0
        for (index, part) in productNameParts.enumerated() {
            if part.lowercased() == "colours" || part.lowercased() == "colors" {
                if index > 0, let count = Int(productNameParts[index - 1]) {
                    colorsCount = count
                    foundColors = true
                    // Все до этого - название и описание
                    let beforeColors = productNameParts[0..<index-1]
                    // Разделяем на название (первое слово - бренд или первая часть) и описание
                    if beforeColors.count > 0 {
                        nameParts = [String(beforeColors[0])]
                        if beforeColors.count > 1 {
                            descriptionParts = Array(beforeColors[1...])
                        }
                    }
                }
                break
            }
        }
        
        // Если не нашли цвета в формате "X Colours", пытаемся извлечь из названия
        if !foundColors {
            // Пытаемся найти паттерн числа перед "Colours"
            let pattern = #"(\d+)\s+[Cc]olou?rs?"#
            if let regex = try? NSRegularExpression(pattern: pattern),
               let match = regex.firstMatch(in: response.product_name, range: NSRange(response.product_name.startIndex..., in: response.product_name)),
               let range = Range(match.range(at: 1), in: response.product_name),
               let count = Int(String(response.product_name[range])) {
                colorsCount = count
                // Удаляем "X Colours" из названия
                let cleanedName = regex.stringByReplacingMatches(in: response.product_name, range: NSRange(response.product_name.startIndex..., in: response.product_name), withTemplate: "").trimmingCharacters(in: .whitespaces)
                let parts = cleanedName.components(separatedBy: " ")
                if parts.count > 0 {
                    nameParts = [parts[0]]
                    if parts.count > 1 {
                        descriptionParts = Array(parts[1...])
                    }
                }
            } else {
                // Если не нашли, берем все как описание
                let parts = response.product_name.components(separatedBy: " ")
                if parts.count > 0 {
                    nameParts = [parts[0]]
                    if parts.count > 1 {
                        descriptionParts = Array(parts[1...])
                    }
                }
            }
        }
        
        // Формируем название и описание
        if response.product_name.isEmpty {
            self.name = self.brand
            self.description = ""
        } else if nameParts.isEmpty {
            // Если не удалось распарсить, используем бренд как название
            self.name = self.brand
            self.description = response.product_name
        } else {
            self.name = nameParts.joined(separator: " ")
            self.description = descriptionParts.joined(separator: " ")
        }
        
        // Форматируем цену
        if response.price.truncatingRemainder(dividingBy: 1) == 0 {
            self.price = String(format: "US$%.0f", response.price)
        } else {
            self.price = String(format: "US$%.2f", response.price)
        }
        
        self.imageName = nil
        self.imageURL = response.image_url
        self.colors = colorsCount
        self.isFavorite = response.is_liked
        
        // Определяем статус
        if response.items_left == 0 {
            self.status = .soldOut
        } else if response.is_bestseller {
            self.status = .bestseller
        } else {
            self.status = nil
        }
        
        // Сохраняем категорию и тип товара
        self.category = response.category
        self.productType = response.product_type
    }
    
    // Старый инициализатор для обратной совместимости
    init(name: String, description: String, price: String, imageName: String, colors: Int, status: ProductStatus?, isFavorite: Bool) {
        self.name = name
        self.description = description
        self.price = price
        self.imageName = imageName
        self.imageURL = nil
        self.brand = ""
        self.colors = colors
        self.status = status
        self.isFavorite = isFavorite
        self.category = nil
        self.productType = nil
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

// Модель элемента корзины
struct CartItem: Identifiable, Codable {
    let id: String // stableId товара
    let name: String
    let price: String
    let image: String? // imageURL или imageName
    var quantity: Int
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
        Interest(name: "Running", imageName: "image-removebg-preview 1"),
        Interest(name: "Lifestyle", imageName: "4"),
        Interest(name: "Basketball", imageName: "2"),
        Interest(name: "Training", imageName: "5")
    ]
}

// Модель результата поиска
enum SearchResultType {
    case product(Product)
    case section(String)
}

struct SearchResult: Identifiable {
    let id = UUID()
    let type: SearchResultType
    
    var displayName: String {
        switch type {
        case .product(let product):
            return product.name
        case .section(let sectionName):
            return sectionName
        }
    }
}
