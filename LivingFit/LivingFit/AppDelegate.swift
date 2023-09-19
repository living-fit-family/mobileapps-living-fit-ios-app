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
import SendbirdUIKit
import SendbirdChatSDK
import AVFoundation

public let storage = Storage.storage()

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        // Configure and initialize Sendbird
        SBUColorSet.primary300 = UIColor(Color(hex:"#55C856"))
        // 1. Initialize Sendbird UIKit
        SendbirdUI.initialize(applicationId: "C06DAD42-4096-430C-85F6-C722B76AD51F") { // This is the origin.
            // Initialization of SendbirdUIKit has started.
            // Show a loading indicator.
        } migrationHandler: {
            // DB migration has started.
        } completionHandler: { error in
            // If DB migration is successful, proceed to the next step.
            // If DB migration fails, an error exists.
            // Hide the loading indicator.
        }
        do{
           try AVAudioSession.sharedInstance().setCategory(.ambient)
           try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
           NSLog(error.localizedDescription)
        }
        return true;
    }
    
    func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        return true
    }
}
