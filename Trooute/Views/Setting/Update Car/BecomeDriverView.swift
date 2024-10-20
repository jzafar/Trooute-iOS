//
//  UpdateCarInfoView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-04.
//

import PhotosUI
import SwiftUI

struct BecomeDriverView: View {
    @StateObject var viewModel: BecomeDriverViewModel
    @StateObject var userModel = UserUtils.shared
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: 16) {
                        SectionView(title: "Upload Vehicle Photo") {
                            PictureView(image: $viewModel.vehicleImage, placeholderText: "Click to upload photo")
                        }

                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 16) {
                                CustomTextField(title: "Make", placeholder: "Honda", text: $viewModel.vehicleMake)
                                CustomDropdownField(title: "Year", placeholder: "Select Year", options: viewModel.years, selectedValue: $viewModel.vehicleYear)
                            }

                            VStack(alignment: .leading, spacing: 16) {
                                CustomTextField(title: "Model", placeholder: "Civic 1.8", text: $viewModel.vehicleModel)
                                CustomDropdownField(title: "Color", placeholder: "Select Color", options: viewModel.colors, selectedValue: $viewModel.vehicleColor)
                            }
                        }

                        CustomTextField(title: "Vehicle License Plate", placeholder: "AFK 235", text: $viewModel.vehicleLicensePlate)
                        if viewModel.carDetails == nil {
                            SectionView(title: "Upload Driving License", description: "Ensure your driving license is clear and visible.") {
                                PictureView(image: $viewModel.drivingLicenseImage, placeholderText: "Click to upload photo")
                            }
                        }
                        

                        
                    }
                    .padding()
                }
                .safeAreaInset(edge: .bottom) {
                    PrimaryGreenButton(title: (viewModel.carDetails == nil) ? "Submit Request" : "Update") {
                        if userModel.driverStatus == .approved {
                            viewModel.updateCarInfo()
                        } else {
                            viewModel.becomeADriver()
                        }
                    }.padding()
                }
            }
            .navigationTitle((viewModel.carDetails == nil) ? "Become a driver" : "Update car Info")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    XMarkButton {
                        dismiss()
                    }.padding()
                }
            }
        }
    }
}

struct SectionView<Content: View>: View {
    var title: String
    var description: String? = nil
    let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            if let description = description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            content()
        }
    }
}

struct CustomTextField: View {
    var title: String
    var placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)

            TextField(placeholder, text: $text)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
    }
}

// Preview
struct BecomeDriverView_Previews: PreviewProvider {
    static var previews: some View {
        BecomeDriverView(viewModel: BecomeDriverViewModel(carDetails: nil))
    }
}
