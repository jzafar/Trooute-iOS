//
//  CarInfoViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-28.
//

import Foundation
import SwiftUI

class CarInfoViewModel: ObservableObject {
    @Published var image: Image? = nil
    let carDetails: CarDetails
    var isEditable: Bool
    init(carDetails: CarDetails, isEditable: Bool = false) {
        self.carDetails = carDetails
        self.isEditable = isEditable
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
}
