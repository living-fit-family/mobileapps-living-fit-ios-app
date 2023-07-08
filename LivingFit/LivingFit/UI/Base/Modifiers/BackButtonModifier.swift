//
//  BackButtonModifier.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/28/23.
//

import Foundation
import SwiftUI

extension View {
    
    func navigationBarBackButtonTitleHidden() -> some View {
        self.modifier(NavigationBarBackButtonTitleHiddenModifier())
    }
}

struct NavigationBarBackButtonTitleHiddenModifier: ViewModifier {
    
    @Environment(\.dismiss) var dismiss
    
    @ViewBuilder @MainActor func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.green)
                    .imageScale(.large)
                    .fontWeight(.semibold)
                })
            .contentShape(Rectangle()) // Start of the gesture to dismiss the navigation
            .gesture(
                DragGesture(coordinateSpace: .local)
                    .onEnded { value in
                        if value.translation.width > .zero
                            && value.translation.height > -30
                            && value.translation.height < 30 {
                            dismiss()
                        }
                    }
            )
    }
}

