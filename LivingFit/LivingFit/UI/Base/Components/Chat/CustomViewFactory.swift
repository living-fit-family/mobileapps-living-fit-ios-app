//
//  CustomViewFactory.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/1/24.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

class CustomViewFactory: ViewFactory {
    
    @Injected(\.chatClient) public var chatClient
    
    private init() {}
    
    public static let shared = CustomViewFactory()
    
    func makeChannelListHeaderViewModifier(title: String) -> some ChannelListHeaderViewModifier {
        CustomChannelModifier(title: title)
    }
    
}
