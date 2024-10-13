//
//  Banner.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-12.
//

import Foundation
import BRYXBanner
import UIKit
class BannerHelper {
    private struct BannerLayout {
        let type: BannerType
        let title: String?
        let duration: UInt32
        let color: UIColor
        let image: UIImage
        let rightImage: UIImage?
    }
    private static let greenColor = UIColor.systemGreen
    private static let successLayout = BannerLayout(type: .success, title: nil, duration: 5, color:greenColor , image: #imageLiteral(resourceName: "check"), rightImage: nil)
    
    private static let redColor = UIColor.systemRed
    private static let errorLayout = BannerLayout(type: .error, title: "Error", duration: 0, color: redColor, image: #imageLiteral(resourceName: "exclamation"), rightImage: #imageLiteral(resourceName: "ic_close"))
    private static let yellowColor = UIColor.systemYellow
    private static let infoLayout = BannerLayout(type: .info, title: "Information", duration: 0, color: yellowColor, image: #imageLiteral(resourceName: "exclamation"), rightImage: #imageLiteral(resourceName: "ic_close"))

    private static var successBanner: Banner?
    private static var errorBanner: Banner?
    private static var infoBanner: Banner?

    class func hideBanner() {
        successBanner?.dismiss()
        errorBanner?.dismiss()
        infoBanner?.dismiss()
    }
    class func displayBanner(_ type: BannerType, message: String, file: String = #file, function: String = #function, line: Int = #line) {
        
        if message.isEmpty {
            return
        }
        
        let filename = file.components(separatedBy: "/").last?.replace(".swift", withString: "", caseSensitive: false) ?? file
        log.debug("display banner of type: \(type), with message: \(message), from file: \(filename), function: \(function), and line: \(line)")
        
        switch type {
        case .error:
            displayToastBannerOnMain(message: message, layout: errorLayout)
        case .info:
            displayToastBannerOnMain(message: message, layout: infoLayout)
        case .success:
            displayToastBannerOnMain(message: message, layout: successLayout)
        }
    }
    
    private class func displayToastBannerOnMain(message: String?, layout: BannerLayout) {
        DispatchQueue.main.async {
            displayToastBanner(message: message, layout: layout)
        }
    }
    
    private class func displayToastBanner(message: String?, layout: BannerLayout) {

        let toastBanner = Banner(title: layout.title, subtitle: message, image: layout.image, backgroundColor: layout.color)
        toastBanner.minimumHeight = 70
        toastBanner.position = .bottom
        toastBanner.dismissesOnTap = true
        toastBanner.dismissesOnSwipe = true
        toastBanner.titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        toastBanner.detailLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        toastBanner.shouldTintImage = true
        toastBanner.detailLabel.isAccessibilityElement = true

        switch layout.type {
        case .success:
            successBanner?.dismiss()
            successBanner = toastBanner
        case .error:
            errorBanner?.dismiss()
            errorBanner = toastBanner
        case .info:
            infoBanner?.dismiss()
            infoBanner = toastBanner
        }
        
        toastBanner.show()
        
        if layout.duration > 0 {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                sleep(layout.duration)
                
                OperationQueue.main.addOperation {
                    toastBanner.dismiss()
                }
            }
        }
    }
}

enum BannerType {
    case success
    case error
    case info
}
