//
//  PreviewModifier.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/9/23.
//

import SwiftUI

struct PreviewModifier: ViewModifier {
    let displayName: String
    
    func body(content: Content) -> some View {
        content
            .previewLayout(.sizeThatFits)
            .previewDisplayName(displayName)
            .padding()
    }
}

extension View {
    func preview(with displayName: String) -> some View {
        self.modifier(PreviewModifier(displayName: displayName))
    }
}
