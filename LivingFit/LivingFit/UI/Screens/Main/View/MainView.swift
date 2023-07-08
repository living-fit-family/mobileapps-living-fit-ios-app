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
    @EnvironmentObject var sessionService: SessionServiceImpl
    @State private var selectedTab = Tabs.home
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if selectedTab == Tabs.home {
                    VStack(alignment: .leading) {
                        Text("Hello, Taylor 👋")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "#313131"))
                        Text("Today is July 2, 2023")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .fontWeight(.light)
                    }
                }
                if selectedTab == Tabs.nutrition {
                    Text("Nutrition")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#313131"))
                }
            }
            .padding([.horizontal, .top])
            TabView(selection: $selectedTab) {
                MyPlanView()
                    .tabItem {
                        Label("My Plan", systemImage: "calendar")
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
                    Button(action: sessionService.signOut) {
                        Image(systemName: "bell")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .fontWeight(.light)
                            .foregroundColor(Color(hex: "#313131"))
                    }
                    
                }
                ToolbarItem(placement: .confirmationAction) {
                    Image("profile")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .clipShape(Circle())
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
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
        
        NavigationStack {
            MainView()
                .environmentObject(SessionServiceImpl())
        }
        .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
