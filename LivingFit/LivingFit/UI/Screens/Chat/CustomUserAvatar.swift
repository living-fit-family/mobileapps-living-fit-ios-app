//
//  CustomUserAvatar.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/2/23.
//

import NukeUI
import Nuke
import StreamChatSwiftUI
import StreamChat
import SwiftUI


struct CustomUserAvatar: View {
    @State var showSheet = false
    
    var userDisplayInfo: UserDisplayInfo
    
    public var body: some View {
        ZStack {
            Button(action: {
                showSheet = true
            }) {
                if let url = userDisplayInfo.imageURL {
                    LazyImage(url: url)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .frame(width: 40, height: 40)
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
            }
            .sheet(isPresented: $showSheet) {
                if let url = userDisplayInfo.imageURL {
                    LazyImage(url: url)
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                }
                Text(userDisplayInfo.name)
                    .presentationDetents([.height(300), .medium, .large])
                    .presentationDragIndicator(.automatic)
                    .font(.title).bold()
                
                HStack {
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "person.badge.plus.fill")
                            Text("Add to group")
                        }
                        .padding(8)
                        .font(.caption)
                        .controlSize(.small)
                        .frame(width: 120)
                        .foregroundColor(.black)
                        .background(.thinMaterial)
                        .cornerRadius(8)
                    }
//                    .buttonStyle(.plain)
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Image(systemName: "message.fill")
                            Text("Send a DM")
                        }
                        .padding(8)
                        .font(.caption)
                        .controlSize(.small)
                        .frame(width: 120)
                        .foregroundColor(.black)
                        .background(.thinMaterial)
                        .cornerRadius(8)
                    }
//                    .buttonStyle(.plain)
                }.padding()
                
            }
        }
    }
    
}
