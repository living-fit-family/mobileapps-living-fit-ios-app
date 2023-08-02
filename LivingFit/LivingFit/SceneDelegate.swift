//
//  SceneDelegate.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/1/23.
//

import SwiftUI

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    func sceneWillResignActive(_ scene: UIScene) {
        if NotificationsHandler.shared.notificationChannelId != nil {
            NotificationsHandler.shared.notificationChannelId = nil
        }
    }
}
