//
//  CartQuantityControl.swift
//  IOS3
//
//  Переиспользуемый компонент для управления количеством товара в корзине
//

import SwiftUI

struct CartQuantityControl: View {
    let quantity: Int
    let onDecrease: () -> Void
    let onIncrease: () -> Void
    let onRemove: () -> Void
    let showRemoveButton: Bool
    
    init(
        quantity: Int,
        onDecrease: @escaping () -> Void,
        onIncrease: @escaping () -> Void,
        onRemove: @escaping () -> Void,
        showRemoveButton: Bool = true
    ) {
        self.quantity = quantity
        self.onDecrease = onDecrease
        self.onIncrease = onIncrease
        self.onRemove = onRemove
        self.showRemoveButton = showRemoveButton
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Кнопка уменьшения
            Button(action: {
                if quantity > 1 {
                    onDecrease()
                } else {
                    onRemove()
                }
            }) {
                Image(systemName: "minus.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.gray)
            }
            
            // Количество
            Text("\(quantity)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .frame(minWidth: 30)
            
            // Кнопка увеличения
            Button(action: {
                onIncrease()
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.black)
            }
            
            if showRemoveButton {
                Spacer()
                
                // Кнопка удаления
                Button(action: {
                    onRemove()
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 18))
                        .foregroundColor(.red)
                }
            }
        }
    }
}
