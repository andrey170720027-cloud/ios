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
            GeometryReader { geometry in
                Image("image3")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
            .ignoresSafeArea()
            
            // Черный градиент сверху и снизу до середины экрана
            VStack(spacing: 0) {
                LinearGradient(
                    colors: [Color.black.opacity(0.8), Color.clear],
                    startPoint: .top,
                    endPoint: .center
                )
                LinearGradient(
                    colors: [Color.clear, Color.black.opacity(0.8)],
                    startPoint: .center,
                    endPoint: .bottom
                )
            }
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                    .frame(height: 300)
            
                // Логотип Nike (прижат к левой границе экрана)
                HStack(spacing: 0) {
                    Image("nike-logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 150)
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 0)
                
                // Надпись Nike App и описание
                VStack(alignment: .leading, spacing: 70) {
                    // Заголовок Nike App
                    Text("Nike App")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Описание (размером как Nike App)
                    Text("Bringing Nike Members the best products, inspiration and stories in sport.")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(2)
                }
                .padding(.horizontal, 24)
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
                .padding(.bottom, 100)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
