//
//  CustomChannelHeader.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/1/24.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

public struct CustomChannelHeader: ToolbarContent {
    @Injected(\.fonts) var fonts
    @Injected(\.images) var images
    
    var title: String
    var currentUserController: CurrentChatUserController
    @Binding var isNewChatShown: Bool
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(title)
                .font(fonts.bodyBold)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                isNewChatShown = true
            } label: {
                Image(systemName: "square.and.pencil")
                    .resizable()
            }
        }
    }
}
