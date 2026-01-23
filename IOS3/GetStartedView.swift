//
//  GetStartedView.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI

struct GetStartedView: View {
    @Binding var showShopView: Bool
    
    var body: some View {
        ZStack {
            // Фоновое изображение
            GeometryReader { geometry in
                backgroundImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Невидимая кнопка поверх изображения
                Button(action: {
                    showShopView = true
                }) {
                    Color.clear
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .contentShape(RoundedRectangle(cornerRadius: 28))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
                .padding(.bottom, 50)
                .accessibilityLabel("Get Started")
            }
        }
    }

    private var backgroundImage: Image {
        loadImageFromBundle(name: "5", ext: "png")
    }
}

#Preview {
    GetStartedView(showShopView: .constant(false))
}
