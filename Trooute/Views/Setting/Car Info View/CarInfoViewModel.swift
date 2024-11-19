//
//  CarInfoViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-28.
//

import Foundation
import SwiftUI

class CarInfoViewModel: ObservableObject {
    let carDetails: CarDetails
    var isEditable: Bool
    var isHistory: Bool
    @Published var tripData: TripsData?
    init(carDetails: CarDetails, isEditable: Bool = false, isHistory: Bool = false, tripData: TripsData? = nil) {
        self.carDetails = carDetails
        self.isEditable = isEditable
        self.isHistory = isHistory
        self.tripData = tripData
    }
    
    var photo: String {
        if let photo = carDetails.photo {
            return "\(Constants.baseImageUrl)/\(photo)"
        }
        return "\(Constants.baseImageUrl)/\(carDetails.photo ?? "")"
    }
    
    var carMakeModel: String {
        return carDetails.make.emptyOrNil + " " + carDetails.model.emptyOrNil
    }
    
    var year: String {
        if let year = carDetails.year {
            return "\(year)"
        }
        return "Not Provided"
    }
    var color: String {
        if let color = carDetails.color {
            return "\(color.lowercased().firstCapitalized)"
        }
        return "Not Provided"
    }
}
