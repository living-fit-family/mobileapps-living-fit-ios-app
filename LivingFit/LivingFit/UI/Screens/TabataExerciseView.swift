//
//  ExerciseView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/27/23.
//
import SwiftUI
import Combine
import VideoPlayer
import CoreMedia
import AVFoundation
import Kingfisher
import AVKit

enum Interval {
    case work
    case rest
    case initial
}

struct CountdownView: View {
    @State private var count = 10 // Set the initial countdown value
    @State private var scale: CGFloat = 1.0
    @State private var removeText = false
    var callback: () -> ()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            if count > 0 {
                Text("Get Ready")
                    .font(.custom("Avenir", size: 20.0))
                    .italic()
                Text("\(count)")
                    .font(.system(size: 100))
                    .scaleEffect(scale)
                    .onReceive(timer) { _ in
                        if self.count > 0 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                self.scale = 0.1
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.count -= 1
                                self.scale = 1.0
                            }
                        }
                    }
            } else {
                if (!removeText) {
                    Text("Go!")
                        .font(.system(size: 200))
                        .foregroundStyle(Color.colorPrimary)
                }
            }
        }
        .padding(.top)
        .foregroundStyle(.black)
        .onChange(of: count, perform: { value in
            if value == 0 {
                callback()
                removeText.toggle()
            }
        })
    }
}

