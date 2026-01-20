//
//  WelcomeView.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            // Фоновое изображение (женщина в спортивной одежде)
            Image("image3")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .clipped()
            
            // Затемнение для лучшей читаемости текста
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Логотип Nike и текст
                VStack(alignment: .leading, spacing: 16) {
                    // Логотип Nike (swoosh)
                    Image("nike-logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 300, height: 150)
                    
                    // Заголовок
                    Text("Nike App")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Описание
                    Text("Bringing Nike Members the best products, inspiration and stories in sport.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(2)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                // Кнопки (горизонтально)
                HStack(spacing: 12) {
                    // Кнопка "Join Us" (левая, белая)
                    Button(action: {
                        // Действие для Join Us
                    }) {
                        Text("Join Us")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.white)
                            .cornerRadius(28)
                    }
                    
                    // Кнопка "Sign In" (правая, с обводкой и прозрачным черным фоном)
                    Button(action: {
                        // Действие для Sign In
                    }) {
                        Text("Sign In")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.black.opacity(0.3))
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .cornerRadius(28)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
