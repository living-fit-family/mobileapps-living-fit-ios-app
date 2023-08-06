//
//  HomeView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/27/23.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

enum ContentViewTab {
    case plan
    case nutrition
    case account
}

enum PlanNavDestination {
    case workoutEdit
    case workoutList
}

enum AccountNavDestination {
    case editProfile
}


class AppState: ObservableObject {
    @Published var selectedTab: ContentViewTab = .plan
    @Published var planNavigation: [PlanNavDestination] = []
    @Published var accountNavigation: [AccountNavDestination] = []
}

struct MainView: View {
    @Injected(\.chatClient) public var chatClient
    @StateObject var appState = AppState()
    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var ModelData: ModelData
    
    @State var showingDetail = false
    @State var selectedIndex:Int = 0
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            CurrentSplitListView()
                .tag(ContentViewTab.plan)
            NutritionView()
                .tag(ContentViewTab.nutrition)
            AccountView()
                .tag(ContentViewTab.account)
        }
        .tint(.colorPrimary)
        .environmentObject(appState)
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(SessionServiceImpl())
            .environmentObject(SplitSessionServiceImpl(splitSessionRepository: FirebaseSplitSessionRespositoryAdapter()))
            .environmentObject(ModelData())
    }
}
