//
//  MainTabViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-13.
//

import Foundation
import SwiftUI
class MainTabViewModel: ObservableObject {
//    @AppStorage(UserDefaultsKey.user.key) var user: User?
   
    private let repositiry = MainTabViewRepository()
    func getMe() {
        repositiry.getMe { result in
            switch result {
            case .success(let response):
                if response.data.success,
                   let user = response.data.data {
                    UserUtils.shared.saveUserToStorage(user: user)
                }
                    
            case .failure(let error):
                log.error("failed to get me \(error.localizedDescription)")
            }
        }
    }
}
