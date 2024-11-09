//
//  WebViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-01.
//
import Foundation
import SwiftLoader

class WebViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var canGoBack: Bool = false
    @Published var shouldGoBack: Bool = false
    @Published var title: String = ""
    var url: String
    var adjustFont = false
    let repo = WebViewRepository()
    private let notification = Notifications()
    let makePaymentUserId: String?
    init(url: String, adjustFont: Bool = false, makePaymentUserId: String? = nil) {
        self.url = url
        self.adjustFont = adjustFont
        self.makePaymentUserId = makePaymentUserId
    }
    
    
    func paymentSuccess(url: String) {
        SwiftLoader.show(title: "Loading...", animated: true)
        repo.paymentSuccess(url: url) { [weak self] result in
            SwiftLoader.hide()
            guard let self = self else {return}
            switch result {
            case .success(let resposne):
                if resposne.data.success {
                    BannerHelper.displayBanner(.success, message: resposne.data.message)
                    if let user = UserUtils.shared.user,
                       let makePaymentUserId = self.makePaymentUserId {
                        let body = "Get ready for an amazing journey, Payment received for your trip from \(user.name)"
                        let toId = "\(Apis.TOPIC)\(Apis.TROOUTE_TOPIC)\(makePaymentUserId)"
                        self.notification.sendNotification(title: "Booking payment", body: body, toId: toId) { result1 in
                            switch result1 {
                            case .success(let success):
                                log.info("make payment notification send")
                            case .failure(let failure1):
                                log.error("make payment notification faile \(failure1.localizedDescription)")
                            }
                            self.shouldGoBack = true
                        }
                    } else {
                        self.shouldGoBack = true
                    }
                }
            case .failure(let failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }
        }
    }
    
}
