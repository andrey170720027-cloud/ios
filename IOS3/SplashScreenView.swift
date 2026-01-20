//
//  SplashScreenView.swift
//  IOS3
//
//  Created by krupchakd on 20.01.2026.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            // Черный фон
            Color.black
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Логотип Nike по центру
                Image("1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 300, maxHeight: 300)
                
                Spacer()
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
