//
//  AppDelegate.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/1/23.
//

import FirebaseAuth
import FirebaseCore
import FirebaseStorage
import StreamChat
import StreamChatSwiftUI
import SwiftUI


public let apiKeyString = "ga5xsb49d57n"
public let applicationGroupIdentifier = "group.com.livingfitfamily.LivingFitApp"
public let currentUserIdRegisteredForPush = "currentUserIdRegisteredForPush"
public let storage = Storage.storage()

class AppDelegate: NSObject, UIApplicationDelegate {
    var streamChat: StreamChat?

    var chatClient: ChatClient = {
        var config = ChatClientConfig(apiKey: .init(apiKeyString))
        config.isLocalStorageEnabled = true
        config.applicationGroupIdentifier = applicationGroupIdentifier

        let client = ChatClient(config: config)
        return client
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()

        let channelNamer: ChatChannelNamer = { channel, currentUserId in
            "\(channel.name ?? "N/A")"
        }
        let utils = Utils(channelNamer: channelNamer)

        streamChat = StreamChat(chatClient: chatClient, utils: utils)

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
    
    func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        return true
    }
}
