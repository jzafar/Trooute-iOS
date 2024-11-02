//
//  Inbox.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-31.
//

import Foundation
import FirebaseFirestore

struct Inbox: Codable, Hashable, Identifiable {
    var id: String
    let user: ChatUser?
    var users: [ChatUser]? = nil
    let lastMessage: String?
    let timestamp: TimeInterval?
    var message: Message? = nil
}
