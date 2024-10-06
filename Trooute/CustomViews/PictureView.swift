//
//  PictureView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-06.
//

import SwiftUI
import PhotosUI
struct PictureView: View {
    @Binding var image: Image?
    var placeholderText: String
    @State private var showActionSheet: Bool = false
    @State private var isShowingPhotoPicker = false
    @State private var isShowingCameraPicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    var body: some View {
        ZStack {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
                    .cornerRadius(8)
            } else {
                VStack {
                    Image(systemName: "photo.on.rectangle.angled")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                    Text(placeholderText)
                        .foregroundColor(.blue)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
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
