//
//  DriverCarViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-27.
//

import Foundation
import SwiftUI

class DriverCarViewModel: ObservableObject {
    @Published var carImage: Image? = nil
    var driver: Driver
    init(driver: Driver) {
        self.driver = driver
    }
    
    var driverPicture: String {
        return "\(Constants.baseImageUrl)/\(driver.photo ?? "")"
    }
    
    var carPicture: String {
        return "\(Constants.baseImageUrl)/\(driver.carDetails?.photo ?? "")"
    }
    
    var carMake: String {
        return self.driver.carDetails?.make ?? "Not Provided"
    }
    
    var registrationNumber: String {
        return self.driver.carDetails?.registrationNumber ?? "Not Provided"
    }
    
    var avgRating: Float {
        return self.driver.reviewsStats?.avgRating ?? 0.0
    }
    
    var totalReviews: String {
        return "(\(self.driver.reviewsStats?.totalReviews ?? 0))"
    }
}
