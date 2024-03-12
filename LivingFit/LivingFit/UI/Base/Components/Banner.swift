//
//  Banner.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 7/26/23.
//

import Foundation
import SwiftUI

enum BannerType {
    var id: Self { self }
    case info(message: String, isPersistent: Bool = false)
    case success(message: String, isPersistent: Bool = false)
    case error(message: String, isPersistent: Bool = false)
    case warning(message: String, isPersistent: Bool = false)
    
    var backgroundColor: Color {
        switch self {
        case .info: return Color.blue
        case .success: return Color(hex: "55C856")
        case .warning: return Color.yellow
        case .error: return Color.red
        }
    }
    
    var imageName: String {
        switch self {
        case .info: return "info.circle"
        case .success: return "checkmark.circle"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        }
    }
    
    var message: String {
        switch self {
        case let .info(message, _), let .success(message, _), let .warning(message, _), let .error(message, _):
            return message
        }
    }
    
    var isPersistent: Bool {
        switch self {
        case let .info(_, isPersistent), let .success(_, isPersistent), let .warning(_, isPersistent), let .error(_, isPersistent):
            return isPersistent
        }
    }
}

struct BannerView: View {
    @EnvironmentObject private var bannerService: BannerService
    @State private var showAllText: Bool = false
    let banner: BannerType
    
    private func bannerContent() -> some View {
        HStack(spacing: 10) {
            Image(systemName: banner.imageName)
                .font(.system(size: 20))
                .fontWeight(.light)
                .foregroundStyle(.white)
                .padding(5)
            VStack(alignment: .leading, spacing: 5) {
                Text(banner.message)
                    .foregroundStyle(.white)
                    .fontWeight(.light)
                    .font(banner.message.count > 25 ? .caption : .footnote)
                    .multilineTextAlignment(.leading)
//                    .lineLimit(showAllText ? nil : 2)
                (banner.message.count > 100 && banner.isPersistent) ?
                Image(systemName: self.showAllText ? "chevron.compact.up" : "chevron.compact.down")
                    .foregroundStyle(Color.white.opacity(0.6))
                    .fontWeight(.light)
                : nil
            }
            Spacer()
            banner.isPersistent ?
            Button {
                withAnimation {
                    bannerService.removeBanner()
                }
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.white)
                    .fontWeight(.light)
                    .padding(5)
            }
            .shadow(color: .black.opacity(0.2), radius: 3.0, x: 3, y:4)
            : nil
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(.white)
        .padding(8)
        .padding(.trailing, 2)
        .background(banner.backgroundColor)
        .cornerRadius(10)
        .shadow(color: banner.backgroundColor.opacity(0.25), radius: 8, x: 0, y: 4)
        .onTapGesture {
            withAnimation {
                self.showAllText.toggle()
            }
        }
    }
    
    var body: some View {
        VStack {
            Group {
                bannerContent()
            }
        }
        .onAppear {
            guard !banner.isPersistent else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                withAnimation {
                    bannerService.isAnimating = false
                    bannerService.bannerType = nil
                }
            }
        }
        .offset(y: bannerService.dragOffset.height)
        .opacity(bannerService.isAnimating ? max(0, (1.0 - Double(bannerService.dragOffset.height) / bannerService.maxDragOffsetHeight)) : 0)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if gesture.translation.height < 0 {
                        bannerService.dragOffset = gesture.translation
                    }
                }
                .onEnded { value in
                    if bannerService.dragOffset.height < -20 {
                        withAnimation {
                            bannerService.removeBanner()
                        }
                    } else {
                        bannerService.dragOffset = .zero
                    }
                }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal)
    }
}

struct BannerView_Previews: PreviewProvider {
    static var previews: some View {
        let bannerService = BannerService()
        bannerService.bannerType = .success(message: "",  isPersistent: true)
        return BannerView(banner: .success(message: "Workout Successfully Created",  isPersistent: true))
            .environmentObject(bannerService)
//            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
    }
}
