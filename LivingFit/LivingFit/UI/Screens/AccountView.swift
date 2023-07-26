//
//  AccountView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/22/23.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject private var sessionService: SessionServiceImpl
    @State private var allowNotifications = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 20) {
                    ZStack(alignment: .bottomTrailing) {
                        Image("profile")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .frame(width: 25, height: 25)
                            .background(Color.green)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Shayla Ross")
                            .font(.title2)
                            .fontWeight(.bold)
                        VStack(alignment: .leading) {
                            
                            VStack(alignment: .leading) {
                                Text("Muscle Gain & Weight Loss")
                                    .font(.headline)
                                    .fontWeight(.regular)
                                    .foregroundColor(Color(hex: "3A4750"))
//                                    .foregroundColor(.colorPrimary)
                                //                                .fontWeight(.semibold)
                            }
                            .padding(.bottom)
                        }
                    }
                }
                HStack(spacing: 24) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(maxWidth: .infinity, maxHeight: 90)
                            .background(.white)
                            .cornerRadius(16)
                        VStack {
                            Text("5' 3\"")
                                .foregroundColor(.colorPrimary)
                                .font(.headline)
                            Text("Height")
                                .foregroundColor(Color(hex: "3A4750"))
                                .font(.subheadline)
                        }
                    }
                    .frame(width: 95, height: 65)
                    .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.10), radius: 4, x: 0, y: 3)
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(maxWidth: .infinity, maxHeight: 90)
                            .background(.white)
                            .cornerRadius(16)
                        VStack {
                            Text("130 lbs")
                                .foregroundColor(.colorPrimary)
                                .font(.headline)
                            Text("Weight")
                                .foregroundColor(Color(hex: "3A4750"))
                                .font(.subheadline)
                        }
                    }
                    .frame(width: 95, height: 65)
                    .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.10), radius: 4, x: 0, y: 3)
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(maxWidth: .infinity, maxHeight: 90)
                            .background(.white)
                            .cornerRadius(16)
                        VStack {
                            Text("27 yo")
                                .foregroundColor(.colorPrimary)
                                .font(.headline)
                            Text("Age")
                                .foregroundColor(Color(hex: "3A4750"))
                                .font(.subheadline)
                        }
                    }
                    .frame(width: 95, height: 65)
                    .shadow(color: Color(red: 0.2, green: 0.2, blue: 0.28).opacity(0.10), radius: 4, x: 0, y: 3)
                }
                VStack(alignment: .leading, spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Account")
                            .font(.headline)
                        HStack {
                            Image(systemName: "gear")
                            Text("Settings")
                                .fontWeight(.regular)
                        }
                        HStack {
                            Image(systemName: "checkmark.shield")
                            Text("Security")
                            //                            .fontWeight(.regular)
                        }
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Log Out")
                                .fontWeight(.regular)
                                .onTapGesture {
                                    sessionService.signOut()
                                }
                        }
                        .foregroundColor(.red)
                    }
                    
                    Text("Notifications")
                        .font(.headline)
                    HStack(alignment: .center) {
                        Image(systemName: "bell")
                        Toggle("Allow Notifications", isOn: $allowNotifications)
                            .frame(width: 300, height: 15)
                    }
                    
                    Text("Other")
                        .font(.headline)
                    HStack {
                        Image(systemName: "doc.text")
                        Text("Terms of Service")
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        HStack {
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            Text("Profile")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
            Spacer()
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
