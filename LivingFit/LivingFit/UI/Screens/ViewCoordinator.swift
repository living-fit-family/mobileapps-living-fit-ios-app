//
//  ViewCoordinator.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/6/23.
//

import SwiftUI

struct ViewCoordinator: View {
    @EnvironmentObject  var sessionService: SessionServiceImpl
    @EnvironmentObject var bannerService: BannerService
    @ObservedObject var pushNotifications = PushNotifications()
    
    @State private var isActive: Bool = false
    
    @ViewBuilder
    func viewBuilder() -> some View {
        if let channelId = sessionService.channelId {
//            ChannelViewContainer(channelId: channelId)
//                .onDisappear {
//                    DispatchQueue.main.async {
//                        sessionService.channelId = nil
//                    }
//                }
        } else {
            MainView()
                .onAppear {
                    DispatchQueue.main.async {
                        sessionService.channelId = nil
//                        sessionService.updateUnreadChannelCount()
                    }
                }
        }
    }
    
    var body: some View {
        ZStack {
            if isActive {
                switch sessionService.state {
                case .loggedIn:
                    viewBuilder()
                    if let type = bannerService.bannerType {
                        BannerView(banner: type)
                    }
                case .loggedOut:
                    ContentView()
                case .billingError:
                    let error = NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey: "There is a problem with your Living Fit subscription."]) as Error
                    ErrorView(errorWrapper:
                                ErrorWrapper(error: error,
                                             guidance: "Please update your billing information.",
                                             isLink: true,
                                             linkText: "Update Account",
                                             url: "https://billing.stripe.com/p/login/5kAeXO3HI3JxeNafYY"))
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
