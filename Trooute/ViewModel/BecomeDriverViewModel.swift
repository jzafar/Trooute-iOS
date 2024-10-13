//
//  BecomeDriverViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-04.
//

import Foundation
import PhotosUI
import SDWebImageSwiftUI
import SwiftUI
class BecomeDriverViewModel: ObservableObject {
    @Published var vehicleMake = ""
    @Published var vehicleModel = ""
    @Published var vehicleYear = ""
    @Published var vehicleColor = ""
    @Published var vehicleLicensePlate = ""
    @Published var drivingLicenseImage: Image? = nil
    @Published var vehicleImage: Image? = nil
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var selectedDriverLicense: PhotosPickerItem? = nil

    let colors = ["White", "Black", "Gray", "Silver", "Blue", "Red", "Brown", "Green", "Orange", "Beige", "Purple", "Gold", "Yellow"]
    let years = Array(2016 ... 2024).map { "\($0)" }
    var carDetails: CarDetails?

    init(carDetails: CarDetails?) {
        self.carDetails = carDetails
        if let car = carDetails {
            vehicleMake = car.make.emptyOrNil
            vehicleModel = car.model.emptyOrNil
            vehicleYear = "\(car.year ?? 0000)"
            vehicleColor = car.color.emptyOrNil
            vehicleLicensePlate = car.registrationNumber.emptyOrNil
        }
        Task {
            do {
                self.vehicleImage = try await Utils.downloadImage(url: carPhoto)
            } catch {
                print("fail to download image \(error.localizedDescription)")
            }
        }
    }

    var carPhoto: String {
        return "\(Constants.baseImageUrl)/\(carDetails?.photo ?? "")"
    }
}
