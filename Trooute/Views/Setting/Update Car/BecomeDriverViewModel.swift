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
    @Published var dismiss = false
    let colors = [String(localized:"White"), String(localized:"Black"), String(localized:"Gray"), String(localized:"Silver"), String(localized:"Blue"), String(localized:"Red"), String(localized:"Brown"), String(localized:"Green"), String(localized:"Orange"), String(localized:"Beige"), String(localized:"Purple"), String(localized:"Gold"), String(localized:"Yellow")]
    let years = Array(2016 ... 2025).map { "\($0)" }
    var carDetails: CarDetails?
    private let repository = DriverRepository()
    init(carDetails: CarDetails?) {
        self.carDetails = carDetails
        if let car = carDetails {
            vehicleMake = car.make ?? ""
            vehicleModel = car.model ?? ""
            vehicleYear = "\(car.year ?? 0000)"
            vehicleColor = car.color ?? ""
            vehicleLicensePlate = car.registrationNumber ?? ""
        }
        Task {
            do {
                if let image =  try await Utils.downloadImage(url: carPhoto) {
                    DispatchQueue.main.async {
                        self.vehicleImage = image
                    }
                }
                
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
            BannerHelper.displayBanner(.error, message: String(localized:"Make") + " " + String(localized:"field can't be blank"))
        } else if (vehicleModel.trim().count == 0) {
            BannerHelper.displayBanner(.error, message: String(localized:"Model") + " " + String(localized:"field can't be blank"))
        } else if (vehicleColor.trim().count == 0) {
            BannerHelper.displayBanner(.error, message: String(localized:"Color") + " " + String(localized:"field can't be blank"))
        } else if (vehicleYear.trim().count == 0) {
            BannerHelper.displayBanner(.error, message: String(localized:"Year") + " " + String(localized:"field can't be blank"))
        } else if (vehicleLicensePlate.trim().count == 0) {
            BannerHelper.displayBanner(.error, message: String(localized:"Vehicle license plate") + " " + String(localized:"field can't be blank"))
        } else if (Utils.convertImageToData(vehicleImage) == nil) {
            BannerHelper.displayBanner(.error, message: String(localized:"Vehicle image") + " " + String(localized:"field can't be blank"))
        } else {
            
            let request = UpdateCarInfoRequests(make: vehicleMake.trim(),
                                                model: vehicleModel.trim(),
                                                registrationNumber: vehicleLicensePlate.trim(),
                                                year: vehicleYear.trim(),
                                                color: vehicleColor.trim(),
                                                carPhoto: (Utils.convertImageToData(vehicleImage))!)
            SwiftLoader.show(title: String(localized:"Updating..."), animated: true)
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
            BannerHelper.displayBanner(.error, message: String(localized:"Make") + " " + String(localized:"field can't be blank"))
        } else if (vehicleModel.trim().count == 0) {
            BannerHelper.displayBanner(.error, message: String(localized:"Model") + " " + String(localized:"field can't be blank"))
        } else if (vehicleColor.trim().count == 0) {
            BannerHelper.displayBanner(.error, message: String(localized:"Color") + " " + String(localized:"field can't be blank"))
        } else if (vehicleYear.trim().count == 0) {
            BannerHelper.displayBanner(.error, message: String(localized:"Year") + " " + String(localized:"field can't be blank"))
        } else if (vehicleLicensePlate.trim().count == 0) {
            BannerHelper.displayBanner(.error, message: String(localized:"Vehicle license plate") + " " + String(localized:"field can't be blank"))
        } else if (Utils.convertImageToData(vehicleImage) == nil) {
            BannerHelper.displayBanner(.error, message: String(localized:"Vehicle image") + " " + String(localized:"field can't be blank"))
        } else if (Utils.convertImageToData(drivingLicenseImage) == nil) {
            BannerHelper.displayBanner(.error, message:  String(localized:"License") + " " + String(localized:"field can't be blank"))
        } else {
            
            let request = UpdateCarInfoRequests(make: vehicleMake.trim(),
                                                model: vehicleModel.trim(),
                                                registrationNumber: vehicleColor.trim(),
                                                year: vehicleYear.trim(),
                                                color: vehicleLicensePlate.trim(),
                                                carPhoto: Utils.convertImageToData(vehicleImage),
                                                driverLicense: Utils.convertImageToData(drivingLicenseImage))
            SwiftLoader.show(title: String(localized:"Requesting..."), animated: true)
            self.repository.becomeDriver(request: request) {  result in
                SwiftLoader.hide()
                switch result {
                case .success(let response):
                    if response.data.success {
                        self.dismiss = true
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
