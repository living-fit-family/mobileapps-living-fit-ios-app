//
//  LivingFitApp.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/8/23.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI
import AVFAudio
import FirebaseFunctions

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
    
    @Injected(\.chatClient) var chatClient
    
    func connectUser(withCredentials credentials: UserSessionDetails) {
        lazy var functions = Functions.functions()
        
        functions.httpsCallable("ext-auth-chat-getStreamUserToken").call() { result, error in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    
                    log.error("failed to retrieve stream user token \(String(describing: code)) \(message)")
                }
                return
            }
            if let data = result?.data as? String {
                chatClient.connectUser(
                    userInfo: .init(id: credentials.id, name: credentials.username, imageURL: URL(string: credentials.photoUrl ?? "")),
                    token: try! Token(rawValue: data)
                ) { error in
                    if let error = error {
                        log.error("connecting the user failed \(error)")
                        return
                    }
                }
            }
        }
    }
    
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
                if let user = sessionService.user {
                    connectUser(withCredentials: user)
                    pushNotifications.registerForPushNotifications()
                }
            }
        }
    }
}


