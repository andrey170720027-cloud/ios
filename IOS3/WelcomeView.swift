//
//  WelcomeView.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI

// Простой swoosh логотип Nike
struct NikeSwoosh: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY),
            control1: CGPoint(x: rect.width * 0.3, y: rect.midY),
            control2: CGPoint(x: rect.width * 0.7, y: rect.minY)
        )
        path.addCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY),
            control1: CGPoint(x: rect.maxX, y: rect.midY),
            control2: CGPoint(x: rect.maxX, y: rect.maxY)
        )
        path.addLine(to: CGPoint(x: rect.width * 0.4, y: rect.maxY))
        path.addCurve(
            to: CGPoint(x: rect.minX, y: rect.midY),
            control1: CGPoint(x: rect.width * 0.2, y: rect.maxY),
            control2: CGPoint(x: rect.minX, y: rect.midY)
        )
        path.closeSubpath()
        return path
    }
}

struct WelcomeView: View {
    var body: some View {
        ZStack {
            // Фоновое изображение
            Image("2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            // Затемнение для лучшей читаемости текста
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Логотип Nike и текст
                VStack(alignment: .leading, spacing: 20) {
                    // Логотип Nike (swoosh)
                    NikeSwoosh()
                        .fill(Color.white)
                        .frame(width: 50, height: 20)
                    
                    // Заголовок
                    Text("Nike App")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Описание
                    Text("Bringing Nike Members the best products, inspiration and stories in sport.")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(4)
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
