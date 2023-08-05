//
//  AccountView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/22/23.
//

import SwiftUI
import Kingfisher

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
    @State private var isPresentingLogoutAction: Bool = false
    
    func getUserFullName() -> String {
        if let firstName = sessionService.user?.firstName, let lastName = sessionService.user?.lastName {
            return firstName + " " + lastName
        } else {
            return "Living Fit User"
        }
    }
    
    func getHeight() -> String? {
        return nil
    }
    
    func getWeight() -> String? {
        return nil
    }
    
    func getAge() -> String? {
        return nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack(spacing: 24) {

                        VStack(alignment: .leading, spacing: 4) {
                            Text(getUserFullName())
                                .font(.title2)
                            Text("Muscle Gain & Weight Loss")
                        }
                    }
                    VStack(alignment: .leading) {
                        NavigationLink(destination: EditProfileView()) {
                            HStack(spacing: 24) {
                                VStack {
                                    Text(getHeight() ?? "--")
                                        .foregroundColor(Color(hex: "55C856"))
                                        .font(.headline)
                                    Text("Height")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                                }
                                VStack {
                                    Text(getWeight() ?? "--")
                                        .foregroundColor(Color(hex: "55C856"))
                                        .font(.headline)
                                    Text("Weight")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                                }
                                VStack {
                                    Text(getAge() ?? "--")
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
                            self.isPresentingLogoutAction.toggle()
                        }.alert(isPresented: $isPresentingLogoutAction) {
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
