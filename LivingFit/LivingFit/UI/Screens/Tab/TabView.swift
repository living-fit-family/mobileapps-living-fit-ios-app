//
//  TabView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/10/23.
//

import SwiftUI

enum Tab: String {
    case home = "Home"
    case search = "Nutrition"
    case message = "Family Chat"
    case user = "Profile"
    
    var image: String {
        switch self {
        case .home: return "home"
        case .search: return "meal"
        case .message: return "message"
        case .user: return "person"
        }
    }
}

struct TabView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    @State var selected: Tab = .home
    @State var showMenu = false
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                switch selected {
                case .home:
                    HomeView()
                case .search:
                    Text(Tab.search.rawValue)
                case .message:
                    Text(Tab.message.rawValue)
                case .user:
                    Text(Tab.user.rawValue)
                }
                Spacer()
                ZStack {
                    HStack {
                        TabItemView(selected: $selected, tab: .home, width: proxy.size.width / 5, height: proxy.size.height / 28)
                        TabItemView(selected: $selected, tab: .search, width: proxy.size.width/5, height: proxy.size.height/28)
                        
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: proxy.size.width/7, height: proxy.size.width/7)
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: proxy.size.width/7-6 , height: proxy.size.width/7-6)
                                .foregroundColor(.green)

                        }
                        .offset(y: -proxy.size.height / 8 / 2)
                        
                        
                        TabItemView(selected: $selected, tab: .message, width: proxy.size.width/5, height: proxy.size.height/28)
                        TabItemView(selected: $selected, tab: .user, width: proxy.size.width/5, height: proxy.size.height/28)
                        
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height / 8)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem {
                Button(action: {
                    sessionService.signOut()
                }, label: {
                    Text("Sign Out")
                        .foregroundColor(.red)
                })

            }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TabView()
                .environmentObject(SessionServiceImpl())
        }
    }
}

