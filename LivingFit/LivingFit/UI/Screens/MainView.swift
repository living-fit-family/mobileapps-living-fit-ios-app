//
//  HomeView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/27/23.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

enum Tabs: String {
    case plan
    case nutrition
    case chat
    case account
}

struct MainView: View {
    @State private var selectedTab = Tabs.plan
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var ModelData: ModelData
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CurrentSplitListView()
                .tag(Tabs.plan)
            NutritionView()
                .tag(Tabs.nutrition)
//            ChatChannelListScreen(title: "Family Chat")
//                .badge(5)
//                .tabItem {
//                    Label("Chat", systemImage: "message")
//                }
//                .tag(Tabs.chat)
            AccountView()
                .tag(Tabs.account)
        }
        .tint(.colorPrimary)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(SessionServiceImpl())
            .environmentObject(SplitSessionServiceImpl(splitSessionRepository: FirebaseSplitSessionRespositoryAdapter()))
            .environmentObject(ModelData())
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
        
        
        MainView()
            .environmentObject(SessionServiceImpl())
            .environmentObject(SplitSessionServiceImpl(splitSessionRepository: FirebaseSplitSessionRespositoryAdapter()))
            .environmentObject(ModelData())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
    }
}
