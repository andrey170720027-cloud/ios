//
//  EmptyStateView.swift
//  IOS3
//
//  Компонент для отображения пустых состояний
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String?
    
    init(icon: String, title: String, message: String? = nil) {
        self.icon = icon
        self.title = title
        self.message = message
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.gray)
            
            if let message = message {
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(.gray.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
