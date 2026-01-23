//
//  NavigationHeaderView.swift
//  IOS3
//
//  Переиспользуемый компонент заголовка навигации с поиском
//

import SwiftUI

struct NavigationHeaderView: View {
    let title: String
    @Binding var isSearchActive: Bool
    @Binding var searchText: String
    let onSearchTap: () -> Void
    let onBack: (() -> Void)?
    let showBackButton: Bool
    let rightButtons: [HeaderButton]?
    
    struct HeaderButton {
        let icon: String
        let action: () -> Void
    }
    
    init(
        title: String,
        isSearchActive: Binding<Bool> = .constant(false),
        searchText: Binding<String> = .constant(""),
        onSearchTap: @escaping () -> Void = {},
        onBack: (() -> Void)? = nil,
        showBackButton: Bool = false,
        rightButtons: [HeaderButton]? = nil
    ) {
        self.title = title
        self._isSearchActive = isSearchActive
        self._searchText = searchText
        self.onSearchTap = onSearchTap
        self.onBack = onBack
        self.showBackButton = showBackButton
        self.rightButtons = rightButtons
    }
    
    var body: some View {
        if isSearchActive {
            HStack(spacing: 12) {
                if showBackButton {
                    Button(action: {
                        onBack?()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                    }
                }
                
                SearchBarView(
                    searchText: $searchText,
                    isSearchActive: $isSearchActive,
                    onCancel: {}
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 16)
        } else {
            HStack {
                if showBackButton {
                    Button(action: {
                        onBack?()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                    }
                }
                
                Spacer()
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Spacer()
                
                HStack(spacing: 16) {
                    if let rightButtons = rightButtons {
                        ForEach(0..<rightButtons.count, id: \.self) { index in
                            Button(action: rightButtons[index].action) {
                                Image(systemName: rightButtons[index].icon)
                                    .font(.system(size: 18))
                                    .foregroundColor(.black)
                            }
                        }
                    } else {
                        Button(action: onSearchTap) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 16)
        }
    }
}
