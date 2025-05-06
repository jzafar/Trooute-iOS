//
//  BookingDetailsViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-29.
//

import Foundation
import SwiftLoader
import SwiftUI
import PayPalCheckout

class BookingDetailsViewModel: ObservableObject {
    private var bookingId: String
    @Published var bookingData: BookingData? {
        didSet {
            setDepartureDate()
            handCarryWeight = getHandCarryWeight()
            suitcaseWeight = getSuitcaseWeight()
            bookingID = String(localized: "Booking # \(bookingId.firstTenCharacters())")
            finalPrice = getFinalPrice()
        }
    }

    @Published var status: BookingStatus = .waiting
    @Published var departureDate = ""
    @Published var availableSeats = ""
    @Published var bookingID: String? = ""
    @Published var showPaymentsScreen = false
    @Published var suitcaseWeight = String(localized: "Not provided")
    @Published var handCarryWeight = String(localized: "Not provided")
    @Published var popView = false
    @Published var passgenerId: String?
    @Published var finalPrice: Double = 0.0
    @Published var currentBooking: Booking? = nil
    @Published var showPaymentsActionSheet = false
    @Published var selectedPaymentMethod: PaymentMethod?
    let user = UserUtils.shared
    private let repository = BookingDetailsRepository()
    private let notification = Notifications()
    private var paymentUrl: String?
    private var timer: Timer?
    init(bookingId: String) {
        self.bookingId = bookingId
    }

    func getBookingDetails() {
        SwiftLoader.show(title: String(localized: "Loading..."), animated: true)
        repository.getBookingDetails(bookingId: bookingId) { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case let .success(response):
                if response.data.success,
                   let bookingData = response.data.data {
                    self?.bookingData = bookingData
                    self?.status = bookingData.status ?? .waiting
                    self?.availableSeats = "\(bookingData.numberOfSeats ?? 0)"
                    self?.checkPickupStatus()
                } else {
                    BannerHelper.displayBanner(.error, message: response.data.message)
                }
            case let .failure(failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }
        }
    }

    func checkPickupStatus() {
        if !user.driverMode &&
            bookingData?.trip.status == .PickupStarted &&
            bookingData?.status == .confirmed {
            if let tripId = bookingData?.trip.id {
                getPickUpStatus(tripId: tripId)
            }
            startTimer()
        }
    }

    func getDriverMode() -> Bool {
        return user.driverMode
    }

    func bookPrice() -> Double {
        if let price = bookingData?.trip.pricePerPerson {
            return price * Double(bookingData?.numberOfSeats ?? 0)
        }
        return 0.0
    }

    func getFinalPrice() -> Double {
        if user.driverMode { // Details from tabbar booking -> booking details
            let pricePerPerson = bookingData?.trip.pricePerPerson ?? 0.0
            let numberOfSeats = Double(bookingData?.numberOfSeats ?? 0)
            let price = (pricePerPerson * numberOfSeats) - numberOfSeats
            return price
        } else {
            return bookingData?.amount ?? 0.0
        }
    }

    func setDepartureDate() {
        departureDate = bookingData?.trip.departureDate.fullFormate() ?? bookingData?.trip.departureDate ?? "Unknown"
    }

    func getStatu(_ driverMode: Bool) -> (Image, String) {
        return Utils.checkStatus(isDriverApproved: driverMode, status: status)
    }

    func getHandCarryWeight() -> String {
        if let handCarryLuggage = bookingData?.trip.luggageRestrictions?.compactMap({ $0 }).filter({ $0.type == .handCarry }).first,
           let weight = handCarryLuggage.weight {
            return "\(weight) KG"
        }

        return "Not Provided"
    }

    func getSuitcaseWeight() -> String {
        if let handCarryLuggage = bookingData?.trip.luggageRestrictions?.compactMap({ $0 }).filter({ $0.type == .suitCase }).first,
           let weight = handCarryLuggage.weight {
            return "\(weight) KG"
        }

        return "Not Provided"
    }

    var smokingPreference: String {
        return bookingData?.trip.smokingPreference ?? false ? String(localized: "Yes") : String(localized: "No")
    }

