//
//  HomeView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/27/23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl

    var body: some View {
        TabView {
            MyPlanView()
                .tabItem {
                    Label("My Plan", systemImage: "calendar")
                }
            Text("Nutrition")
                .tabItem {
                    Label("Nutrition", systemImage: "chart.pie")
                }
            Text("Chat")
                .badge(5)
                .tabItem {
                    Label("Chat", systemImage: "message")
                }
            Text("Account")
                .badge("!")
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                }
        }
        .accentColor(Color(hex: "5655C8"))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Image("profile")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                    
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(action: sessionService.signOut) {
                    Image(systemName: "bell")
                        .resizable()
                        .frame(width: 20, height: 20)
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
    }
}
