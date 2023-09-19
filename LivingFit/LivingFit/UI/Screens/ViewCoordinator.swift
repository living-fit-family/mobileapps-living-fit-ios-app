//
//  ViewCoordinator.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/6/23.
//

import SwiftUI
import FirebaseFunctions

struct ViewCoordinator: View {
    @EnvironmentObject  var sessionService: SessionServiceImpl
    @EnvironmentObject var bannerService: BannerService
    @State private var isActive: Bool = false
    var body: some View {
        ZStack {
            if isActive {
                switch sessionService.state {
                case .loggedIn:
                    MainView()
                    if let type = bannerService.bannerType {
                        BannerView(banner: type)
                    }
                case .loggedOut:
                    ContentView()
                }
            } else {
                SplashScreen(isActive: $isActive)
            }
        }
    }
}


struct ViewCoordinator_Previews: PreviewProvider {
    static var previews: some View {
        ViewCoordinator()
            .environmentObject(SessionServiceImpl())
            .environmentObject(BannerService())
    }
}
