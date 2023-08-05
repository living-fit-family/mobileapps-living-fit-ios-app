//
//  CustomChannelHeader.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/2/23.
//
import SwiftUI
import StreamChat
import StreamChatSwiftUI

public struct CustomChannelListHeader: ToolbarContent {
    @Injected(\.fonts) var fonts
    
    public var title: String
    public var currentUserController: CurrentChatUserController
    
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