    var petPreference: String {
        return bookingData?.trip.petPreference ?? false ? String(localized: "Yes") : String(localized: "No")
    }

    var languagePreference: String {
        return bookingData?.trip.languagePreference ?? String(localized: "Not Provided")
    }

    var otherReliventDetails: String {
        return bookingData?.trip.note.emptyOrNil ?? String(localized: "Not Provided")
    }

    func getDestinationModel() -> TripRouteModel? {
        if let fromAddress = bookingData?.trip.fromAddress,
           let whereToAddress = bookingData?.trip.whereToAddress,
           let departureDate = bookingData?.trip.departureDate {
            return TripRouteModel(fromAddress: fromAddress, whereToAddress: whereToAddress, date: departureDate)
        }
        return nil
    }

    func getStatusText(isDriver: Bool, status: BookingStatus) -> String {
        var str = ""
        if isDriver {
            if status == .waiting {
                str = String(localized: "Passenger is waiting for your response.")
            } else if status == .approved {
                str = String(localized: "We are waiting for payments.")
            } else if status == .confirmed {
                str = String(localized: "This booking is now confirmed! Anticipate the upcomming trip day.")
            } else if status == .canceled {
                str = String(localized: "Booking canceled. We're Sorry for the Inconvenience.")
            }
        } else {
            if status == .waiting {
                str = String(localized: "We’ll notify you as soon as your booking is confirmed.")
            } else if status == .approved {
                str = String(localized: "Your booking is approved! Please proceed with payment to confirm.")
            } else if status == .confirmed {
                str = String(localized: "Your booking is now confirmed! Anticipate the upcoming trip day.")
            } else if status == .canceled {
                str = String(localized: "Booking canceled. We're Sorry for the Inconvenience.")
            }
        }
        return str
    }

    func makePayments() {
        showPaymentsActionSheet.toggle()
        /*
         SwiftLoader.show(title: String(localized:"Loading..."),animated: true)
         repository.confirmBooking(bookingId: self.bookingId) { [weak self] result in
             SwiftLoader.hide()
             switch result {
             case .success(let response):
                 if response.data.success,
                    let url = response.data.url {
                     self?.paymentUrl = url
                     self?.showPaymentsScreen = true
                     print(url)
                 } else {
                     BannerHelper.displayBanner(.error, message: response.data.message)
                 }
             case .failure(let failure):
                 BannerHelper.displayBanner(.error, message: failure.localizedDescription)
             }
         }
          */
    }

    func processPayment(with method: PaymentMethod) {
        print("Processing payment with: \(method.rawValue)")
        // Add your payment processing logic here
        switch method {
        case .cash:
            // Handle cash payment
            break
        case .paypal:
            startPayPalPayment()
            break
        case .card:
            // Handle card payment
            break
        }
    }

    
    func startPayPalPayment() {
        let currency: CurrencyCode = .eur
        let amount = "10"
        Checkout.start(
            createOrder: { createOrderAction in
                let amount = PurchaseUnit.Amount(currencyCode: currency, value: amount)
                let purchaseUnit = PurchaseUnit(amount: amount)
                let order = OrderRequest(intent: .capture, purchaseUnits: [purchaseUnit])
                createOrderAction.create(order: order)
            },
            onApprove: { approval in
                approval.actions.capture { response, error in
                    if let orderID = response?.data.id {
                        print("paymetns success order id \(orderID)")
                    } else if let error = error {
                        print("paypal paymetns error \(error)")
                    }
                }
            },
            onCancel: {
                print("user cancel paymetns")
            },
            onError: { error in
                print("paypal paymetns error \(error)")
            }
        )
    }
    
    func cancelBooking() {
        SwiftLoader.show(animated: true)
        repository.cancelBooking(bookingId: bookingId) { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case let .success(response):
                if response.data.success {
                    BannerHelper.displayBanner(.success, message: response.data.message)
                    guard let self = self else { return }
                    var toId: String?
                    if self.user.driverMode {
                        toId = self.bookingData?.user?.id
                    } else {
                        toId = self.bookingData?.trip.driver?.id
                    }
                    if let id = toId {
                        self.sendNotification(title: String(localized: "Booking canceled"), body: String(localized: "Sorry, Your trip is canceled by "), toId: id) {
                            self.popView = true
                        }

                    } else {
                        self.popView = true
                    }
                } else {
                    BannerHelper.displayBanner(.error, message: response.data.message)
                }
            case let .failure(failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }
        }
    }

