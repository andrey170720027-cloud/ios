//
//  ProfileView.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI
import UIKit

struct ProfileView: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let isSmallScreen = screenWidth < 375
            let isLargeScreen = screenWidth > 414
            
            // Адаптивные размеры
            let titleFontSize: CGFloat = isSmallScreen ? 28 : (isLargeScreen ? 32 : 30)
            let welcomeFontSize: CGFloat = isSmallScreen ? 24 : (isLargeScreen ? 32 : 28)
            
            // Размеры изображений для сетки 2x2
            let horizontalPadding: CGFloat = 20
            let spacing: CGFloat = 12
            let availableWidth = screenWidth - 2 * horizontalPadding - spacing
            let imageSize = availableWidth / 2
            
            ZStack {
                VStack(spacing: 0) {
                    // Верхняя панель с кнопкой "назад"
                    HStack {
                        Button(action: {
                            // Переход на главную вкладку
                            selectedTab = .home
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                    
                    // Основной контент
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 24) {
                            // Сетка 2x2 изображений
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: spacing),
                                GridItem(.flexible(), spacing: spacing)
                            ], spacing: spacing) {
                                // Верхнее левое изображение
                                profileImage(name: "11", ext: "jpg")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: imageSize, height: imageSize)
                                    .clipped()
                                
                                // Верхнее правое изображение
                                profileImage(name: "12", ext: "png")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: imageSize, height: imageSize)
                                    .clipped()
                                
                                // Нижнее левое изображение
                                profileImage(name: "13", ext: "jpg")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: imageSize, height: imageSize)
                                    .clipped()
                                
                                // Нижнее правое изображение
                                profileImage(name: "14", ext: "png")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: imageSize, height: imageSize)
                                    .clipped()
                            }
                            .padding(.horizontal, horizontalPadding)
                            
                            // Текст "Welcome to the Nike App"
                            Text("Welcome to the Nike App")
                                .font(.system(size: welcomeFontSize, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, horizontalPadding)
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 80) // Отступ для TabBar
                    }
                    
                    Spacer()
                }
                .background(Color.white)
            }
        }
        .navigationBarHidden(true)
    }
    
    // Helper функция для загрузки изображений
    private func profileImage(name: String, ext: String) -> Image {
        let extsToTry: [String] = {
            let normalized = ext.lowercased()
            if normalized.isEmpty { return ["png", "jpg", "jpeg"] }
            if normalized == "jpeg" { return ["jpeg", "jpg"] }
            if normalized == "jpg" { return ["jpg", "jpeg"] }
            return [normalized]
        }()
        
        let subdirsToTry: [String?] = ["images", nil]
        
        // Пробуем найти в поддиректориях
        for subdir in subdirsToTry {
            for candidateExt in extsToTry {
                if let url = Bundle.main.url(forResource: name, withExtension: candidateExt, subdirectory: subdir),
                   let uiImage = UIImage(contentsOfFile: url.path) {
                    return Image(uiImage: uiImage)
                }
            }
        }
        
        // Пробуем найти как "<name>.<ext>" в bundle
        for candidateExt in extsToTry {
            if let uiImage = UIImage(named: "\(name).\(candidateExt)") {
                return Image(uiImage: uiImage)
            }
        }
        
        // Пробуем найти просто по имени
        if let uiImage = UIImage(named: name) {
            return Image(uiImage: uiImage)
        }
        
        // Fallback
        return Image(systemName: "photo")
    }
}

#Preview {
    ProfileView(selectedTab: .constant(.profile))
}
