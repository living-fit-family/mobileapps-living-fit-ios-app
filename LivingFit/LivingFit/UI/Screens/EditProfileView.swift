//
//  EditProfileView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/3/23.
//

import SwiftUI
import PopupView

enum UnitOfMeasure: String, CaseIterable, Identifiable {
    var id: Self {
        return self
    }
    
    case imperial
    case metric
}

enum Goal: String, CaseIterable, Identifiable {
    var id: Self {
        return self
    }
    case lose
    case gain
    case maintain
}

struct EditProfileView: View {
    @EnvironmentObject private var sessionService: SessionServiceImpl
    @State private var showingSourceOptions = false
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var isPresenting = false
    
    @State private var showUploadingProgress = false
    @State private var showUploadingError = false
    
    
    
    @State private var height = "125 cm"
    @State private var weight = "72 kg"
    
    @State private var age: String = ""
    @State private var gender = Gender.female
    @State private var feetValue = 1
    @State private var inchesValue = 5
    @State private var date = Date()
    @State private var system = ["imperial", "metric"]
    @State private var selectedSystem = UnitOfMeasure.imperial
    @State private var value = 0.0
    
    @State private var showDatePicker: Bool = false
    @State private var showFitnessGoalPicker: Bool = false
    
    @State var currentDate = Date()
    @State var newDate = Date()
    
    @State var currentGoal = Goal.lose
    @State var newGoal = Goal.lose
    
    @State var showingAlert: Bool = false
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    init(){
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color(hex: "#55C856"))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    
    private func getFormattedDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let month = dateFormatter.string(from: currentDate)
        return ("\(month) \(currentDate.get(.day)) \(currentDate.get(.year))")
        
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        VStack(alignment: .center) {
                            ProfileImageView(showingOptions: $showingSourceOptions, imageUrl: URL(string: sessionService.user?.photoURL ?? ""), enableEditMode: true)
                                .overlay {
                                    if (showUploadingProgress) {
                                        ProgressView()
                                    }
                                }
                                
                            HStack(alignment: .lastTextBaseline) {
                                Text(sessionService.user?.firstName ?? "Living")
                                Text(sessionService.user?.lastName ?? "Fit User")
                                Button(action: {}) {
                                    Image(systemName: "square.and.pencil")
                                        .foregroundColor(.green)
                                }
                            }
                            .font(.title2)
                            .fontWeight(.bold)
                        }
                        .padding(.vertical)
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        Picker("Inches", selection: $selectedSystem) {
                            ForEach(UnitOfMeasure.allCases) { option in
                                Text("\(option.rawValue.capitalized)")
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        LabeledContent {
                            Text(height)
                                .foregroundColor(Color(hex: "55C856"))
                                .font(.title3)
                                .fontWeight(.semibold)
                        } label: {
                            Text("Height")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }.onTapGesture {
                            showingAlert.toggle()
                        }
                        
                        
                        LabeledContent {
                            Text(weight)
                                .foregroundColor(Color(hex: "55C856"))
                                .font(.title3)
                                .fontWeight(.semibold)
                        } label: {
                            Text("Weight")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        
                        LabeledContent {
                            Picker("", selection: $gender) {
                                ForEach(Gender.allCases) { option in
                                    Text("\(option.rawValue.capitalized)")
                                        .foregroundColor(.green)
                                }
                            }
                            .pickerStyle(.segmented)
                            .fixedSize()
                        } label: {
                            Text("Gender")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        
                        LabeledContent {
                            Text("\(getFormattedDateString())")
                                .foregroundColor(Color(hex: "55C856"))
                                .font(.title3)
                                .fontWeight(.semibold)
                        } label: {
                            Text("Date of Birth")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }.onTapGesture {
                            self.showDatePicker.toggle()
                        }
                        
                        LabeledContent {
                            Text(currentGoal.rawValue.capitalized + " " + "weight")
                                .foregroundColor(Color(hex: "55C856"))
                                .font(.title3)
                                .fontWeight(.semibold)
                        } label: {
                            Text("Fitness Goal")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .onTapGesture {
                            self.showFitnessGoalPicker.toggle()
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .scrollDisabled(true)
                .environment(\.defaultMinListRowHeight, 50)
                .navigationTitle("My Profile")
                .background(Color.white)
                .scrollContentBackground(.hidden)
            }
            .confirmationDialog("Edit Profile Picture", isPresented: $showingSourceOptions, titleVisibility: .visible) {
                Button("Choose from library") {
                    sourceType = .photoLibrary
                    showImagePicker.toggle()
                }
                Button("Take photo") {
                    sourceType = .camera
                    showImagePicker.toggle()
                }
            }
            .sheet(isPresented: $showImagePicker) {
                // Pick an image from the photo library:
                ImagePicker(sourceType: sourceType) { image in
                    if let user = sessionService.user {
                        showUploadingProgress.toggle()
                        sessionService.updatePhotoUrl(userId: user.id, image: image) {
                            showUploadingProgress.toggle()
                        } onFailure: { error in
                            showUploadingError.toggle()
                        }
                    }
                }
                .background(.black)
            }
            .alert(isPresented: $showUploadingError) {
                Alert(title: Text("Oh No!"), message: Text("We were unable to upload your photo. Please try again."), dismissButton: .default(Text("Close")))
            }
            .sheet(isPresented: $showDatePicker) {
                VStack {
                    HStack {
                        Button(action: {
                            self.showDatePicker.toggle()
                        }) {
                            Text("CANCEL")
                        }
                        Spacer()
                        Button(action: {
                            self.currentDate = self.newDate
                            self.showDatePicker.toggle()
                        }) {
                            Text("SET")
                        }
                    }.padding([.top, .horizontal])
                    DatePicker("Date", selection: $newDate, displayedComponents: [.date])
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .presentationDetents([.fraction(0.30)])
                        .interactiveDismissDisabled()
                }
            }
            .sheet(isPresented: $showFitnessGoalPicker) {
                VStack {
                    HStack {
                        Button(action: {
                            self.showFitnessGoalPicker.toggle()
                        }) {
                            Text("CANCEL")
                        }
                        Spacer()
                        Button(action: {
                            self.currentGoal = self.newGoal
                            self.showFitnessGoalPicker.toggle()
                        }) {
                            Text("SET")
                        }
                    }.padding([.top, .horizontal])
                    Picker("Goal", selection: $newGoal) {
                        ForEach(Goal.allCases) { option in
                            Text("\(option.rawValue.capitalized) weight")
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                    .presentationDetents([.fraction(0.30)])
                    .interactiveDismissDisabled()
                }
            }
        }
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}



struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
            .environmentObject(SessionServiceImpl())
    }
}
