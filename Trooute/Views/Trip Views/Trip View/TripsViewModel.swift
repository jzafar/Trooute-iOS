//
//  TripsViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-25.
//

import CoreLocation
import Foundation
import SwiftUI

class TripsViewModel: NSObject, ObservableObject {
    @Published var fromLocation: String = ""
    @Published var toLocation: String = ""
    @Published var distanceFrom: Double = 2
    @Published var distanceTo: Double = 2
    @Published var date: Date? = nil
    @Published var isDatePickerPresented: Bool = false
    @Published var isFlexibleDate: Bool = false
    @Published var flexibleDays: Int = 1

    @Published var showFloatingDistanceForFrom: Bool = false
    @Published var showFloatingDistanceForTo: Bool = false
    @Published var sheetHeight: CGFloat = .zero

    @Published var driverTrips: [TripInfo] = []
    @Published var nearByTrips: [TripsData] = []
    @Published var fromAddressInfo: SearchedLocation? = nil
    @Published var whereToAddressInfo: SearchedLocation? = nil
    @Published var addressInfoErrorAlert = false
    @AppStorage(UserDefaultsKey.user.key) var user: User?
    private let locationManager = CLLocationManager()
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined
    private var lastKnownLocation: CLLocationCoordinate2D?
    var errorTitle = ""
    var errorMessage = ""
    
    private var repository = TripRepository()
    
    func fetchTrips() {
        if user?.driverMode == true {
            if let tripResponse = MockDate.getDriverTripsList() {
                if tripResponse.success == true,
                   let trips = tripResponse.data {
                    driverTrips = trips.reversed()
                    nearByTrips = []
                }
            }
        } else {
            if let coordinates = locationManager.location?.coordinate {
                let request = GetTripsRequest(fromLatitude: coordinates.latitude, fromLongitude: coordinates.longitude, currentDate: Date().shotFormate())
                
                self.repository.getNearByTrips(request: request) { [weak self] result in
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
            }
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
        self.fetchTrips()
    }
}
