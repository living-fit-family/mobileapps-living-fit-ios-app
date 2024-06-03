//
//  SessionService.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/10/23.
//

import Foundation
import FirebaseAuth
import FirebaseFunctions
import FirebaseFirestore

struct UserSessionDetails {
    let id: String
    let username: String?
    let photoUrl: String?
}

enum SessionState {
    case loggedIn
    case loggedOut
    case billingError
}

protocol SessionService {
    var state: SessionState { get }
    var user: UserSessionDetails? { get }
    
    func signOut()
}

final class SessionServiceImpl: ObservableObject, SessionService {
    @Published var state: SessionState = .loggedOut
    @Published var user: UserSessionDetails?
    @Published var macros: UserDetail?
    @Published var chartModelData: [ChartModelData] = []
    @Published var channelId: String? = nil
    @Published var unreadChannelCount = 0
    private var pushNotifications = PushNotifications()
    
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        pushNotifications = PushNotifications()
        setupFirebaseAuthHandler()
//        handlePushNotificationResponse()
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
}

private extension SessionServiceImpl {
    func setupFirebaseAuthHandler() {
        handler = Auth.auth().addStateDidChangeListener{ [weak self] res, user in
            guard let self = self else { return }
            if let uid = user?.uid {
                self.handleRefresh(with: uid)
                self.monitorAccountStatus(uid: uid)
            }
        }
    }
    
    func monitorAccountStatus(uid: String) {
        Firestore.firestore()
            .collection("users").document(uid)
            .collection("subscriptions").whereField("status", in: ["trialing", "active"])
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                let subscriptionStatus = documents.map { $0["status"]! }
                print("Current status is: \(subscriptionStatus)")
                if subscriptionStatus.isEmpty {
                    self.state = .billingError
                } else {
                    self.state = Auth.auth().currentUser == nil ?  .loggedOut : .loggedIn
                }
            }
    }
    
    func handleRefresh(with uid: String) {
        let docRef = Firestore.firestore().collection("users").document(uid)
        docRef
            .addSnapshotListener { [weak self] documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                guard let self = self else {
                    return
                }
                
                let username = data["username"] as? String
                let photoUrl = data["photoURL"] as? String
                
                let gender = data["gender"] as? String
                let birthDate = data["birthDate"] as? Timestamp
                let height = data["height"] as? String
                let weight = data["weight"] as? String
                let goal = data["goal"] as? String
                let totalCalories = data["totalCalories"] as? String
                
                var formattedDate: Int64 = 694242000
                if let birthDate = birthDate {
                    formattedDate = birthDate.seconds
                }
                
                DispatchQueue.main.async {
                    
                    self.user = UserSessionDetails(id: document.documentID, username: username, photoUrl: photoUrl)
                    self.macros = UserDetail(
                        gender: Gender(rawValue: gender ?? Gender.female.rawValue)!,
                        birthDate: Date(timeIntervalSince1970: Double(formattedDate)),
                        height: height ?? "157.48",
                        weight: weight ?? "54.4311",
                        goal: Goal(rawValue: goal ?? Goal.lose.rawValue)!,
                        totalCalories: totalCalories ?? "2000")
                    
                    self.chartModelData = []
                    
                    let protein = (Double(totalCalories ?? "2000")! * 0.30 / 4)
                    let proteinData = ChartModelData(color: .red, value: protein, title: "Protein")
                    self.chartModelData.append(proteinData)
                    
                    let fat = (Double(totalCalories ?? "2000")! * 0.30 / 9)
                    let fatData = ChartModelData(color: .green, value: fat, title: "Fat")
                    self.chartModelData.append(fatData)
                    
                    let carbs = (Double(totalCalories ?? "2000")! - (fat * 9)  - (protein * 4)) / 4
                    let carbData = ChartModelData(color: .blue, value: carbs, title: "Carbs")
                    self.chartModelData.append(carbData)
                    
                    let total: CGFloat = self.chartModelData.reduce(0.0) {$0 + $1.value}
                    
                    for i in 0..<self.chartModelData.count {
                        let percentage = (self.chartModelData[i].value / total)
                        self.chartModelData[i].slicePercent = (i == 0 ? 0.0 : self.chartModelData[i - 1].slicePercent) + percentage
                    }
                    
                    self.state = .loggedIn
                }
            }
    }
}

//extension SessionServiceImpl {
//    func handlePushNotificationResponse() {
//            pushNotifications.listenToNotificationsResponse { [weak self] response in
//                guard case UNNotificationDefaultActionIdentifier = response.actionIdentifier else {
//                    return
//                }
////                let action = response.actionIdentifier
//                let request = response.notification.request
//                let userInfo = request.content.userInfo
////                let alertMsg = (userInfo["aps"] as! NSDictionary)["alert"] as! NSDictionary
//                let payload = userInfo["sendbird"] as! NSDictionary
//                let channel = payload["channel"] as! NSDictionary
//                let channelUrl = channel["channel_url"] as! String
//
//                self?.channelId = channelUrl
//
//                let params = GroupChannelTotalUnreadMessageCountParams();
//                params.superChannelFilter = .all
//            }
//        }
//
//    public func updateUnreadChannelCount() {
//        SendbirdChat.getTotalUnreadChannelCount { count, error in
//            guard error == nil else {
//                return // Handle error.
//            }
//            self.unreadChannelCount = Int(count)
//            UIApplication.shared.applicationIconBadgeNumber = Int(count)
//        }
//    }
//}
