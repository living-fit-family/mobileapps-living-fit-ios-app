//
//  BannerService.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/26/23.
//

import Foundation
import SwiftUI

class BannerService: ObservableObject {
    @Published var isAnimating = false
    @Published var dragOffset = CGSize.zero
    @Published var bannerType: BannerType? {
        didSet {
            withAnimation {
                switch bannerType {
                case .none:
                    isAnimating = false
                case .some:
                    isAnimating = true
                }
            }
        }
    }
    let maxDragOffsetHeight: CGFloat = -50.0
    
    func setBanner(bannerType: BannerType) {
        withAnimation {
            self.bannerType = bannerType
        }
    }
    
    func removeBanner() {
        withAnimation {
            self.bannerType = nil
            self.isAnimating = false
            self.dragOffset = .zero
        }
    }
}
