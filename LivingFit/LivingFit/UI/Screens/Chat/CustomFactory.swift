//
//  CustomFactory.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/2/23.
//

import StreamChatSwiftUI
import StreamChat
import SwiftUI

class CustomFactory: ViewFactory {
    @Injected(\.chatClient) public var chatClient
    
    private init() {}
    
    public static let shared = CustomFactory()
    
    func makeChannelListHeaderViewModifier(title: String) -> some ChannelListHeaderViewModifier {
        CustomChannelModifier(title: title)
    }
    
    func makeMessageAvatarView(for userDisplayInfo: UserDisplayInfo) -> some View {
        CustomUserAvatar(userDisplayInfo: userDisplayInfo)
    }
}
