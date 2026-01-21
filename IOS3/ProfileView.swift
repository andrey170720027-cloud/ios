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
            
            ZStack {
                // Одно изображение, адаптированное под размер экрана
                profileImage(name: "10", ext: "jpg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: screenWidth, height: screenHeight)
                    .clipped()
                
                // Навигационная панель с кнопкой назад
                VStack {
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
                                .padding(8)
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                        }
                        .padding(.leading, 20)
                        .padding(.top, 16)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
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
