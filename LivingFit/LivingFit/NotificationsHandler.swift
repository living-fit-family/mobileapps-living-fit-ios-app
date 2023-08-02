//
//  NotificationsHandler.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/1/23.
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

class NotificationsHandler: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    @Injected(\.chatClient) private var chatClient
    
    @Published var notificationChannelId: String?
        
    static let shared = NotificationsHandler()
    
    override private init() {}
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        defer {
            completionHandler()
        }
        
        guard let notificationInfo = try? ChatPushNotificationInfo(content: response.notification.request.content) else {
            return
        }
        
        guard let cid = notificationInfo.cid else {
            return
        }
        
        guard case UNNotificationDefaultActionIdentifier = response.actionIdentifier else {
            return
        }
        
        if AppState.shared.userState == .loggedIn {
            notificationChannelId = cid.description
        } else if let userId = UserDefaults(suiteName: applicationGroupIdentifier)?.string(forKey: currentUserIdRegisteredForPush),
//                  let userCredentials = sessionService.user.builtInUsersByID(id: userId),
                  let token = try? Token(rawValue: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYWxleGFuZGVyX2NsZW9uaSJ9.S_E37f8qhVO73xXFf_VYcNU1kSngwPlYoFu_-n8wnFs") {
            loginAndNavigateToChannel(
                //                userCredentials: userCredentials,
                token: token,
                cid: cid
            )
        }
    }
    
    func setupRemoteNotifications() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
    }
    
    private func loginAndNavigateToChannel(
        //        userCredentials: UserCredentials,
        token: Token,
        cid: ChannelId
    ) {
        let userInfo: UserInfo = .init(
            id: "alexander_cleoni",
            name: "Alexander Cleoni"
//            imageURL: userCredentials.avatarURL
        )
        chatClient.connectUser(userInfo: userInfo, token: token) { [weak self] error in
            if error != nil {
                log.debug("Error logging in")
                return
            }
            
            DispatchQueue.main.async {
                AppState.shared.userState = .loggedIn
                self?.notificationChannelId = cid.description
            }
        }
    }
}
