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
    init(url: String, adjustFont: Bool = false) {
        self.url = url
        self.adjustFont = adjustFont
    }
    
    
    func paymentSuccess(url: String) {
        SwiftLoader.show(title: "Loading...", animated: true)
        repo.paymentSuccess(url: url) { [weak self] result in
            SwiftLoader.hide()
            switch result {
            case .success(let resposne):
                if resposne.data.success {
                    BannerHelper.displayBanner(.success, message: resposne.data.message)
                    self?.shouldGoBack = true
                }
            case .failure(let failure):
                BannerHelper.displayBanner(.error, message: failure.localizedDescription)
            }
        }
    }
}
