//
//  LivingFitApp.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/8/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import AVFAudio

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        return true;
    }
    
    func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        return true
    }
}

@main
struct LivingFitApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var sessionService = SessionServiceImpl()
    @StateObject var splitSessionService = SplitSessionServiceImpl(splitSessionRepository: FirebaseSplitSessionRespositoryAdapter())
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        
    }
    
    var body: some Scene {
        WindowGroup {
            switch sessionService.state {
            case .loggedIn:
                MainView()
                    .environmentObject(sessionService)
                    .environmentObject(splitSessionService)
            case .loggedOut:
                ContentView()
            }
        }
    }
}
