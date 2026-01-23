//
//  SearchBarView.swift
//  IOS3
//
//  Переиспользуемый компонент строки поиска
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    @Binding var isSearchActive: Bool
    let placeholder: String
    let onCancel: () -> Void
    
    init(
        searchText: Binding<String>,
        isSearchActive: Binding<Bool>,
        placeholder: String = "Поиск товаров и разделов",
        onCancel: @escaping () -> Void = {}
    ) {
        self._searchText = searchText
        self._isSearchActive = isSearchActive
        self.placeholder = placeholder
        self.onCancel = onCancel
    }
    
    var body: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField(placeholder, text: $searchText)
                    .font(.system(size: 16))
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            Button(action: {
                withAnimation {
                    isSearchActive = false
                    searchText = ""
                    onCancel()
                }
            }) {
                Text("Отмена")
                    .font(.system(size: 16))
                    .foregroundColor(.black)
            }
        }
    }
}
