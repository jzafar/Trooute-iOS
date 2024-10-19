//
//  UpdateProfileViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-22.
//
import SwiftUI
import SwiftLoader

class UpdateProfileViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var phoneNumber = ""
    @Published var updatePassword = false
    @Published var useImage: Image? = nil
    @Published var email = ""
    private let repository = UpdateProfileRepository()
    @AppStorage(UserDefaultsKey.user.key) var user: User?
    func updateProfile() {
        if fullName.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
           BannerHelper.displayBanner(.error, message: "Full Name feild can\'t be blank")
       } else if phoneNumber.count == 0 {
           BannerHelper.displayBanner(.error, message: "Phone number is not correct")
       } else {
           SwiftLoader.show(title: "Updating...", animated: true)
           repository.updateMe(request: UpdateProfileRequest(name: fullName, phoneNumber: phoneNumber, photo: Utils.convertImageToData(self.useImage))) { [weak self] result in
               SwiftLoader.hide()
               switch result {
               case .success(let response):
                   if response.data.success,
                      let user = response.data.data {
                       self?.user = user
                       self?.useImage = nil
                       BannerHelper.displayBanner(.success, message: "Profile updated")
                   } else {
                       BannerHelper.displayBanner(.error, message:  response.data.message)
                   }
               case .failure(let error):
                   BannerHelper.displayBanner(.error, message:  error.localizedDescription)
               }
           }
       }
    }
    
    func loadData() {
        if let user = self.user {
            self.fullName = user.name
            self.phoneNumber = user.phoneNumber ?? ""
            self.useImage = nil
            self.email = user.email ?? ""
        }
    }
}
