//
//  UpdateCarInfoRequests.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-20.
//
import Foundation
struct UpdateCarInfoRequests {
    let make: String
    let model: String
    let registrationNumber: String
    let year: String
    let color: String
    var carPhoto: Data? = nil
    var driverLicense: Data? = nil
    var parameters: [String: Any] {
        if let carImage = carPhoto,
           let driverPhoto = driverLicense {
            return [
                "make": make,
                "model": model,
                "registrationNumber": registrationNumber.uppercased(),
                "year": year,
                "color": color,
                "carPhoto": carImage,
                "driverLicense": driverPhoto,
            ]
        } else if let carImage = carPhoto {
            return [
                "make": make,
                "model": model,
                "registrationNumber": registrationNumber.uppercased(),
                "year": year,
                "color": color,
                "carPhoto": carImage,
            ]
        } else if let driverPhoto = driverLicense {
            return [
                "make": make,
                "model": model,
                "registrationNumber": registrationNumber.uppercased(),
                "year": year,
                "color": color,
                "driverLicense": driverPhoto,
            ]
        } else {
            return [
                "make": make,
                "model": model,
                "registrationNumber": registrationNumber.uppercased(),
                "year": year,
                "color": color,
            ]
        }
        
    }
}
