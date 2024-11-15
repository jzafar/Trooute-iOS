//
//  EmailController.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-27.
//

import Foundation
import MessageUI

class EmailController: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = EmailController()
    private override init() { }
    
    func sendEmail(subject:String, body:String, to:String){
        if !MFMailComposeViewController.canSendMail() {
            BannerHelper.displayBanner(.info, message: String(localized:"Your email is not configured. Please configuere your email to report an issue."))
            return
        }
        // Create the email composer
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients([to])
        mailComposer.setSubject(subject)
        mailComposer.setMessageBody(body, isHTML: false)
        Utils.getRootViewController()?.present(mailComposer, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        Utils.getRootViewController()?.dismiss(animated: true, completion: nil)
    }
    
}
