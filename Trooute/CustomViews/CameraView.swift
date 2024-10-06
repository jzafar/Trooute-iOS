//
//  CameraView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-06.
//

import SwiftUI
import PhotosUI

struct CameraView: View {
    @Environment(\.dismiss) var dismiss
        @Binding var selectedImage: Image?
        @State private var captureSession: AVCaptureSession? = nil
        @State private var previewLayer: CALayer? = nil
        @State private var showAlert = false

        var body: some View {
            VStack {
                Text("Camera")
                    .font(.headline)
                Button("Capture Photo") {
                    capturePhoto()
                }
                .padding()
            }
            .onAppear {
                setupCamera()
            }
            .onDisappear {
                stopCamera()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Failed to capture photo."), dismissButton: .default(Text("OK")))
            }
        }

        private func setupCamera() {
            let session = AVCaptureSession()
            session.sessionPreset = .photo

            guard let device = AVCaptureDevice.default(for: .video) else {
                showAlert = true
                return
            }
            do {
                let input = try AVCaptureDeviceInput(device: device)
                session.addInput(input)

                let preview = AVCaptureVideoPreviewLayer(session: session)
                preview.videoGravity = .resizeAspectFill
                previewLayer = preview

                captureSession = session
                session.startRunning()
            } catch {
                showAlert = true
            }
        }

        private func capturePhoto() {
            guard let captureSession = captureSession else { return }

            let output = AVCapturePhotoOutput()
            captureSession.addOutput(output)
            let settings = AVCapturePhotoSettings()
            output.capturePhoto(with: settings, delegate: PhotoCaptureDelegate { image in
                if let img = image {
                    selectedImage = Image(uiImage: img)
                }
                dismiss()
            })
        }

        private func stopCamera() {
            captureSession?.stopRunning()
            previewLayer?.removeFromSuperlayer()
        }
}

// MARK: - Photo Capture Delegate
final class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    private let completion: (UIImage?) -> Void

    init(completion: @escaping (UIImage?) -> Void) {
        self.completion = completion
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let data = photo.fileDataRepresentation(),
           let image = UIImage(data: data) {
            completion(image)
        } else {
            completion(nil)
        }
    }
}
