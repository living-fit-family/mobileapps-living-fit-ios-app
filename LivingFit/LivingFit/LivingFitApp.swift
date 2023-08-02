//
//  LivingFitApp.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/8/23.
//

import SwiftUI
import AVFAudio

@main
struct LivingFitApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var bannerService = BannerService()
    @StateObject var sessionService = SessionServiceImpl()
    @StateObject var splitSessionService = SplitSessionServiceImpl(splitSessionRepository: FirebaseSplitSessionRespositoryAdapter())
    @StateObject var modelData: ModelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                switch sessionService.state {
                case .loggedIn:
                    MainView()
                    if let type = bannerService.bannerType {
                        BannerView(banner: type)
                    }
                case .loggedOut:
                    ContentView()
                }
            }
            .environmentObject(bannerService)
            .environmentObject(sessionService)
            .environmentObject(splitSessionService)
            .environmentObject(modelData)
        }
    }
}

class AppState: ObservableObject {
    
    @Published var userState: UserState = .launchAnimation
    
    static let shared = AppState()
    
    private init() {}
}

enum UserState {
    case launchAnimation
    case notLoggedIn
    case loggedIn
}


