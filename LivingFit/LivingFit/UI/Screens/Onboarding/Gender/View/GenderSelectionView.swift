//
//  GenderSelectionView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/4/23.
//

import SwiftUI

enum Gender {
    case male
    case female
    
    var data: (id: String, name: String) {
        switch self {
        case .male:
            return ("0", "male")
        case .female:
            return ("1", "female")
        }
    }
}

struct GenderSelectionView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var selectedId: String = ""
    @State private var isAnimated = false
    @State private var maleAnimated = false
    
    let male = Gender.male.data
    let female = Gender.female.data
    
    func handleRadioButtonSelected(id: String) -> Void {
        //        HapticsManager.shared.selectionVibrate()
        DispatchQueue.main.async { self.selectedId = id }
    }
    
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }) {
        HStack {
            Image(systemName: "chevron.left")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .foregroundColor(.black)
        }
    }
    }
    
    var body: some View {
        VStack {
            VStack {
                Text("What's your gender?")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .padding()
                HStack(alignment: .center) {
                    Text("🚨")
                        .font(.title)
                    Text("This will help us accurately calculate your recommended daily macros and adapt to your personal plan.")
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(.gray)
                }
                .padding()
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.gray, lineWidth: 0.2)
                })
            }
            Spacer()
            VStack(spacing: 30) {
                RadioButton(id: male.id,
                            label: male.name , symbol: male.name,
                            isSelected: selectedId == male.id ? true : false,
                            callback: handleRadioButtonSelected)
                RadioButton(id: female.id,
                            label: female.name,
                            symbol: female.name,
                            isSelected: selectedId == female.id ? true : false,
                            callback: handleRadioButtonSelected)
            }
            Spacer()
            VStack {
                NavigationLink(destination: EmptyView()) {
                    Text("Continue")
                        .frame(maxWidth: .infinity, maxHeight: 56)
                        .background(.green)
                        .foregroundColor(.white)
                        .font(.title3)
                        .fontWeight(.medium)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.clear, lineWidth: 2))
                        .shadow(color: Color(hex: "55C856", alpha: 0.25), radius: 8, x: 0, y: 4)
                }
            }
            .padding([.leading, .trailing], 5)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .padding()
    }
}

struct GenderSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GenderSelectionView()
        }
    }
}
