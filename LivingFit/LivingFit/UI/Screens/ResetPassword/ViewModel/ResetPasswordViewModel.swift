//
//  ResetPasswordViewModel.swift
//  LivingFit
//
//  Created by Alexander Cleoni on 6/27/23.
//

import Foundation
import Combine

protocol ResetPasswordViewModel {
    func sendPasswordReset()
    var service: AuthService { get }
    var email: String { get }
    init(service: AuthService)
}

final class ResetPasswordViewModelImpl: ResetPasswordViewModel, ObservableObject {
    @Published var email: String = ""
    let service: AuthService
    
    init(service: AuthService) {
        self.service = service
    }
    
    private var subscriptions = Set<AnyCancellable>()

    
    func sendPasswordReset() {
        service.sendPasswordReset(withEmail: email)
            .sink { res in
                switch res {
                case .failure(let err):
                    print("Failed: \(err)")
                default: break
                }
            } receiveValue: {
                print("Sent Password Reset Request")
            }.store(in: &subscriptions)
    }
}
