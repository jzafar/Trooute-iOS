//
//  UserInfoCardViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-28.
//

import Foundation
import UIKit

class UserInfoCardViewModel: ObservableObject {
    let user: UserProfile
    @Published var showUserContact: Bool = false
    @Published var showChatScreen = false
    var showReviews = false
    @Published var tripData: TripsData? = nil
    init(user: UserProfile, showUserContact: Bool = false, showReviews: Bool = false, tripData: TripsData? = nil) {
        self.user = user
        self.showUserContact = showUserContact
        self.showReviews = showReviews
        self.tripData = tripData
    }
    
    var photo: String {
        return "\(Constants.baseImageUrl)/\(user.photo ?? "")"
    }
    
    var name: String {
        return self.user.name
    }
    
    var gender: String {
        return self.user.gender ?? "Not provided"
    }
    
    var avgRating: Float {
        if let driver = user as? Driver {
            return driver.reviewsStats?.avgRating ?? 0.0
        } else if let user = user as? User {
            return user.reviewsStats?.avgRating ?? 0.0
        }
        return 0.0
    }
    
    
    var totalReviews: String {
        if let driver = user as? Driver {
            return "(\(driver.reviewsStats?.totalReviews ?? 0))"
        } else if let user = user as? User {
            return "(\(user.reviewsStats?.totalReviews ?? 0))"
        }
        return "0"
        
    }
    
    func phoneCall() {
        let tel = "tel://"
        var num = ""
        if let driver = user as? Driver,
           let phoneNumber = driver.phoneNumber {
            num = phoneNumber
        } else if let user = user as? User,
            let phoneNumber = user.phoneNumber {
            num = phoneNumber
        }
       
        let formattedString = tel + num
        guard let url = URL(string: formattedString) else { return }
        UIApplication.shared.open(url)
    }
    
}
