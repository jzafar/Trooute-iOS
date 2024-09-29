//
//  UserProfile.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-28.
//

import Foundation
protocol UserProfile: Codable {
    var id: String {get set}
    var name: String {get set}
    var photo: String? {get set}
    var gender: String? {get set}
}
