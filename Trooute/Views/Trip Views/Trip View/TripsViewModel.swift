//
//  TripsViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-25.
//

import CoreLocation
import Foundation
import SwiftUI
import SwiftLoader

class TripsViewModel: NSObject, ObservableObject {
    @Published var fromLocation: String = ""
    @Published var toLocation: String = ""
    @Published var distanceFrom: Double = 5
    @Published var distanceTo: Double = 5
    @Published var date: Date? = nil
    @Published var isDatePickerPresented: Bool = false
    @Published var isFlexibleDate: Bool = false
    @Published var flexibleDays: Int = 1

    @Published var showFloatingDistanceForFrom: Bool = false
    @Published var showFloatingDistanceForTo: Bool = false
    @Published var showSearchTrips: Bool = false

    @Published var driverTrips: [TripInfo] = []
    @Published var nearByTrips: [TripsData] = []
    @Published var fromAddressInfo: SearchedLocation? = nil
    @Published var whereToAddressInfo: SearchedLocation? = nil
    var searchTripsResult: [TripsData] = []
    private var userModel = UserUtils.shared
    private let locationManager = CLLocationManager()
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined
    private var lastKnownLocation: CLLocationCoordinate2D?
    
    private var repository = TripRepository()
    
    func onAppear() {
        fromAddressInfo = nil
        whereToAddressInfo = nil
        driverTrips = []
        nearByTrips = []
        date = nil
        fromLocation = ""
        toLocation = ""
        distanceFrom = 5
        distanceTo = 5
        flexibleDays = 1
        isFlexibleDate = false
        self.checkLocationAuthorization()
        self.fetchTrips()
    }
    
    func fetchTrips() {
        if userModel.driverMode == true {
            let request = GetTripsRequest(departureDate: Date().shotFormate())
            self.repository.getDriverTrips(request: request) { [weak self] result in
                switch result {
                case .success(let response):
                    if response.data.success,
                       let trips = response.data.data {
                        self?.nearByTrips = []
                        self?.driverTrips = trips.reversed()
                    }
                        
                case .failure(let error):
                    log.error("failed to get me \(error.localizedDescription)")
                }
            }
            
        } else {
//            let coordinates = locationManager.location?.coordinate
            let request = GetTripsRequest(fromLatitude: locationManager.location?.coordinate.latitude, fromLongitude: locationManager.location?.coordinate.longitude, currentDate: Date().shotFormate())
                
                self.repository.getTrips(request: request) { [weak self] result in
                    switch result {
                    case .success(let response):
                        if response.data.success,
                           let trips = response.data.data {
                            self?.nearByTrips = trips.reversed()
                            self?.driverTrips = []
                            
                        }
                            
                    case .failure(let error):
                        log.error("failed to get me \(error.localizedDescription)")
                    }
                }
//            }
        }
    }

    func getUserImage(_ photo: String?) -> String {
        return "\(Constants.baseImageUrl)/\(photo ?? "")"
    }

    func showErrorAlert() {
        BannerHelper.displayBanner(.error, message: "App could not get coordinates of this location. Please choose some other location or try again")
    }

    func checkLocationAuthorization() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        case .restricted:
            print("Location restricted")

        case .denied:
            print("Location denied")

        case .authorizedAlways:
            print("Location authorizedAlways")

        case .authorizedWhenInUse:
            print("Location authorized when in use")
            lastKnownLocation = locationManager.location?.coordinate

        @unknown default:
            print("Location service disabled")
        }
    }
    
    func seekOutTrip() {
        guard let fromAddressInfo = fromAddressInfo else {
            BannerHelper.displayBanner(.info, message: "From location field can't be blank")
            return
        }
        
        guard let whereToAddressInfo = whereToAddressInfo else {
            BannerHelper.displayBanner(.info, message: "Where to location field can't be blank")
            return
        }
        
        let request = GetTripsRequest(fromLatitude: fromAddressInfo.coordinate.latitude,
                                      fromLongitude: fromAddressInfo.coordinate.longitude,
                                      whereLatitude: whereToAddressInfo.coordinate.longitude,
                                      whereLongitude: whereToAddressInfo.coordinate.latitude,
                                      currentDate: date != nil ? date?.shotFormate() : Date().shotFormate(),
                                      flexibleDays: isFlexibleDate ? flexibleDays : nil,
                                      toRange: Int(distanceTo),
                                      fromRange: Int(distanceFrom))
        SwiftLoader.show(title: "Searching...", animated: true)
        repository.getTrips(request: request) { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case .success(let resposne):
                if resposne.data.success {
                    if let trips = resposne.data.data {
                        if trips.count == 0 {
                            BannerHelper.displayBanner(.info, message: "No trip found")
                        } else {
                            self?.searchTripsResult = trips
                            self?.showSearchTrips = true
                        }
                    }
                }
            case .failure(let failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }
        }
    }
}

extension TripsViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorisationStatus = status
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.lastKnownLocation = locations.first?.coordinate
        if userModel.driverMode == false {
            self.fetchTrips()
        }
    }
}
