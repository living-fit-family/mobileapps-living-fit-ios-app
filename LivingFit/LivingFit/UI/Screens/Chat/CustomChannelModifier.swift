//
//  CustomChannelModifier.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/2/23.
//

import StreamChatSwiftUI
import SwiftUI

struct CustomChannelModifier: ChannelListHeaderViewModifier {

    var title: String

    @State var profileShown = false

    func body(content: Content) -> some View {
        content.toolbar {
            CustomChannelHeader(title: title) {
                profileShown = true
            }
        }
        .sheet(isPresented: $profileShown) {
            Text("Profile View")
        }
    }

}
