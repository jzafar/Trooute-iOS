//
//  UserInfoCardViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-28.
//

import Foundation

class UserInfoCardViewModel: ObservableObject {
    let user: UserProfile
    @Published var showUserContact: Bool = false
    init(user: UserProfile, showUserContact: Bool = false) {
        self.user = user
        self.showUserContact = showUserContact
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
        if let driver = user as? Driver {
            print(driver.phoneNumber)
        } else if let user = user as? User {
            print(user.phoneNumber)
        }
    }
    
}
