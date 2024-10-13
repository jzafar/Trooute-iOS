//
//  LoggedInUser.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-12.
//

import Foundation
class LoggedInUser: ObservableObject {
    @Published var user: User?
    @Published var token: String? 
    init(user: User? = nil, token: String? = nil) {
        self.user = user
        self.token = token
    }
}
