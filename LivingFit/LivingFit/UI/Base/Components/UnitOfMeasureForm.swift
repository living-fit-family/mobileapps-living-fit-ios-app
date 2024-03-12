//
//  UnitOfMeasureForm.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/6/23.
//

import SwiftUI
import Combine

enum Measure: String {
    case height
    case weight
    case na
}

enum Field: Hashable {
    case ft
    case inches
    case weight
}

struct UnitOfMeasureForm: View {
    @State private var keyboardHeight: CGFloat = 0
    @Binding var feet: String
    @Binding var inches: String
    @Binding var weight: String
    
    @State var tempFeet: String = ""
    @State var tempInches: String = ""
    @State var tempWeight: String = ""
    
    @Binding var showingUnitOfMeasureForm: Bool
    
    @FocusState private var focusedField: Field?
    
    var measurement: Measure? = nil
    
    var commitChanges: () -> ()
    
    @ViewBuilder func getHeightBuilder() -> some View {
        HStack {
            VStack {
                HStack {
                    VStack {
                        TextField("", text: $tempFeet)
                            .focused($focusedField, equals: .ft)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .multilineTextAlignment(.center)
                            .onChange(of: self.tempFeet, perform: {
                                let txt = $0.filter("012345678".contains)
                                if let num = Int(txt), num <= 10, txt.count <= 1 {
                                    tempFeet = txt
                                } else {
                                    tempFeet = String(txt.dropLast())
                                }
                                
                            })
                        Divider()
                            .frame(width: 30)
                            .padding(.horizontal, 30)
                            .background(Color.black)
                            .opacity(0.5)
                    }
                    Text("ft")
                        .font(.title)
                        .fontWeight(.black)
                }
                .frame(width: 160)
                .onTapGesture {
                    self.focusedField = .ft
                }
                .onAppear {
                    tempFeet = feet
                    self.focusedField = .ft
                }
            }
            VStack {
                HStack {
                    VStack {
                        TextField("", text: $tempInches)
                            .focused($focusedField, equals: .inches)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .multilineTextAlignment(.center)
                            .onChange(of: self.tempInches, perform: {
                                let txt = $0.filter("0123456789".contains)
                                if let num = Int(txt), num <= 11, txt.count <= 2 {
                                    tempInches = txt
                                } else {
                                    tempInches = String(txt.dropLast())
                                }
                                
                            })
                        Divider()
                            .frame(width: 30)
                            .padding(.horizontal, 30)
                            .background(Color.black)
                            .opacity(0.5)
                    }
                    Text("in")
                        .font(.title)
                        .fontWeight(.black)
                }
                .frame(width: 160)
                .onTapGesture {
                    self.focusedField = .inches
                }
                .onAppear {
                    tempInches = inches
                }
            }
        }
    }
    
    @ViewBuilder func getWeightBuilder() -> some View {
        HStack {
            VStack {
                HStack {
                    VStack {
                        TextField("", text: $tempWeight)
                            .focused($focusedField, equals: .weight)
                            .keyboardType(.numberPad)
                            .frame(width: 70)
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .multilineTextAlignment(.center)
                            .onChange(of: self.tempWeight, perform: {
                                let txt = $0.filter("0123456789".contains)
                                if let num = Int(txt), num <= 1000, txt.count <= 4 {
                                    tempWeight = txt
                                } else {
                                    tempWeight = String(txt.dropLast())
                                }
                                
                            })
                        Divider()
                            .frame(width: 120)
                            .padding(.horizontal, 30)
                            .background(Color.black)
                            .opacity(0.5)
                    }
                    .padding(.leading, 20)
                    Text("lb")
                        .font(.title)
                        .fontWeight(.black)
                }
                .frame(width: 320)
                .onTapGesture {
                    self.focusedField = .weight
                }
                .onAppear {
                    tempWeight = weight
                    self.focusedField = .weight
                }
            }
        }
    }
    
    private static let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .frame(width: 350, height: 350)
                .shadow(radius: 10)
            VStack {
                Spacer()
                Text(measurement?.rawValue.capitalized ?? "")
                    .font(.title)
                    .fontWeight(.black)
                Spacer()
                if measurement == .height {
                    getHeightBuilder()
                } else if measurement == .weight {
                    getWeightBuilder()
                }
                Spacer()
                ButtonView(title: "Save") {
                    if tempFeet != "" {
                        feet = tempFeet
                    }
                    if tempInches != "" {
                        inches = tempInches
                    }
                    if tempWeight != "" {
                        weight = tempWeight
                    }
                    self.showingUnitOfMeasureForm = false
                    self.commitChanges()
                }
                .frame(width: 300)
                Spacer()
            }
            .padding()
            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                if let textField = obj.object as? UITextField {
                    textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                }
            }
            Button(action: {
                self.showingUnitOfMeasureForm = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.gray)
                    .padding()
            }
        }
        .frame(width: 350, height: 350)
    }
}

struct UnitOfMeasureForm_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UnitOfMeasureForm(feet: .constant(""), inches: .constant(""), weight: .constant(""), showingUnitOfMeasureForm: .constant(true), measurement: .height) {
                
            }
            UnitOfMeasureForm(feet: .constant(""), inches: .constant(""), weight: .constant(""), showingUnitOfMeasureForm: .constant(true), measurement: .weight) {
                
            }
        }
    }
}

