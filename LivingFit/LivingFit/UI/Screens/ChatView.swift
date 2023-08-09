//
//  ChatView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/7/23.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

struct ChatView: View {
    var body: some View {
        ChatChannelListView(viewFactory: CustomFactory.shared, title: "Family Chat", embedInNavigationView: true)
            .tabItem {
                Label("Chat", systemImage: "message")
            }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
