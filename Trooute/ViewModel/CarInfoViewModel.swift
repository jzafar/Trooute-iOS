//
//  CarInfoViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-28.
//

import Foundation

class CarInfoViewModel {
    let carDetails: CarDetails
    init(carDetails: CarDetails) {
        self.carDetails = carDetails
    }
    
    var photo: String {
        return "\(Constants.baseImageUrl)/\(carDetails.photo)"
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
    
    var isEditable: Bool {
        return false
    }
}
