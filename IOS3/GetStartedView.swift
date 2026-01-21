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
                Image("5")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Кнопка "Get Started"
                Button(action: {
                    showShopView = true
                }) {
                    Text("Get Started")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.white)
                        .cornerRadius(28)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    GetStartedView(showShopView: .constant(false))
}
