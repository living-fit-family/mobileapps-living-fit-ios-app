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
import StreamChat
import StreamChatSwiftUI

struct UserSessionDetails {
    let id: String
    let firstName: String
    let lastName: String
    let photoUrl: String? 
}

enum SessionState {
    case loggedIn
    case loggedOut
}

protocol SessionService {
    var state: SessionState { get }
    var user: UserSessionDetails? { get }
    
    func signOut()
}

final class SessionServiceImpl: ObservableObject, SessionService {
    @Injected(\.chatClient) public var chatClient
    
    @Published var state: SessionState = .loggedOut
    @Published var user: UserSessionDetails?
    @Published var macros: UserDetail?
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        setupFirebaseAuthHandler()
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        self.chatClient.connectionController().disconnect()
    }
}

private extension SessionServiceImpl {
    func setupFirebaseAuthHandler() {
        handler = Auth.auth().addStateDidChangeListener{ [weak self] res, user in
            guard let self = self else { return }
            self.state = user == nil ?  .loggedOut : .loggedIn
            if let uid = user?.uid {
                self.handleRefresh(with: uid)
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
                guard let self = self,
                      let firstName = data["firstName"] as? String,
                      let lastName = data["lastName"] as? String else {
                    return
                }
                
                let photoUrl = data["photoURL"] as? String
                
                let gender = data["gender"] as? String
                let birthDate = data["birthDate"] as? Timestamp
                let height = data["height"] as? String
                let weight = data["weight"] as? String
                let goal = data["goal"] as? String
                let totalCalories = data["totalCalories"] as? String
                
                var formattedDate: Int64 = 0
                if let birthDate = birthDate {
                    formattedDate = birthDate.seconds
                }

                DispatchQueue.main.async {
                    
                    self.user = UserSessionDetails(id: document.documentID, firstName: firstName, lastName: lastName, photoUrl: photoUrl)
                    self.macros = UserDetail(
                        gender: Gender(rawValue: gender ?? Gender.female.rawValue)!,
                        birthDate: Date(timeIntervalSince1970: Double(formattedDate)),
                        height: height ?? "120",
                        weight: weight ?? "54.4311",
                        goal: Goal(rawValue: goal ?? Goal.lose.rawValue)!,
                        totalCalories: totalCalories ?? "2000")
                }
                
                lazy var functions = Functions.functions(region: "us-east1")
                
                functions.httpsCallable("ext-auth-chat-getStreamUserToken").call(["uid": uid]) { result, error in
                    if let error = error as NSError? {
                        if error.domain == FunctionsErrorDomain {
                            let code = FunctionsErrorCode(rawValue: error.code)
                            let message = error.localizedDescription
                            let details = error.userInfo[FunctionsErrorDetailsKey]
                        }
                    }
                    if let data = result?.data as? String {
                        self.chatClient.connectUser(
                            userInfo: .init(id: uid,
                                            name: firstName + " " + lastName,
                                            imageURL: URL(string: photoUrl ?? "")),
                            token: try! Token(rawValue: data)
                        ) { error in
                            if let error = error {
                                // Some very basic error handling only logging the error.
                                log.error("connecting the user failed \(error)")
                                return
                            }
                        }
                    }
                }
                
            }
    }
}
