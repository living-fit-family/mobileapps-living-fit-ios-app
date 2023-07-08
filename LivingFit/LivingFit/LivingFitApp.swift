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
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient, options: .mixWithOthers)
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
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
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                switch sessionService.state {
                case .loggedIn:
                    MainView()
                case .loggedOut:
                    ContentView()
                }
            }
            .environmentObject(sessionService)
        }
    }
}
