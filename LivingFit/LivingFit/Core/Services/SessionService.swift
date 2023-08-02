//
//  SessionService.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/10/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct UserSessionDetails {
    let id: String
    let firstName: String
    let lastName: String
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
    @Published var state: SessionState = .loggedOut
    @Published var user: UserSessionDetails?
    @Published var image = UIImage()
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        setupFirebaseAuthHandler()
    }
    
    func signOut() {
        try? Auth.auth().signOut()
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
                DispatchQueue.main.async {
                    self.user = UserSessionDetails(id: document.documentID, firstName: firstName, lastName: lastName)
                }
            }
    }
}
