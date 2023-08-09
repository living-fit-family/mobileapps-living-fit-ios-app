//
//  ActivityView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/3/23.
//

import SwiftUI

struct ActivityView: View {
    @StateObject private var vm: ActivityViewModel = ActivityViewModel()
    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                ForEach(vm.activities.sorted(by: {$0.value.id < $1.value.id}), id: \.key) { activity in
                    ActivityCard(activity: activity.value)
                }
            }
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
