//
//  Double.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-16.
//
import Foundation
extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
