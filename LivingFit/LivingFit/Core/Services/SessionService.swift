//
//  SessionService.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/10/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import StreamChat
import StreamChatSwiftUI

struct UserSessionDetails {
    let id: String
    let firstName: String
    let lastName: String
    var photoURL: String
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
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        setupFirebaseAuthHandler()
    }
    
    func updatePhotoUrl(userId: String, image: UIImage, onComplete: @escaping () -> (Void)?, onFailure: @escaping (Error) -> (Void)?) {
        let tempUrl = self.user?.photoURL
        self.user?.photoURL = ""
        
        let storageRef = storage.reference()
        
        // Create a reference to 'images/mountains.jpg'
        let userIdImagesRef = storageRef.child("\(userId)/profileImage.png")
        
        // Data in memory
        let data = image.pngData()
        
        // Upload the file to the path "images/rivers.jpg"
        if let data = data {
            userIdImagesRef.putData(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    if let error = error {
                        self.user?.photoURL = tempUrl ?? ""
                        onFailure(error)
                    }
                    return
                }
                // You can also access to download URL after upload.
                userIdImagesRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        if let error = error {
                            self.user?.photoURL = tempUrl ?? ""
                            onFailure(error)
                        }
                        return
                    }
                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.photoURL = downloadURL
                    changeRequest?.commitChanges()
                    
                    Firestore.firestore()
                        .collection("users").document(userId).updateData(["photoURL": downloadURL.absoluteString]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                                self.user?.photoURL = tempUrl ?? ""
                                onFailure(err)
                            } else {
                                print("Document successfully written!")
                                onComplete()
                            }
                        }
                }
            }
        }
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
                
                DispatchQueue.main.async {
                    self.user = UserSessionDetails(id: document.documentID, firstName: firstName, lastName: lastName, photoURL: photoUrl ?? "")
                    
                    let token = try! Token(rawValue: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYkoyZVRVRk1QOVVaUmNiT0pZenJsb0JCaXVkMiJ9.tXQl-DHUDIeyudZTQh0uTETbOrnaTJ8njojAYKsqmJ8")

                    // Call `connectUser` on our SDK to get started.
                    self.chatClient.connectUser(
                        userInfo: .init(id: uid,
                                        name: firstName + " " + lastName,
                                        imageURL: Auth.auth().currentUser?.photoURL),
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
    }
}
