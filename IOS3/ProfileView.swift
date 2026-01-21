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
            let screenHeight = geometry.size.height
            let isSmallScreen = screenWidth < 375
            let isLargeScreen = screenWidth > 414
            
            // Адаптивные размеры
            let titleFontSize: CGFloat = isSmallScreen ? 28 : (isLargeScreen ? 36 : 32)
            
            // Точные отступы
            let horizontalPadding: CGFloat = 20
            let topPadding: CGFloat = 16
            
            // Размер ячейки сетки изображений (половина ширины экрана)
            let imageCellSize = screenWidth / 2
            
            ZStack {
                VStack(spacing: 0) {
                    // Навигационная панель
                    HStack {
                        Button(action: {
                            // Переключаем на Home при нажатии назад
                            withAnimation {
                                selectedTab = .home
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, topPadding)
                    .padding(.bottom, 16)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            // Сетка изображений 2x2 без промежутков
                            LazyVGrid(columns: [
                                GridItem(.fixed(imageCellSize), spacing: 0),
                                GridItem(.fixed(imageCellSize), spacing: 0)
                            ], spacing: 0) {
                                // Верхнее левое изображение
                                profileImage(name: "10", ext: "jpg")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: imageCellSize, height: imageCellSize)
                                    .clipped()
                                
                                // Верхнее правое изображение
                                profileImage(name: "11", ext: "jpg")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: imageCellSize, height: imageCellSize)
                                    .clipped()
                                
                                // Нижнее левое изображение
                                profileImage(name: "12", ext: "png")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: imageCellSize, height: imageCellSize)
                                    .clipped()
                                
                                // Нижнее правое изображение
                                profileImage(name: "13", ext: "jpg")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: imageCellSize, height: imageCellSize)
                                    .clipped()
                            }
                            
                            // Заголовок под сеткой
                            HStack {
                                Text("Welcome to the Nike App")
                                    .font(.system(size: titleFontSize, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Spacer()
                            }
                            .padding(.horizontal, horizontalPadding)
                            .padding(.top, 24)
                            .padding(.bottom, 80) // Отступ для TabBar
                        }
                    }
                    
                    Spacer()
                }
                .background(Color.white)
            }
        }
        .navigationBarHidden(true)
    }
}

// Вспомогательная функция для загрузки изображений из bundle
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

#Preview {
    NavigationView {
        ProfileView(selectedTab: .constant(.profile))
    }
}
