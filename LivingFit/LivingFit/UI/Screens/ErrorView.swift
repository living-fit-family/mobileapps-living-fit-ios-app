//
//  ErrorView.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 9/20/23.
//

import SwiftUI

struct ErrorWrapper: Identifiable {
    let id: UUID
    let error: Error
    let guidance: String
    let isLink: Bool
    let linkText: String
    let url: String
    
    
    init(id: UUID = UUID(), error: Error, guidance: String, isLink: Bool = false, linkText: String = "", url: String = "") {
        self.id = id
        self.error = error
        self.guidance = guidance
        self.isLink = isLink
        self.linkText = linkText
        self.url = url
    }
}

struct ErrorView: View {
    let errorWrapper: ErrorWrapper
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("An error has occurred!")
                    .font(.title)
                    .padding(.bottom)
                Text(errorWrapper.error.localizedDescription)
                    .font(.headline)
                Text(errorWrapper.guidance)
                    .font(.subheadline)
                    .padding(.top)
                if errorWrapper.isLink {
                    Link(errorWrapper.linkText, destination: URL(string: errorWrapper.url)!)
                        .padding(.top)
                }
                Spacer()
                Spacer()
            }
        }
    }
}


struct ErrorView_Previews: PreviewProvider {
    enum SampleError: Error {
        case errorRequired
    }
    
    static var wrapper: ErrorWrapper {
        ErrorWrapper(error: SampleError.errorRequired,
                     guidance: "You can safely ignore this error.")
    }
    
    static var previews: some View {
        ErrorView(errorWrapper: wrapper)
    }
}
