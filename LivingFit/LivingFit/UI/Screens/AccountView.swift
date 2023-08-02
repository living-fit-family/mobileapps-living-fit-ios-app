//
//  AccountView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/22/23.
//

import SwiftUI

struct TaskRow: View {
    var text: String
    var image: String
    var body: some View {
        HStack {
            Image(systemName: image)
            Text(text)
        }
    }
}

struct AccountView: View {
    @EnvironmentObject private var sessionService: SessionServiceImpl
    @State private var allowNotifications = false
    @State private var showingOptions = false
    @State private var isPresenting = false
    @State private var showSheet = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    func getUserFullName() -> String {
        if let firstName = sessionService.user?.firstName, let lastName = sessionService.user?.lastName {
            return firstName + " " + lastName
        } else {
            return "Living Fit User"
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack(spacing: 24) {
                        ZStack(alignment: .bottomTrailing) {
                            Image(uiImage: sessionService.image)
                                .resizable()
                                .scaledToFill()
                                .background(
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(Color(UIColor.systemGray5)))
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                                .background(Color(hex: "55C856"))
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .onTapGesture {
                                    showingOptions = true
                                }
                                .confirmationDialog("Edit Profile Picture", isPresented: $showingOptions, titleVisibility: .visible) {
                                    Button("Choose from library") {
                                        sourceType = .photoLibrary
                                        showSheet.toggle()
                                    }
                                    Button("Take photo") {
                                        sourceType = .camera
                                        showSheet.toggle()
                                    }
                                }
                                .sheet(isPresented: $showSheet) {
                                    // Pick an image from the photo library:
                                    ImagePicker(sourceType: sourceType, selectedImage: $sessionService.image).background(.black)
                                }
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(getUserFullName())
                                .font(.title2)
                            Text("Muscle Gain & Weight Loss")
                        }
                    }
                    VStack(alignment: .leading) {
                        NavigationLink(destination: EmptyView()) {
                            HStack(spacing: 24) {
                                VStack {
                                    Text("5' 2\"")
                                        .foregroundColor(Color(hex: "55C856"))
                                        .font(.headline)
                                    Text("Height")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                                }
                                VStack {
                                    Text("120 lbs")
                                        .foregroundColor(Color(hex: "55C856"))
                                        .font(.headline)
                                    Text("Weight")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                                }
                                VStack {
                                    Text("27 yo")
                                        .foregroundColor(Color(hex: "55C856"))
                                        .font(.headline)
                                    Text("Age")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                                }
                            }
                        }
                    }
                }
                .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                    return 0
                }
                
                Section(header: Text("Account")) {
                    TaskRow(text: "Settings", image: "gear")
                    TaskRow(text: "Security", image: "checkmark.shield")
                    TaskRow(text: "Notifications", image: "bell")
                }
                
                Section(header: Text("Legal")) {
                    TaskRow(text: "Terms of Service", image: "doc.text")
                }
                
                Section(header: Text("Other")) {
                    TaskRow(text: "Sign Out", image: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.red)
                        .onTapGesture {
                            self.isPresenting.toggle()
                        }.alert(isPresented: $isPresenting) {
                            Alert(title: Text("Sign out of your account?"),
                                  primaryButton: .destructive(Text("Sign Out")) {sessionService.signOut()},
                                  secondaryButton: .cancel()
                            )
                        }
                }
                
            }
            .navigationTitle("Profile")
        }
        .tabItem {
            Label("Account", systemImage: "person.crop.circle.fill")
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AccountView()
                .environmentObject(SessionServiceImpl())
        }
    }
}
