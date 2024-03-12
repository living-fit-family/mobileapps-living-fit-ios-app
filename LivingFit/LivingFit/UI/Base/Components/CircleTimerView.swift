//
//  CircleTimerView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 2/5/24.
//

import Foundation
import SwiftUI

struct CircleTimerView: View {
    var progress: Double
    var timeRemaining: Double
    @Binding var isTimerRunning: Bool
    @Binding var text: String
    @Binding var showText: Bool
    @Binding var animate: Bool
    @Binding var color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10.0)
                .opacity(0.3)
                .foregroundStyle(color)

            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                .foregroundStyle(color)
                .rotationEffect(Angle(degrees: -90))
                .animation(!isTimerRunning ? .linear(duration: 1.0) : .none, value: UUID())
        }
    }
}

struct CircleTimerView_Previews: PreviewProvider {
    static var previews: some View {
        CircleTimerView(progress: 0.4, timeRemaining: 60, isTimerRunning: .constant(true), text: .constant("DONE"), showText: .constant(true), animate: .constant(false), color: .constant(Color.colorPrimary))
    }
}

extension TimeInterval {
    func format(using units: NSCalendar.Unit) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: self) ?? ""
    }
}
