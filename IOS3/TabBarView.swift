//
//  TabBarView.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI

enum TabItem: String, CaseIterable {
    case home = "Home"
    case shop = "Shop"
    case favorites = "Favorites"
    case bag = "Bag"
    case profile = "Profile"
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .shop:
            return "magnifyingglass"
        case .favorites:
            return "heart"
        case .bag:
            return "bag"
        case .profile:
            return "person"
        }
    }
}

struct TabBarView: View {
    @Binding var selectedTab: TabItem
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                Button(action: {
                    // Если переключаем на другую вкладку
                    if selectedTab != tab {
                        // Пытаемся вернуться на главный экран при переключении вкладок
                        // (работает только если мы в дочернем view, на корневом экране ничего не произойдет)
                        withAnimation {
                            dismiss()
                        }
                    }
                    // Переключаем вкладку в глобальном менеджере
                    withAnimation {
                        selectedTab = tab
                    }
                }) {
                    ZStack {
                        VStack(spacing: 4) {
                            ZStack {
                                Image(systemName: tab.icon)
                                    .font(.system(size: 20))
                                    .foregroundColor(selectedTab == tab ? .black : .gray)
                                
                                // Красная точка на иконке Profile
                                if tab == .profile {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 6, height: 6)
                                        .offset(x: 8, y: -8)
                                }
                            }
                            
                            Text(tab.rawValue)
                                .font(.system(size: 12))
                                .foregroundColor(selectedTab == tab ? .black : .gray)
                            
                            if selectedTab == tab {
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: 20, height: 2)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .frame(height: 60)
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.3)),
            alignment: .top
        )
    }
}

#Preview {
    TabBarView(selectedTab: .constant(.shop))
        .previewLayout(.sizeThatFits)
}
