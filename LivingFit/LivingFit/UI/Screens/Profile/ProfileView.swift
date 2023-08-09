//
//  EditProfileView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/3/23.
//

import SwiftUI
import Combine
import PopupView

struct ProfileView: View {
    @EnvironmentObject private var sessionService: SessionServiceImpl
    @StateObject var vm =  ProfileViewModel()
    
    @State private var showingSourceOptions = false
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var feet = "0"
    @State private var inches = "0"
    @State private var weight = "0"
    
    @State private var isPresenting = false
    
    @State private var showUploadingProgress = false
    @State private var showUploadingError = false
    
    @State private var showingUnitOfMeasureForm = false
    @State private var measurement: Measure = .na
    
    @State private var showDatePicker: Bool = false
    @State private var showFitnessGoalPicker: Bool = false
    
    @State private var newBirthDate = Date()
    
    @State private var currentGoal: Goal = .lose
    @State private var newGoal: Goal = .lose
    
    @State private var isPresentingEditName: Bool = false
    
    @State private var isPresentingLogoutAction: Bool = false
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color(hex: "#55C856"))
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    
    private func injectUserVariables() async -> Void {
        if let id = sessionService.user?.id,
           let firstName = sessionService.user?.firstName,
           let lastName = sessionService.user?.lastName {
            vm.id = id
            vm.firstName = firstName
            vm.lastName = lastName
        }
        if let macros = sessionService.macros {
            vm.gender = macros.gender
            vm.birthDate = macros.birthDate
            vm.height = macros.height
            vm.weight = macros.weight
            vm.goal = macros.goal
            vm.dailyCalories = macros.totalCalories
            
            newBirthDate = macros.birthDate
        }
    }
    
    private func getFormattedDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let month = dateFormatter.string(from: vm.birthDate)
        return ("\(month) \(vm.birthDate.get(.day)) \(vm.birthDate.get(.year))")
        
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        VStack(alignment: .center) {
                            Text("My Profile")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            ProfileImageView(showingOptions: $showingSourceOptions, imageUrl: URL(string: sessionService.user?.photoUrl ?? ""), enableEditMode: true)
                                .overlay {
                                    if (showUploadingProgress) {
                                        ProgressView()
                                    }
                                }
                            
                            HStack(alignment: .lastTextBaseline) {
                                Text(vm.firstName )
                                Text(vm.lastName)
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(.green)
                                    .onTapGesture {
                                        isPresentingEditName = true
                                    }
                                
                            }
                            .font(.title2)
                            .fontWeight(.bold)
                        }
                        .padding(.vertical)
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        LabeledContent {
                            Text("\(feet) ft \(inches) in")
                                .foregroundColor(Color(hex: "55C856"))
                                .font(.headline)
                                .fontWeight(.semibold)
                        } label: {
                            Text("Height")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .onTapGesture {
                            measurement = .height
                            showingUnitOfMeasureForm.toggle()
                            
                        }
                        
                        LabeledContent {
                            Text(weight + " lb")
                                .foregroundColor(Color(hex: "55C856"))
                                .font(.headline)
                                .fontWeight(.semibold)
                        } label: {
                            Text("Weight")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .onTapGesture {
                            measurement = .weight
                            showingUnitOfMeasureForm.toggle()
                        }
                        
                        LabeledContent {
                            Picker("System", selection: $vm.gender) {
                                ForEach(Gender.allCases) { option in
                                    Text("\(option.rawValue.capitalized)")
                                }
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: vm.gender, perform: { (value) in
                                impactMed.impactOccurred()
                            })
                            .fixedSize()
                        } label: {
                            Text("Gender")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        
                        LabeledContent {
                            Text("\(getFormattedDateString())")
                                .foregroundColor(Color(hex: "55C856"))
                                .font(.headline)
                                .fontWeight(.semibold)
                        } label: {
                            Text("Date of Birth")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }.onTapGesture {
                            self.showDatePicker.toggle()
                        }
                        
                        LabeledContent {
                            Text(vm.goal.rawValue.capitalized + " " + "weight")
                                .foregroundColor(Color(hex: "55C856"))
                                .font(.headline)
                                .fontWeight(.semibold)
                        } label: {
                            Text("Fitness Goal")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .onTapGesture {
                            self.showFitnessGoalPicker.toggle()
                        }
                        
                        Text("Sign Out")
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
                    .listRowSeparator(.hidden)
                }
                .scrollDisabled(true)
                .environment(\.defaultMinListRowHeight, 50)
                .background(Color.white)
            }
            .onAppear {
                Task {
                    await injectUserVariables()
                    
                    let realFeet = 0.0328*Double(vm.height)!
                    let feet  = floor(realFeet);
                    let inches  = round((realFeet - feet) * 12);
                    let weight = Measurement(value: Double(vm.weight)!, unit: UnitMass.kilograms).converted(to: .pounds)
                    self.feet = String(Int(feet))
                    self.inches = String(Int(inches))
                    self.weight = String(Int(round(weight.value)))
                }
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
                        vm.updatePhotoUrl(userId: user.id, image: image) {
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
                            vm.birthDate = self.newBirthDate
                            self.showDatePicker.toggle()
                        }) {
                            Text("SET")
                        }
                    }
                    .padding([.top, .horizontal])
                    DatePicker("Date", selection: $newBirthDate, displayedComponents: [.date])
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .presentationDetents([.fraction(0.40)])
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
                            vm.goal = self.newGoal
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
            .alert("Enter your name", isPresented: $isPresentingEditName) {
                TextField("First name", text: $vm.firstName)
                TextField("Last name", text: $vm.lastName)
                Button("Save", action: {
//                    vm.c
                })
            }
            .popup(isPresented: .constant(showingUnitOfMeasureForm && measurement != .na)) {
                UnitOfMeasureForm(feet: $feet, inches: $inches, weight: $weight, showingUnitOfMeasureForm: $showingUnitOfMeasureForm, measurement: measurement) {
                    vm.weight = String(vm.weightInKg(pounds: Double(weight)!))
                    vm.height = String(vm.heightInCm(feet: Double(feet)!, inches: Double(inches)!))
                }
            } customize: {
                $0
                    .type(.floater())
                    .position(.center)
                    .animation(.spring())
                    .closeOnTapOutside(false)
                    .closeOnTap(false)
                    .dragToDismiss(false)
                    .backgroundColor(.black.opacity(0.5))
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
        ProfileView()
            .environmentObject(SessionServiceImpl())
    }
}
