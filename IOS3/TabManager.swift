//
//  TabManager.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI
import Combine

class TabManager: ObservableObject {
    static let shared = TabManager()
    
    @Published var selectedTab: TabItem = .shop
    
    private init() {}
}
