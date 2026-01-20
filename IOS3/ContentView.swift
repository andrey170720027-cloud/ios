//
//  ContentView.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var showWelcome = false
    @State private var showShopView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if showShopView {
                    ShopView()
                        .transition(.opacity)
                } else if showWelcome {
                    WelcomeView(showShopView: $showShopView)
                        .transition(.opacity)
                } else {
                    SplashScreenView()
                        .transition(.opacity)
                }
            }
            .onAppear {
                // Показываем экран приветствия через 2 секунды
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showWelcome = true
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
