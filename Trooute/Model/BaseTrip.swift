//
//  BaseTrip.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-11-13.
//

protocol BaseTrip: Codable, Identifiable {
    var id: String { get set }
}
