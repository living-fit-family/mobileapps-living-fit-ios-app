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
                            .foregroundColor(Color(UIColor.systemGray5))
                    }
                    .loadDiskFileSynchronously()
                    .cacheMemoryOnly()
                    .fade(duration: 0.25)
                    .onProgress { receivedSize, totalSize in  }
                    .onSuccess { result in  }
                    .onFailure { error in }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color(UIColor.systemGray5))
            }
            if (enableEditMode) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
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
