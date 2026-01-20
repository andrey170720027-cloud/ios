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
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 20))
                            .foregroundColor(selectedTab == tab ? .black : .gray)
                        
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
