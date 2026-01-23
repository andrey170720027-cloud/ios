//
//  ImageLoader.swift
//  IOS3
//
//  Утилита для загрузки изображений из bundle
//

import SwiftUI
import UIKit

/// Загружает изображение из bundle по имени и расширению
/// - Parameters:
///   - name: Имя файла без расширения
///   - ext: Расширение файла (png, jpg, jpeg)
/// - Returns: Image из bundle или fallback изображение
func loadImageFromBundle(name: String, ext: String) -> Image {
    let extensionsToTry: [String] = {
        let normalized = ext.lowercased()
        if normalized.isEmpty { return ["png", "jpg", "jpeg"] }
        if normalized == "jpeg" { return ["jpeg", "jpg"] }
        if normalized == "jpg" { return ["jpg", "jpeg"] }
        return [normalized]
    }()
    
    let subdirectoriesToTry: [String?] = ["images", nil]
    
    // Пробуем найти в поддиректориях
    for subdirectory in subdirectoriesToTry {
        for candidateExt in extensionsToTry {
            if let url = Bundle.main.url(forResource: name, withExtension: candidateExt, subdirectory: subdirectory),
               let uiImage = UIImage(contentsOfFile: url.path) {
                return Image(uiImage: uiImage)
            }
        }
    }
    
    // Пробуем найти как "<name>.<ext>" в bundle
    for candidateExt in extensionsToTry {
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

/// Переиспользуемый компонент для отображения изображений товаров
/// Поддерживает как URL изображения, так и локальные изображения
struct ProductImageView: View {
    let imageURL: String?
    let imageName: String?
    let width: CGFloat?
    let height: CGFloat
    let contentMode: ContentMode
    
    init(
        imageURL: String? = nil,
        imageName: String? = nil,
        width: CGFloat? = nil,
        height: CGFloat = 200,
        contentMode: ContentMode = .fill
    ) {
        self.imageURL = imageURL
        self.imageName = imageName
        self.width = width
        self.height = height
        self.contentMode = contentMode
    }
    
    var body: some View {
        Group {
            if let imageURL = imageURL, !imageURL.isEmpty, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: width, height: height)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: contentMode)
                    case .failure:
                        fallbackImage
                    @unknown default:
                        EmptyView()
                    }
                }
            } else if let imageName = imageName, !imageName.isEmpty {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                fallbackImage
            }
        }
        .frame(width: width, height: height)
        .clipped()
    }
    
    private var fallbackImage: some View {
        Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.gray)
            .frame(width: width, height: height)
    }
}
