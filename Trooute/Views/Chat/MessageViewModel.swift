//
//  MessageViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-11-01.
//
import Foundation
import SwiftUI

class MessageViewModel: ObservableObject {
    @Published var FBVM: FirebaseViewModel
    @Published var newMessage: String = ""
    @Published var textEditorHeight: CGFloat = 40
    @Published var isKeyboardVisible = false

    private var currentUser = UserUtils.shared
    var messageReceiverInfo: ChatUser
    init(viewModel: FirebaseViewModel, messageReceiverInfo: ChatUser) {
        self.FBVM = viewModel
        self.messageReceiverInfo = messageReceiverInfo
    }
    
    func getMessages() {
        if let current = currentUser.user?.id {
            FBVM.getAllMessages(senderId: current, receiverId: messageReceiverInfo.id)
            self.markAsRead()
        }
    }
    
    func sendMessage() {
        if newMessage.trim().count == 0 {
            return
        }
        let cUser = ChatUser(id: currentUser.user!.id, name: currentUser.user!.name, photo: currentUser.user!.photo, seen: true)
        let receiver = ChatUser(id: messageReceiverInfo.id, name: messageReceiverInfo.name, photo: messageReceiverInfo.photo, seen: false)
        let inbox = Inbox(id: "\(UUID())", user: receiver, lastMessage: newMessage.trim(), timestamp: Date().timeIntervalSince1970)
        let message = Message(id: "\(UUID())", senderId: self.currentUser.user!.id, message: newMessage.trim(), timestamp:  Date().timeIntervalSince1970)
        FBVM.sendMessage(currentUser: cUser, inbox: inbox, message: message) { [weak self] error in
            if let err = error {
                BannerHelper.displayBanner(.error, message: err.localizedDescription)
            } else {
                self?.newMessage = ""
            }
        }
    }
    
    func markAsRead() {
        if let currentUserId = currentUser.user?.id {
            FBVM.updateSeenStatus(currentUID: currentUserId, receiverID: messageReceiverInfo.id, isSeen: true) { error in
                
            }
        }
    }
        
    func adjustTextEditorHeight() {
        let maxHeight: CGFloat = 120
        let fixedWidth: CGFloat = UIScreen.main.bounds.width - 100 // Adjust based on other padding
        
        let size = CGSize(width: fixedWidth, height: .infinity)
        let estimatedSize = newMessage.boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.systemFont(ofSize: 16)],
            context: nil
        )
        
        textEditorHeight = min(maxHeight, max(40, estimatedSize.height + 20))
    }
}
