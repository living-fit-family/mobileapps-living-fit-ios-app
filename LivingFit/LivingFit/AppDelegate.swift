//
//  AppDelegate.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/1/23.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI
import FirebaseCore
import FirebaseAuth

public let apiKeyString = "fgvrz577wzb8"
public let applicationGroupIdentifier = "group.com.livingfitfamily.LivingFit"
public let currentUserIdRegisteredForPush = "currentUserIdRegisteredForPush"

class AppDelegate: NSObject, UIApplicationDelegate {
    var streamChat: StreamChat?

    var chatClient: ChatClient = {
        var config = ChatClientConfig(apiKey: .init(apiKeyString))
        config.isLocalStorageEnabled = true
//        config.applicationGroupIdentifier = applicationGroupIdentifier

        let client = ChatClient(config: config)
        return client
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        // Set up Chat Client
        var colors = ColorPalette()
        colors.tintColor = Color(hex: "#55C856")

        var fonts = Fonts()
        fonts.footnoteBold = Font.footnote

        let images = Images()
        images.reactionLoveBig = UIImage(systemName: "heart.fill")!

        let appearance = Appearance(colors: colors, images: images, fonts: fonts)

        let channelNamer: ChatChannelNamer = { channel, currentUserId in
            "\(channel.name ?? "N/A")"
        }
        let utils = Utils(channelNamer: channelNamer)

        let streamChat = StreamChat(chatClient: chatClient, appearance: appearance, utils: utils)

        
        connectUser()

        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//            withAnimation {
//                if AppState.shared.userState == .launchAnimation {
//                    AppState.shared.userState = .notLoggedIn
//                }
//            }
//        }

        UNUserNotificationCenter.current().delegate = NotificationsHandler.shared
        
        return true;
    }
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
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
    
    private func connectUser() {
            /*This hardcoded token is valid only on the Stream's tutorial environment. The chat client connects the user to the backend with the hard-coded token.
             */
            // In production, when the user logs in, the app will load the token from the user's back-end. Because this will be a dynamic parameter in a real-world situation.
            // Since we are certain that the token must contain a value, we use the try keyword with !, to force unwrap the value.
            let token = try! Token(rawValue:  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYWxleGFuZGVyX2NsZW9uaSJ9.L9U5iIQjiZHzg6sg-5BOCC7TicVu31mqZwAOjcyNF14")
            
            // Use the chat client to connect the user. This gets the user ID, name and avatar
            chatClient.connectUser(
                userInfo: .init(id: "alexander_cleoni",
                                name: "Alexander Cleoni",
                                imageURL: URL(string: "https://vignette.wikia.nocookie.net/starwars/images/2/20/LukeTLJ.jpg")!),
                token: token
                
            ) { error in
                if let error = error {
                    // Some very basic error handling only logging the error.
                    log.error("connecting the user failed \(error)")
                    return
                }
            }
        }
}
