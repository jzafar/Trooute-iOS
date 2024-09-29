//
//  TripLocation.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-27.
//
import Foundation

struct TripRouteModel {
    let fromAddress: String
    let whereToAddress: String
    let date: String
    
    var formattedDate: String {
        return date.fullFormate()
    }
}
