//
//  ProfileView.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI
import UIKit

struct ProfileView: View {
    @ObservedObject private var tabManager = TabManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            ZStack {
                // Одно изображение, адаптированное под размер экрана
                loadImageFromBundle(name: "10", ext: "jpg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: screenWidth, height: screenHeight)
                    .clipped()
                
                // Навигационная панель с кнопкой назад
                VStack(spacing: 0) {
                    // Навигационная панель
                    HStack {
                        Button(action: {
                            // Переключаем на Home при нажатии назад
                            withAnimation {
                                tabManager.selectedTab = .home
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                    .background(Color.white)
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
    }
}


#Preview {
    NavigationView {
        ProfileView()
    }
}
