//
//  SharedViews.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-22.
//
import SwiftUI
import PhotosUI
import SDWebImageSwiftUI

struct RoundProfilePictureView: View {
    @EnvironmentObject var userViewModel: SigninViewModel
    @State private var image: Image?
    @State private var showActionSheet: Bool = false
    @State private var isShowingPhotoPicker = false
    @State private var isShowingCameraPicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    let width: CGFloat
    var body: some View {
        ZStack {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .frame(width: width, height: width)
                    .cornerRadius(width/2)
                    .overlay(RoundedRectangle(cornerRadius: width/2).stroke(Color.black, lineWidth: 1))
                    .padding(1)
            } else if let photo = userViewModel.user?.photo {
                WebImage(url: URL(string: photoUrl(photo))) { image in
//                    self.image = Image(uiimage: image.image)
//                        image.resizable()
//                        image.aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image("profile_place_holder")
                            .resizable()
                    }
                    .onSuccess { image, data, cacheType in
                        DispatchQueue.main.async {
                            self.image =  Image(uiImage: image)
                        }
                    }
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .frame(width: width, height: width)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    .padding(5)
                    .padding(.trailing,0)
            } else {
                Button(action: {
                    showActionSheet = true
                }) {
                    Circle().stroke(Color.black, lineWidth: 1)
                        .frame(width: width, height: width)
                        .overlay(
                            Image(systemName: "camera")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                        )
                        .foregroundColor(Color(UIColor.systemGray5))
                }.frame(width: width, height: width)
            }
        }
        .onTapGesture {
            showActionSheet = true
        }
        
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("Select Photo"),
                message: Text("Choose a photo source"),
                buttons: [
                    .default(Text("Photo Library")) {
                        requestPhotoLibraryPermission()
                    },
                    .default(Text("Camera")) {
                        requestCameraPermission()
                    },
                    .cancel(),
                ]
            )
        }
        .photosPicker(isPresented: $isShowingPhotoPicker, selection: Binding(
            get: {
                nil
            }, set: { newValue in
                if let newValue = newValue {
                    Task {
                        do {
                            if let data = try await newValue.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                self.image = Image(uiImage: image)
                            }
                        } catch {
                            print("Error loading image from library: \(error)")
                        }
                    }
                }
            }
        ))
        .sheet(isPresented: $isShowingCameraPicker) {
            CameraView(selectedImage: $image)
        }
        
    }
    
    func photoUrl(_ photo: String) -> String {
        return "\(Constants.baseImageUrl)/\(photo)"
    }
    
    // MARK: - Permission Requests
        private func requestPhotoLibraryPermission() {
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized || status == .limited {
                        isShowingPhotoPicker = true
                    } else {
                        alertMessage = "Please enable photo library access in settings."
                        showAlert = true
                    }
                }
            }
        }

        private func requestCameraPermission() {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        isShowingCameraPicker = true
                    } else {
                        alertMessage = "Please enable camera access in settings."
                        showAlert = true
                    }
                }
            }
        }
}
