//
//  FAQViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-24.
//
import Foundation

class FAQViewModel: ObservableObject {
    var faqArray: [FAQ] = []
    @Published var expandedCells: Set<Int> = []
    init() {
        let faq1 = FAQ(title: "How does Trooute ensure user safety?", details: "Trooute prioritizes user safety by implementing features such as user ratings, reviews, and optional verification badges. We encourage users to provide feedback on their experiences to maintain a safe and reliable community.")
        let faq2 = FAQ(title: "Can I cancel a ride, and what is the cancellation policy?", details: "Yes, you can cancel a ride. However, It\'s important to review and understand our cancellation terms and conditions  before confirming a ride")
        let faq3 = FAQ(title: "What happens in the event of an accident or damage during a ride?", details: "Users (both drivers and passengers) are solely responsible for any accidents or damages that may occur during a ride. Trooute assumes no liability for such incidents. Users are encouraged to report any issues promptly through our support channels")
        let faq4 = FAQ(title: "Is my personal information secure on Trooute?", details: "We take the security of user information seriously. Trooute employs industry-standard security measures to protect user data. For more details, please refer to our Privacy Policy")
        let faq5 = FAQ(title: "Can I choose my travel companions based on preferences?", details: "Yes, allows users to set preferences, such as music preferences, smoking/non-smoking preferences, and other travel-related preferences. This information can help you find compatible travel companions")
        let faq6 = FAQ(title: "How can I contact customer support?", details: "For any inquiries or assistance, you can reach our customer support team at support@trooute.com. We are here to help with any questions or concerns you may have.")
        self.faqArray.append(contentsOf: [faq1,faq2,faq3,faq4,faq5,faq6])
    }
}
