//
//  CameraViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-11-21.
//
import Combine
import AVFoundation
import SwiftUI

final class CameraViewModel: ObservableObject {
    private let service = CameraService()
    @Published var photo: Photo!
    @Published var showAlertError = false
    @Published var isFlashOn = false
    @Published var willCapturePhoto = false
    @Published var picTaken = false
    var alertError: AlertError!
    var session: AVCaptureSession
    private var subscriptions = Set<AnyCancellable>()
    @Binding var selectedImage: Image?
    init(selectedImage: Binding<Image?>) {
        self.session = service.session
        _selectedImage = selectedImage
        service.$photo.sink { [weak self] (photo) in
            guard let pic = photo else { return }
            if let image =   pic.image {
                self?.selectedImage = Image(uiImage: image)
            }
            self?.picTaken = true
            self?.photo = pic
            
        }
        .store(in: &self.subscriptions)
        
        service.$shouldShowAlertView.sink { [weak self] (val) in
            self?.alertError = self?.service.alertError
            self?.showAlertError = val
        }
        .store(in: &self.subscriptions)
        
        service.$flashMode.sink { [weak self] (mode) in
            self?.isFlashOn = mode == .on
        }
        .store(in: &self.subscriptions)
        
        service.$willCapturePhoto.sink { [weak self] (val) in
            self?.willCapturePhoto = val
        }
        .store(in: &self.subscriptions)
    }
    
    func configure() {
        service.checkForPermissions()
        service.configure()
    }
    
    func capturePhoto() {
        service.capturePhoto()
    }
    
    func flipCamera() {
        service.changeCamera()
    }
    
    func zoom(with factor: CGFloat) {
        service.set(zoom: factor)
    }
    
    func switchFlash() {
        service.flashMode = service.flashMode == .on ? .off : .on
    }
}
