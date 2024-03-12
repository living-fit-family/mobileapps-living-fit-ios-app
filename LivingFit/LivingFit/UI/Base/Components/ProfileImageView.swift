//
//  ProfileImageView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 8/5/23.
//

import SwiftUI
import Kingfisher

struct ProfileImageView: View {
    @Binding var showingOptions: Bool
    
    let imageUrl: URL?
    let enableEditMode: Bool
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if let url = imageUrl {
                KFImage.url(url)
                    .placeholder {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundStyle(Color(UIColor.systemGray5))
                    }
                    .loadDiskFileSynchronously()
                    .cacheMemoryOnly()
                    .fade(duration: 0.25)
                    .onProgress { receivedSize, totalSize in  }
                    .onSuccess { result in  }
                    .onFailure { error in }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 65, height: 65)
                    .clipShape(Circle())
                    .shadow(radius: 3)
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 65, height: 65)
                    .foregroundStyle(Color(UIColor.systemGray5))
                    .shadow(radius: 3)
            }
            if (enableEditMode) {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
                    .frame(width: 25, height: 25)
                    .background(Color(hex: "55C856"))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .onTapGesture {
                        showingOptions = true
                    }
            }
        }
    }
}


struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileImageView(showingOptions: .constant(false), imageUrl: URL(string:"https://sample-image-url.com")!, enableEditMode: false)
            
            ProfileImageView(showingOptions: .constant(false), imageUrl: URL(string:"https://sample-image-url.com")!, enableEditMode: true)
        }
    }
}
