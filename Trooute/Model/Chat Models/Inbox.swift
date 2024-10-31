//
//  Inbox.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-31.
//

import Foundation
import FirebaseFirestore

struct Inbox: Codable, Hashable, Identifiable {
    @DocumentID public var id: String?
    let user: ChatUser?
    let users: [ChatUser]?
    let lastMessage: String?
    let timestamp: Int?
    var message: Message? = nil
//    @ServerTimestamp var timestamp: Date?
}
