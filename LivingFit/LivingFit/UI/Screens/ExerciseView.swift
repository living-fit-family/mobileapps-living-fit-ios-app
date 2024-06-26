//
//  ExerciseView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/27/23.
//
import SwiftUI
import PopupView

class ExerciseViewModel: ObservableObject {
    @Published var videos: [Video] = []
    
    func updateVideo(video: Video) -> Void {
        if let item = videos.firstIndex(where: {$0.name == video.name}) {
            videos[item].currentSet = video.currentSet
        }
    }
}

struct ExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var splitSessionService: SplitSessionServiceImpl
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var bannerService: BannerService
    
    @StateObject private var viewModel: ExerciseViewModel = ExerciseViewModel()
    
    @State private var timer: Timer?
    @State private var timeRemaining: Double = 5
    @State private var totalTime: Double = 5
    @State private var isTimerRunning = false
    @State private var isWorkoutPaused = false
    @Binding var totalElapsedSeconds: Double
    
    @State private var currentSet = 0
    @Binding var currentItem: Int
    
    @State private var isHIITInterval = false
    
    @State private var showSheet = false
    
    @State private var play = true
    @State private var timerText = ""
    
    @State private var isResting = false
    @State private var videoName = ""
    
    @State private var showingUnitOfMeasureForm = false
    @State private var weight = "0"
        
    var videos: [Video]
    var day: String
    var queries: [String]
    
    var complete: (_ time: Double) -> ()
    
    private func getWorkouts() -> [Workout] {
        guard let workouts = splitSessionService.userWorkOuts[day] else { return [] }
        return workouts
    }
    
    private func getAddedExercises() -> [Video] {
        let workouts = getWorkouts().flatMap { $0.videos }
        return workouts
    }
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                totalElapsedSeconds += 1
                
                if isResting {
                    isTimerRunning = true
                    if timeRemaining != 0 {
                        timeRemaining -= 1
                    } else {
                        isTimerRunning = false
                        isResting = false
                        updateSets()
                    }
                }
            }
        }
    }
    
    func updateSets() {
        if let sets = viewModel.videos[currentItem].sets {
            if currentSet + 1 < Int(sets)! {
                currentSet = currentSet + 1
                updateUI()
            } else {
                currentItem = min(currentItem + 1, videos.count - 1)
                currentSet = 0
                updateUI()
            }
        } else {
            currentItem = min(currentItem + 1, videos.count - 1)
            currentSet = 0
            updateUI()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }
    
    func resumeTimer() {
        startTimer()
    }
    
    func resetTimer() {
        if let stringValue = videos[currentItem].rest {
            if let doubleValue = Double(stringValue) {
                self.timeRemaining = doubleValue
                self.totalTime = doubleValue
            }
        }
    }
    
    func getTimerText() {
        if let sets = viewModel.videos[currentItem].sets {
            if currentItem == videos.count - 1 && currentSet + 1 == Int(sets)! {
                timerText = "FINISH"
            } else if isWorkoutPaused == true {
                timerText = "FINISH"
            } else {
                timerText = "REST"
            }
        } else {
            if currentItem == videos.count - 1 {
                timerText = "FINISH"
            }
            
            if isWorkoutPaused == true {
                timerText = "FINISH"
            }
        }
    }
    
    func updateUI() {
        var updatedVideo = viewModel.videos[currentItem]
        updatedVideo.currentSet = currentSet
        viewModel.updateVideo(video: updatedVideo)
        resetTimer()
        getTimerText()
    }
    
    func vibrate() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }
    
    var body: some View {
        VStack {
            ZStack {
                VideoPlayerView(urls: videos.map({ URL(string: $0.videoLink)!}), currentIndex: $currentItem, isPlaying: .constant(!isTimerRunning && !isWorkoutPaused))
                    .edgesIgnoringSafeArea(.all)
            }
            .overlay(alignment: .top) {
                HStack {
                    Circle()
                        .opacity(0.7)
                        .foregroundStyle(Color.black)
                        .frame(width: 50, height: 50 )
                        .overlay {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.white)
                                .imageScale(.medium)
                                .fontWeight(.semibold)
                        }
                        .onTapGesture {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    Spacer()
                    Text(videos[currentItem].name)
                        .font(.custom("Avenir", size: 20))
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .shadow(radius: 3)
                    Spacer()
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 10.0)
                            .opacity(0.3)
                            .foregroundStyle(Color.white)
                        Circle()
                            .trim(from: 0.0, to: CGFloat(currentItem) / CGFloat(videos.count - 1))
                            .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                            .foregroundStyle(Color.white)
                            .rotationEffect(Angle(degrees: -90))
                            .animation(.linear(duration: 1.0), value: UUID())
                    }
                    .background(.black.opacity(0.7))
                    .overlay {
                        Text("\(currentItem + 1)/\(videos.count)")
                            .foregroundStyle(.white)
                            .font(.custom("Avenir", size: 13))
                            .fontWeight(.bold)
                            .zIndex(1)
                    }
                    .clipShape(Circle())
                    .frame(width: 55, height: 55)
                }
                .padding(.horizontal)
            }
            VStack {
                HStack {
                    if videos[currentItem].category == "cardio" {
                        VStack {
                            Text("\(currentSet + 1)/\(videos[currentItem].duration ?? "")")
                                .font(.custom("Avenir", size: 26))
                                .fontWeight(.bold)
                            Text("Duration")
                                .font(.custom("Avenir", size: 13))
                                .foregroundStyle(.gray)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        Divider()
                            .frame(height: 20)
                        VStack {
                            Text(videos[currentItem].rest ?? "")
                                .font(.custom("Avenir", size: 26))
                                .fontWeight(.bold)
                            Text("Rest")
                                .font(.custom("Avenir", size: 13))
                                .foregroundStyle(.gray)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    } else {
                        VStack {
                            Text("\(currentSet + 1)/\(videos[currentItem].sets ?? "")")
                                .font(.custom("Avenir", size: 26))
                                .fontWeight(.bold)
                            Text("Sets")
                                .font(.custom("Avenir", size: 13))
                                .foregroundStyle(.gray)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        Divider()
                            .frame(height: 20)
                        VStack {
                            Text(videos[currentItem].reps ?? "")
                                .font(.custom("Avenir", size: 26))
                                .fontWeight(.bold)
                            Text("Reps")
                                .font(.custom("Avenir", size: 13))
                                .foregroundStyle(.gray)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        Divider()
                            .frame(height: 20)
                        VStack {
                            Text(videos[currentItem].weight ?? "0")
                                .font(.custom("Avenir", size: 26))
                                .fontWeight(.bold)
                            HStack(alignment: .lastTextBaseline) {
                                Text("Weight (lbs)")
                                    .font(.custom("Avenir", size: 13))
                                    .foregroundStyle(.gray)
                                Image(systemName: "square.and.pencil")
                                    .font(.custom("Avenir", size: 13))
                                    .foregroundStyle(Color.colorPrimary)
                                
                            }
                        }
                        .onTapGesture {
                            self.videoName = videos[currentItem].name
                            showingUnitOfMeasureForm.toggle()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                }
                VStack(alignment: .center) {
                    CircleTimerView(progress: CGFloat(timeRemaining) / totalTime, timeRemaining: timeRemaining, isTimerRunning: .constant(!isTimerRunning), text: $timerText, showText: .constant(true), animate: $isTimerRunning, color: .constant(Color.colorPrimary))
                        .frame(height: 150)
                        .overlay {
                            if (isTimerRunning) {
                                VStack {
                                    Text(timeRemaining.format(using: [.minute, .second]))
                                        .font(.custom("Avenir", size: 20))
                                        .foregroundStyle(.black)
                                        .fontWeight(.bold)
                                        .contentTransition(.numericText())
                                    Text("Tap to Skip")
                                        .font(.custom("Avenir", size: 11))
                                        .foregroundStyle(.gray)
                                }
                            } else {
                                Text(timerText)
                                    .font(.custom("Avenir", size: 20))
                                    .foregroundStyle(.black)
                                    .fontWeight(.bold)
                                    .contentTransition(.numericText())
                            }
                        }
                        .onTapGesture {
                            vibrate()
                            if (!isTimerRunning && isWorkoutPaused) {
//                                path.removeLast(path.count)
                            } else if (!isTimerRunning && timerText != "FINISH") {
                                isResting = true
                                isTimerRunning = true
                            } else if isTimerRunning {
                                // Skip Rest
                                isTimerRunning = false
                                isResting = false
                                updateSets()
                                resetTimer()
                            } else {
                                // Workout Finished
                                stopTimer()
                                complete(totalElapsedSeconds)
                            }
                        }
                }
                .padding(.vertical)
                HStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color(uiColor: .systemGray5))
                        .overlay {
                            HStack {
                                Image(systemName: isWorkoutPaused ? "play.fill" : "pause.fill")
                                Text(isWorkoutPaused ? "Resume" : "Pause")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                        }
                        .onTapGesture {
                            if timer == nil {
                                resumeTimer()
                            } else {
                                stopTimer()
                            }
                            isWorkoutPaused.toggle()
                            getTimerText()
                            
                        }
                    RoundedRectangle(cornerRadius: 5)
                        .overlay {
                            VStack {
                                Text(totalElapsedSeconds.format(using: [.hour, .minute, .second]))
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.colorPrimary)
                            }
                        }
                }
                .padding(.horizontal)
                .frame(maxHeight: 50)
            }
        }
        .ignoresSafeArea(.keyboard)
        .popup(isPresented: $showingUnitOfMeasureForm) {
            UnitOfMeasureForm(feet: .constant(""), inches: .constant(""), weight: $weight, showingUnitOfMeasureForm: $showingUnitOfMeasureForm, measurement: .weight) {
                let index = getAddedExercises().firstIndex(where: { $0.name == videoName })
                var workouts = getAddedExercises()
                
                if let index = index {
                    var newExercise = workouts[index]
                    newExercise.weight = weight
                    workouts[index] = newExercise
                }
                
                if let user = sessionService.user {
                    Task {
                        await splitSessionService.addUserWorkout(uid: user.id, day: day, categories: queries, workout: workouts)
                    }
                }
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
        .onAppear {
            viewModel.videos = videos
            if let currentSet = viewModel.videos[currentItem].currentSet {
                self.currentSet = currentSet
            }
            stopTimer()
            resetTimer()
            startTimer()
            getTimerText()
        }
        .onDisappear {
            stopTimer()
        }
        .onChange(of: currentItem, perform: { value in
            if let currentSet = viewModel.videos[value].currentSet {
                self.currentSet = currentSet
            } else {
                self.currentSet = 0
            }
            resetTimer()
            getTimerText()
        })
    }
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ExerciseView(totalElapsedSeconds: .constant(Double(0)), currentItem: .constant(0), videos: [Video.sampleVideo, Video.sampleVideo2], day: "Monday", queries: [""]) { time in
                
            }
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
        }
    }
}
