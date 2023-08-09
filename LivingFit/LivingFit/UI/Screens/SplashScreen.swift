//
//  SplashScreen.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/6/23.
//

import SwiftUI

struct SplashScreen: View {
    @State private var scale = 0.7
    @Binding var isActive: Bool
    
    var body: some View {
        VStack {
            VStack {
                Image("full-logo")
                    .foregroundColor(.blue)
            }
            .scaleEffect(scale)
            .onAppear{
                withAnimation(.easeIn(duration: 0.7)) {
                    self.scale = 0.9
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen(isActive: .constant(true))
    }
}
