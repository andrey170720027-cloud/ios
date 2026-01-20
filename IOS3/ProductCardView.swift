//
//  ProductCardView.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI

struct ProductCardView: View {
    let product: Product
    @State private var isFavorite: Bool
    
    init(product: Product) {
        self.product = product
        self._isFavorite = State(initialValue: product.isFavorite)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Изображение товара
            ZStack(alignment: .topTrailing) {
                Image(product.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(8)
                
                // Иконка избранного
                Button(action: {
                    isFavorite.toggle()
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 18))
                        .foregroundColor(isFavorite ? .red : .black)
                        .padding(8)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                }
                .padding(8)
            }
            
            // Статус товара
            if let status = product.status {
                Text(statusText(status))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(statusColor(status))
                    .padding(.top, 4)
            }
            
            // Название товара
            Text(product.name)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.black)
            
            // Описание
            Text(product.description)
                .font(.system(size: 12))
                .foregroundColor(.gray)
            
            // Количество цветов
            Text("\(product.colors) Colours")
                .font(.system(size: 11))
                .foregroundColor(.gray)
            
            // Цена
            Text(product.price)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black)
                .padding(.top, 2)
        }
    }
    
    private func statusText(_ status: Product.ProductStatus) -> String {
        switch status {
        case .soldOut:
            return "Sold Out"
        case .bestseller:
            return "Bestseller"
        }
    }
    
    private func statusColor(_ status: Product.ProductStatus) -> Color {
        switch status {
        case .soldOut:
            return .orange
        case .bestseller:
            return .orange
        }
    }
}

#Preview {
    ProductCardView(product: Product.sampleProducts[0])
        .frame(width: 180)
        .padding()
}