    func getWebViewModel() -> WebViewModel {
        return WebViewModel(url: paymentUrl ?? "", makePaymentUserId: bookingData?.trip.driver?.id)
    }

    func acceptBooking() {
        if bookingData?.trip.driver?.stripeConnectedAccountId == nil {
            BannerHelper.displayBanner(.error, message: String(localized: "You can't accept this booking. You must have to connect your stripe account to accept this booking. When we have approved you as a driver, we send you an email to connect your stripe account."))
            return
        }
        SwiftLoader.show(animated: true)
        repository.approveBooking(bookingId: bookingId) { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case let .success(response):
                if response.data.success {
                    self?.getBookingDetails()
                    BannerHelper.displayBanner(.success, message: response.data.message)
                    guard let self = self else { return }
                    var toId: String?
                    if self.user.driverMode {
                        toId = self.bookingData?.user?.id
                    } else {
                        toId = self.bookingData?.trip.driver?.id
                    }
                    if let id = toId {
                        self.sendNotification(title: String(localized: "Confirm Booking"), body: String(localized: "Great news, Your trip is all set and accepted by "), toId: id) {}
                    }
                } else {
                    BannerHelper.displayBanner(.error, message: response.data.message)
                }
            case let .failure(failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }
        }
    }

    func onTapPassenger(id: String) {
        passgenerId = id
    }

    func stopTimerIfRunning() {
        timer?.invalidate()
        timer = nil
    }

    func startTimer() {
        if let tripId = bookingData?.trip.id {
            timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { timer in
                print("\(timer)")
                self.getPickUpStatus(tripId: tripId)
            })
        }
    }

    func getPickUpStatus(tripId: String) {
        repository.getPickupStatus(tripId: tripId) { [weak self] result in
            switch result {
            case let .success(response):
                if response.data.success,
                   let tripData = response.data.data {
                    if let booking = tripData.bookings?.first(where: { $0.id == self?.bookingId }) {
                        self?.currentBooking = booking
                    }
                }
            case let .failure(failure):
                log.error("fail to load status \(failure.localizedDescription)")
            }
        }
    }

    func updatePickUpStatus(status: PickUpPassengersStatus) {
        if let tripId = currentBooking?.trip?.id,
           let pickupStatusId = currentBooking?.pickupStatus?.id {
            let requst = UpdatePickupStatusRequest(tripId: tripId, bookingId: bookingId, pickupStatus: status.rawValue, pickupId: pickupStatusId)
            SwiftLoader.show(title: String(localized: "Updating..."), animated: true)
            repository.updatePickupStatus(request: requst) { [weak self] result in
                SwiftLoader.hide()
                switch result {
                case let .success(response):
                    if response.data.success {
                        BannerHelper.displayBanner(.success, message: String(localized: "Status updated successfully"))
                        self?.getPickUpStatus(tripId: tripId)
                    } else {
                        BannerHelper.displayBanner(.error, message: response.data.message)
                    }
                case let .failure(failure):
                    BannerHelper.displayBanner(.error, message: failure.localizedDescription)
                }
            }
        }
    }

    private func sendNotification(title: String, body: String, toId: String, completion: @escaping () -> Void) {
        notification.sendNotification(title: title, body: "\(body) \(user.user?.name ?? "user")", toId: "\(Apis.TOPIC)\(Apis.TROOUTE_TOPIC)\(toId)") { result in
            switch result {
            case let .success(success):
                log.info("Booking details notification send status \(success)")
            case let .failure(failure):
                log.info("Booking details notification fails \(failure.localizedDescription)")
            }
            completion()
        }
    }
}

enum PaymentMethod: String, CaseIterable {
    case cash = "Pay with Cash"
    case paypal = "Pay with PayPal"
    case card = "Card Payment"

    var icon: String {
        switch self {
        case .cash: return "banknote"
        case .paypal: return "p.circle"
        case .card: return "creditcard"
        }
    }
}
