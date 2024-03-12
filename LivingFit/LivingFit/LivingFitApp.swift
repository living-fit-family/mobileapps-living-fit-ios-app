//
//  LivingFitApp.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/8/23.
//

import SwiftUI
import SendbirdChatSDK
import AVFAudio

@main
struct LivingFitApp: App {
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var bannerService = BannerService()
    @StateObject var sessionService = SessionServiceImpl()
    @StateObject var splitSessionService = SplitSessionServiceImpl(splitSessionRepository: FirebaseSplitSessionRespositoryAdapter())
    @StateObject var modelData: ModelData = ModelData()
    @StateObject var networkService = NetworkService()
    @ObservedObject var pushNotifications = PushNotifications()
    
    var body: some Scene {
        WindowGroup {
            ViewCoordinator()
                .environmentObject(bannerService)
                .environmentObject(sessionService)
                .environmentObject(splitSessionService)
                .environmentObject(modelData)
                .environmentObject(networkService)
        }
        .onChange(of: sessionService.state) { newValue in
            if newValue == .loggedIn {
                if let id = sessionService.user?.id {
                    SendbirdChat.connect(userId: id, completionHandler: { (user, error) in
                        if error == nil {
                            print("User with id \(id) successfully connected to Sendbird server.")
                        }
                    })
                    pushNotifications.registerForPushNotifications()
                }
            }
        }
    }
}