struct TabataExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var splitSessionService: SplitSessionServiceImpl
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var bannerService: BannerService
    
    @State private var totalTime: TimeInterval = 0
    @State private var currentRound = 1
    @State private var currentSet = 1
    @State private var isWorkTime = true
    @State private var isTimerRunning = false
    @State private var timer: Timer?
    @State private var elapsedTotalTime: TimeInterval = 0
    
    @State private var time: CMTime = .positiveInfinity
    
    @State private var currentItem = 0
    
    @State private var showSheet = false
    
    @State private var isPlaying = false
        
    @State private var progress = 1.0
    @State private var totalProgress = 1.0
    
    @State private var animate = false
    @State private var isInitialCountDown = false
    
    @State private var isFirstLoad = false
    @State private var isResetting = false
    
    @State private var isPressed = false
    
    
    var videos: [Video]
    var day: String
    var queries: [String]
    var interval: Split.Interval = Split.Interval(rounds: 4, work: 10, rest: 5)
    
    @Binding var path: NavigationPath
    
    var complete: () -> ()
    
    func updateUI() {
        // Update UI elements here
    }
    
    func toggleNextVideo() {
        if currentItem != videos.count - 1 {
            currentItem = currentItem + 1
        } else {
            // reset
            currentRound += 1
            currentItem = 0
        }
    }
    
    private func startTimer() {
        isTimerRunning = true
        isResetting = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if totalTime > 0 {
                isResetting = false
                totalTime -= 1
                elapsedTotalTime -= 1
            } else {
                isResetting = true
                switchInterval()
            }
            
            if (elapsedTotalTime <= 0) {
                stopTimer()
                complete()
            }
        }
    }
    
    private func switchInterval() {
        if isWorkTime {
            if currentSet != videos.count * interval.rounds {
                currentSet += 1
                toggleNextVideo() // Only toggle next video if we havent reached the max rounds and sets
            }
        }
        isWorkTime.toggle()
        isPlaying.toggle()
        totalTime = isWorkTime ? Double(interval.work) : Double(interval.rest)
    }
    
    func stopTimer() {
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
        isWorkTime = true
        currentSet = 1
        currentRound = 1
        currentItem = 0
        totalTime = Double(interval.work)
        elapsedTotalTime = Double((interval.work + interval.rest) * videos.count * interval.rounds)
    }
    
    private func getWorkouts() -> [Workout] {
        guard let workouts = splitSessionService.userWorkOuts[day] else { return [] }
        return workouts
    }
    
    private func getAddedExercises() -> [Video] {
        let workouts = getWorkouts().flatMap { $0.videos }
        return workouts
    }
    
    var body: some View {
        VStack {
            ZStack {
                VideoPlayerView(urls: videos.map({ URL(string: $0.videoLink)!}), currentIndex: $currentItem, isPlaying: $isPlaying)
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
            
            HStack(alignment: .top) {
                VStack {
                    Text("\(currentRound)/\(interval.rounds)")
                        .font(.custom("Avenir", size: 26))
                        .fontWeight(.bold)
                    Text("Round")
                        .font(.custom("Avenir", size: 13))
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                }
                ZStack {
                    CircleTimerView(progress: CGFloat(elapsedTotalTime) / CGFloat((interval.work + interval.rest) * videos.count * interval.rounds), timeRemaining: elapsedTotalTime, isTimerRunning: $isResetting, text: .constant(""), showText: .constant(false),  animate: .constant(true), color: .constant(Color(hex: "#C855C8")))
                        .frame(width: 200)
                    CircleTimerView(progress: CGFloat(totalTime) / CGFloat(isWorkTime ? Double(interval.work) : Double(interval.rest)), timeRemaining: totalTime, isTimerRunning: $isResetting, text: .constant(""), showText: .constant(false), animate: .constant(true), color: .constant(isWorkTime ? Color.red : Color.colorPrimary))
                        .frame(width: 225)
                }
                .overlay(alignment: .center) {
                    
                    if (isInitialCountDown) {
                        CountdownView() {
                            isFirstLoad.toggle()
                            isInitialCountDown.toggle()
                            isPlaying.toggle()
                            startTimer()
                        }
                    }
                    if !isInitialCountDown {
                        VStack {
                            VStack {
                                Text(isWorkTime ? "Work" : "Rest")
                                    .font(.custom("Avenir", size: 20.0))
                                    .bold()
                                    .italic()
                                    .foregroundStyle(isWorkTime ? .red : Color.colorPrimary)
                                Text(totalTime.format(using: [.minute, .second]))
                                    .font(.custom("Avenir", size: 56))
                                    .fontWeight(.bold)
                                    .foregroundStyle(isWorkTime ? .red : Color.colorPrimary)
                            }
                            .padding(.top, 16)
                            Text("Total Time")
                                .font(.custom("Avenir", size: 13))
                                .fontWeight(.semibold)
                            Text(elapsedTotalTime.format(using: [.minute, .second]))
                                .foregroundStyle(Color(hex: "#C855C8"))
                                .fontWeight(.bold)
                        }
                    }
                }
                VStack {
                    Text("\(currentSet)/\(Int(interval.rounds) * Int(videos.count))")
                        .font(.custom("Avenir", size: 26))
                        .fontWeight(.bold)
                    Text("Set")
                        .font(.custom("Avenir", size: 13))
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                }
            }
            .padding(.bottom)
            HStack {
                Rectangle()
                    .fill(Color(.white))
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(!isTimerRunning && !isFirstLoad && !isResetting  ? Color.red : Color.colorPrimary, lineWidth: 2)
                    }
                    .overlay {
                        HStack {
                            Image(systemName: !isTimerRunning && !isFirstLoad && !isResetting ? "stop.fill" : "gobackward")
                            Text(!isTimerRunning && !isFirstLoad && !isResetting ? "Stop" : "Reset")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(!isTimerRunning && !isFirstLoad && !isResetting ? Color.red : Color.colorPrimary)
                    }
                    .onTapGesture {
                        if !isTimerRunning && !isFirstLoad && !isResetting {
                            path.removeLast(path.count)
                        }
                        
                        if isTimerRunning && !isFirstLoad {
                            isResetting = true
                            resetTimer()
                            if isPlaying {
                                isPlaying.toggle()
                            }
                        }
                    }
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.colorPrimary)
                    .overlay {
                        HStack {
                            Image(systemName: isTimerRunning ? "pause.fill" : "play.fill")
                            Text(isTimerRunning ? "Pause" : "Start")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(Color(uiColor: .systemGray6))
                    }
                    .onTapGesture {
                        if isFirstLoad && !isInitialCountDown {
                            isInitialCountDown.toggle()
                            totalTime = Double(interval.work)
                            elapsedTotalTime = Double((interval.work + interval.rest) * videos.count * interval.rounds)
                        } else if (isTimerRunning) {
                            stopTimer()
                            if (isWorkTime) {
                                isPlaying.toggle()
                            }
                        } else if (!isTimerRunning && !isFirstLoad) {
                            startTimer()
                            if (isWorkTime) {
                                isPlaying.toggle()
                            }
                        }
                    }
            }
            .padding(.horizontal)
            .frame(maxHeight: 50)
        }
        .onAppear {
            isFirstLoad = true
        }
        
    }
}


struct TabataExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TabataExerciseView(videos: [Video.sampleVideo, Video.sampleVideo2], day: "Monday", queries: [""], interval: Split.Interval(rounds: 4, work: 10, rest: 5), path: .constant(NavigationPath())) {
                
            }
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
        }
    }
}
