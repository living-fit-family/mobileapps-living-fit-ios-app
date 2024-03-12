//
//  ActivityCard.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/3/23.
//

import SwiftUI

struct Activity {
    let id: Int
    let title: String
    let subtitle: String
    let image: String
    let amount: String
    let color: Color
}

struct ActivityCard: View {
    @State var activity: Activity
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .cornerRadius(10)
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(activity.title)
                            .font(.headline)
                        Text(activity.subtitle)
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                    Image(systemName: activity.image)
                        .foregroundStyle(activity.color)
                    
                }
                
                Text(activity.amount)
                    .font(.title)
            }
            .padding()
        }
    }
}

struct ActivityCard_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCard(activity: Activity(id: 0, title: "Daily Steps", subtitle: "Goal: 10,000", image: "figure.walk", amount: "6,234", color: .blue))
    }
}
