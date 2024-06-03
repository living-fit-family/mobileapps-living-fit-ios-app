//
//  AppDelegate.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/1/23.
//

import FirebaseAuth
import FirebaseCore
import FirebaseStorage
import SwiftUI
import StreamChat
import StreamChatSwiftUI
import AVFoundation
import UserNotifications

public let apiKey = "m97ee8d6kdtb"
public let applicationGroupIdentifier = "group.com.livingfitfamily.LivingFitApp"
public let currentUserIdRegisteredForPush = "currentUserIdRegisteredForPush"
public let storage = Storage.storage()

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    
    var streamChat: StreamChat?
    
    var chatClient: ChatClient = {
        var config = ChatClientConfig(apiKey: .init(apiKey))
        config.isLocalStorageEnabled = true
        config.applicationGroupIdentifier = applicationGroupIdentifier
        
        let client = ChatClient(config: config)
        return client
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        StreamRuntimeCheck._isBackgroundMappingEnabled = true
        
        let utils = Utils(
            messageListConfig: MessageListConfig(dateIndicatorPlacement: .messageList)
        )
        
        streamChat = StreamChat(chatClient: chatClient, utils: utils)
        
        do{
            try AVAudioSession.sharedInstance().setCategory(.ambient)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            NSLog(error.localizedDescription)
        }
        return true;
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        guard let currentUserId = chatClient.currentUserId else {
            log.warning("cannot add the device without connecting as user first, did you call connectUser")
            return
        }

        chatClient.currentUserController().addDevice(.apn(token: deviceToken)) { error in
            if let error = error {
                log.error("adding a device failed with an error \(error)")
                return
            }
            UserDefaults(suiteName: applicationGroupIdentifier)?.set(
                currentUserId,
                forKey: currentUserIdRegisteredForPush
            )
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("error" + error.localizedDescription)
    }
    
    func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}
