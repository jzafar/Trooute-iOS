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
import SwiftLoader

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
    let years = Array(2016 ... 2025).map { "\($0)" }
    var carDetails: CarDetails?
    private let repository = DriverRepository()
    init(carDetails: CarDetails?) {
        self.carDetails = carDetails
        if let car = carDetails {
            vehicleMake = car.make.emptyOrNil
            vehicleModel = car.model.emptyOrNil
            vehicleYear = "\(car.year ?? 0000)"
            vehicleColor = car.color.emptyOrNil
            vehicleLicensePlate = car.registrationNumber ?? ""
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
    
    func updateCarInfo() {
        if vehicleMake.trim().count == 0 {
            BannerHelper.displayBanner(.error, message: "Make" + " " + "field can\'t be blank")
        } else if (vehicleModel.trim().count == 0) {
            BannerHelper.displayBanner(.error, message: "Model" + " " + "field can\'t be blank")
        } else if (vehicleColor.trim().count == 0) {
            BannerHelper.displayBanner(.error, message: "Color" + " " + "field can\'t be blank")
        } else if (vehicleYear.trim().count == 0) {
            BannerHelper.displayBanner(.error, message: "Yesr" + " " + "field can\'t be blank")
        } else if (vehicleLicensePlate.trim().count == 0) {
            BannerHelper.displayBanner(.error, message: "Vehicel license plate" + " " + "field can\'t be blank")
        } else if (Utils.convertImageToData(vehicleImage) == nil) {
            BannerHelper.displayBanner(.error, message: "Vehicel image" + " " + "field can\'t be blank")
        } else {
            
            let request = UpdateCarInfoRequests(make: vehicleMake.trim(),
                                                model: vehicleModel.trim(),
                                                registrationNumber: vehicleLicensePlate.trim(),
                                                year: vehicleYear.trim(),
                                                color: vehicleColor.trim(),
                                                carPhoto: (Utils.convertImageToData(vehicleImage))!)
            SwiftLoader.show(title: "Updating...", animated: true)
            self.repository.updateCarInfo(request: request) {  result in
                SwiftLoader.hide()
                switch result {
                case .success(let response):
                    if response.data.success,
                       let car = response.data.data {
                        UserUtils.shared.updateCarInfo(car: car)
                        BannerHelper.displayBanner(.success, message: response.data.message)
                    } else {
                        BannerHelper.displayBanner(.error, message: response.data.message)
                    }
                case .failure(let failure):
                    BannerHelper.displayBanner(.error, message: failure.localizedDescription)
                }
            }
        }
    }
    
    func becomeADriver() {
        if vehicleMake.trim().count == 0 {
            BannerHelper.displayBanner(.error, message: "Make" + " " + "field can\'t be blank")
        } else if (vehicleModel.trim().count == 0) {
            BannerHelper.displayBanner(.error, message: "Model" + " " + "field can\'t be blank")
        } else if (vehicleColor.trim().count == 0) {
            BannerHelper.displayBanner(.error, message: "Color" + " " + "field can\'t be blank")
        } else if (vehicleYear.trim().count == 0) {
            BannerHelper.displayBanner(.error, message: "Yesr" + " " + "field can\'t be blank")
        } else if (vehicleLicensePlate.trim().count == 0) {
            BannerHelper.displayBanner(.error, message: "Vehicel license plate" + " " + "field can\'t be blank")
        } else if (Utils.convertImageToData(vehicleImage) == nil) {
            BannerHelper.displayBanner(.error, message: "Vehicel" + " " + "image is required")
        } else if (Utils.convertImageToData(drivingLicenseImage) == nil) {
            BannerHelper.displayBanner(.error, message: "License" + " " + "image is required")
        } else {
            
            let request = UpdateCarInfoRequests(make: vehicleMake.trim(),
                                                model: vehicleModel.trim(),
                                                registrationNumber: vehicleColor.trim(),
                                                year: vehicleYear.trim(),
                                                color: vehicleLicensePlate.trim(),
                                                carPhoto: Utils.convertImageToData(vehicleImage),
                                                driverLicense: Utils.convertImageToData(drivingLicenseImage))
            SwiftLoader.show(title: "Updating...", animated: true)
            self.repository.updateCarInfo(request: request) {  result in
                SwiftLoader.hide()
                switch result {
                case .success(let response):
                    if response.data.success,
                       let car = response.data.data {
                        UserUtils.shared.updateCarInfo(car: car)
                        BannerHelper.displayBanner(.success, message: response.data.message)
                    } else {
                        BannerHelper.displayBanner(.error, message: response.data.message)
                    }
                case .failure(let failure):
                    BannerHelper.displayBanner(.error, message: failure.localizedDescription)
                }
            }
        }
    }
}
