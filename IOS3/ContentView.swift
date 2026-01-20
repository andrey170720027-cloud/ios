//
//  ContentView.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var showWelcome = false
    
    var body: some View {
        ZStack {
            if showWelcome {
                WelcomeView()
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

#Preview {
    ContentView()
}
