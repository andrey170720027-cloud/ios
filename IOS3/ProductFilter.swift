//
//  ProductFilter.swift
//  IOS3
//
//  Утилиты для фильтрации товаров
//

import Foundation

/// Проверяет, соответствует ли товар указанному интересу
/// - Parameters:
///   - product: Товар для проверки
///   - interest: Название интереса (Running, Basketball, Training, Lifestyle)
/// - Returns: true, если товар соответствует интересу
func matchesProductInterest(product: Product, interest: String) -> Bool {
    let productName = (product.name + " " + product.description).lowercased()
    let productType = (product.productType ?? "").lowercased()
    let brand = product.brand.lowercased()
    let interestLower = interest.lowercased()
    
    switch interestLower {
    case "running":
        return productName.contains("running") ||
               productName.contains("miler") ||
               productName.contains("dri-fit") ||
               productName.contains("run ") ||
               (productName.contains("run") && !productName.contains("basketball"))
    
    case "basketball":
        return productName.contains("basketball") ||
               brand.contains("jordan") ||
               productName.contains("jordan")
    
    case "training":
        return productName.contains("training") ||
               productName.contains("pullover") ||
               productName.contains("hoodie") ||
               productName.contains("fleece") ||
               productName.contains("sportswear") ||
               productName.contains("sportswear club")
    
    case "lifestyle":
        let isRunning = productName.contains("running") ||
                       productName.contains("miler") ||
                       productName.contains("dri-fit") ||
                       (productName.contains("run ") && !productName.contains("basketball"))
        let isBasketball = productName.contains("basketball") ||
                          brand.contains("jordan") ||
                          productName.contains("jordan")
        let isTraining = productName.contains("training") ||
                        productName.contains("pullover") ||
                        productName.contains("hoodie") ||
                        productName.contains("fleece") ||
                        productName.contains("sportswear")
        
        return !isRunning && !isBasketball && !isTraining
    
    default:
        return false
    }
}
