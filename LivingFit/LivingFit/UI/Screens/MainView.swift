//
//  HomeView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/27/23.
//

import SwiftUI

struct MainView: View {    
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var ModelData: ModelData
    @EnvironmentObject var networkService: NetworkService
    @EnvironmentObject var splitSessionService: SplitSessionServiceImpl
    
    @State private var plan = UUID()
    @State private var nutrition = UUID()
    @State private var profile = UUID()
    @State private var chat = UUID()
    
    @State private var tabSelection = 1
    @State private var tappedTwice = false
    
    @State private var showNetworkAlert = false
    
    var body: some View {
        var handler: Binding<Int> { Binding(
            get: { self.tabSelection },
            set: {
                if $0 == self.tabSelection {
                    tappedTwice = true
                }
                self.tabSelection = $0
            }
        )}
        
        return TabView(selection: handler) {
            CurrentSplitListView()
                .id(plan)
                .onChange(of: tappedTwice, perform: { tappedTwice in
                    guard tappedTwice else { return }
                    plan = UUID()
                    self.tappedTwice = false
                })
                .tag(1)
            NutritionView()
                .id(nutrition)
                .tag(2)
            ProfileView()
                .id(profile)
                .tag(3)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
        .onAppear {
            if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
        .onChange(of: networkService.isConnected) { connection in
            showNetworkAlert = connection == false
        }
        .alert(
            "Network connection is offline.",
            isPresented: $showNetworkAlert
        ){}
            .tint(Color.colorPrimary)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(SessionServiceImpl())
            .environmentObject(SplitSessionServiceImpl(splitSessionRepository: FirebaseSplitSessionRespositoryAdapter()))
            .environmentObject(ModelData())
            .environmentObject(NetworkService())
    }
}
