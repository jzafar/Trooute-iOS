//
//  ChatUser.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-31.
//

struct ChatUser: UserProfile, Codable, Identifiable, Hashable  {
    var id: String
    var name: String
    var photo: String?
    var gender: String?
    var seen: Bool
}
