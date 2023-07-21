//
//  HomeView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/27/23.
//

import SwiftUI

enum Tabs: String {
    case home
    case nutrition
    case chat
    case account
}

struct MainView: View {
    @State private var selectedTab = Tabs.home
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CurrentSplitListView()
                .tabItem {
                    Label("Plan", systemImage: "calendar")
                }
                .tag(Tabs.home)
            NutritionView()
                .tabItem {
                    Label("Nutrition", systemImage: "chart.pie")
                }
                .tag(Tabs.nutrition)
            Text("Chat")
                .badge(5)
                .tabItem {
                    Label("Chat", systemImage: "message")
                }
                .tag(Tabs.chat)
            Text("Account")
                .badge("!")
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                }
                .tag(Tabs.account)
        }
        .tint(Color(hex: "#313131"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(action: { sessionService.signOut()}) {
                    Image(systemName: "bell")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .fontWeight(.light)
                        .foregroundColor(Color(hex: "#313131"))
                }
                
            }
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MainView()
                .environmentObject(SessionServiceImpl())
                .environmentObject(SplitSessionServiceImpl(splitSessionRepository: FirebaseSplitSessionRespositoryAdapter()))
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
        
        NavigationStack {
            MainView()
                .environmentObject(SessionServiceImpl())
                .environmentObject(SplitSessionServiceImpl(splitSessionRepository: FirebaseSplitSessionRespositoryAdapter()))
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
