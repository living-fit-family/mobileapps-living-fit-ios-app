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
    @StateObject var networkService = NetworkService()
    
    var body: some Scene {
        WindowGroup {
            ViewCoordinator()
                .environmentObject(bannerService)
                .environmentObject(sessionService)
                .environmentObject(splitSessionService)
                .environmentObject(modelData)
                .environmentObject(networkService)
        }
    }
}


