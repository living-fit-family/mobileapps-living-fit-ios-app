//
//  CustomChannelHeader.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/2/23.
//
import SwiftUI
import StreamChatSwiftUI

public struct CustomChannelHeader: ToolbarContent {

    @Injected(\.fonts) var fonts
    @Injected(\.images) var images

    public var title: String
    public var onTapLeading: () -> ()

    public var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(title)
                .font(fonts.bodyBold)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink {
                Text("This is injected view")
            } label: {
                Image(systemName: "pencil")
                    .resizable()
            }
        }
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                onTapLeading()
            } label: {
                Image(systemName: "chevron.left")
                    .resizable()
            }
        }
    }
}
