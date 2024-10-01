//
//  WishViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-01.
//
import Foundation
class WishViewModel: ObservableObject {
    @Published var wishList: [TripInfo] = []
    
    func getWishList() {
        if let bookingResponse = MockDate.getWishList() {
            if bookingResponse.success {
                self.wishList = bookingResponse.data!
            }
        }
    }
}
