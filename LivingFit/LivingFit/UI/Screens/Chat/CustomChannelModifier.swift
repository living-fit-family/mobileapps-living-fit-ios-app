//
//  CustomChannelModifier.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/2/23.
//

import StreamChatSwiftUI
import SwiftUI

struct CustomChannelModifier: ChannelListHeaderViewModifier {
    
    @Injected(\.chatClient) var chatClient
    
    var title: String
    
    @State var isNewChatShown = false
    @State var logoutAlertShown = false
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .toolbar(.hidden, for: .tabBar)
                .toolbar {
                    CustomChannelListHeader(
                        title: title,
                        currentUserController: chatClient.currentUserController(),
                        isNewChatShown: $isNewChatShown
                    )
                }
                .navigationDestination(isPresented: $isNewChatShown) {
                    CreateGroupView(isNewChatShown: $isNewChatShown)
                }
        }
    }
}

