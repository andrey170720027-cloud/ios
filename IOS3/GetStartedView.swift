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
        if let uiImage = UIImage(named: "5") {
            return Image(uiImage: uiImage)
        }
        if let path = Bundle.main.path(forResource: "5", ofType: "png", inDirectory: "images"),
           let uiImage = UIImage(contentsOfFile: path) {
            return Image(uiImage: uiImage)
        }
        return Image(systemName: "photo")
    }
}

#Preview {
    GetStartedView(showShopView: .constant(false))
}
