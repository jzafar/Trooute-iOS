//
//  FirebaseViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-31.
//

// import FirebaseFirestoreSwift
import Combine
import FirebaseFirestore
//TODO: fix this for inbox and messages view by adding listener
class FirebaseViewModel: ObservableObject {
    private let inboxCollection = Firestore.firestore().collection("TroouteInbox")
    private var userModel = UserUtils.shared
    // Publishers for inbox and messages
    @Published var inbox: [Inbox] = []
    @Published var messages: [Message] = []
    var listener: ListenerRegistration?
    private let notification = Notifications()
//    init() {
//        if let userId = userModel.user?.id {
//            getAllInbox(userId: userId)
//        }
//    }

    // MARK: - Fetch Inbox

    func getAllInbox(userId: String) {
        inboxCollection
            .whereField("\(userId).isExist", isEqualTo: true)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                log.info("receive new meesage")
                if let error = error {
                    print("Error fetching inbox: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    self.inbox = []
                    return
                }

                self.inbox = documents.compactMap { self.getInbox(userId: userId, document: $0) }
                for inbox in self.inbox {
                    if let user = inbox.users?.filter({ $0.id == self.userModel.user?.id }).first,
                        user.seen == false {
                            if Tabbar.shared.selectedTab != .inbox {
                                Tabbar.shared.hasNewMessage = true
                            } else {
                                Tabbar.shared.hasNewMessage = false
                            }
                        break
                    }
                }
            }
    }

    private func getInbox(userId: String, document: QueryDocumentSnapshot) -> Inbox? {
        let inboxData = document.data()
        let user = getUser(uID: userId, document: document)
        let users = getUsers(document: document)
        let lastMessage = inboxData["lastMessage"] as? String ?? ""
        if let timestamp = inboxData["timestamp"] as? Timestamp {
            return Inbox(id: user.id, user: user, users: users, lastMessage: lastMessage, timestamp: timestamp.dateValue().timeIntervalSince1970)

        } else {
            return Inbox(id: user.id, user: user, users: users, lastMessage: lastMessage, timestamp: Date().timeIntervalSince1970)
        }
    }

    private func getUser(uID: String, document: QueryDocumentSnapshot) -> ChatUser {
        // Filter the dictionary to exclude specific keys and retrieve the first available value
        let senderId = document.data()
            .filter { key, _ in key != uID && key != "lastMessage" && key != "timestamp" }
            .values
            .first

        // Check if `senderId` is a dictionary and extract the nested values
        if let senderInfo = senderId as? [String: Any] {
            let userID = document.data().filter { key, _ in key != uID && key != "lastMessage" && key != "timestamp" }
                .first
            let id = userID?.key ?? uID
            let name = senderInfo["name"] as? String ?? "No Name"
            let photo = senderInfo["image"] as? String
            let seen = senderInfo["seen"] as? Bool ?? false

            return ChatUser(id: id, name: name, photo: photo, seen: seen)
        } else {
            return ChatUser(id: uID, name: "No Name", photo: nil, seen: false)
        }
    }

    private func getUsers(document: QueryDocumentSnapshot) -> [ChatUser] {
        let data = document.data()
        return data.compactMap { key, value in
            guard let userMap = value as? [String: Any],
                  let name = userMap["name"] as? String,
                  let seen = userMap["seen"] as? Bool else { return nil }

            return ChatUser(
                id: key,
                name: name,
                photo: userMap["image"] as? String,
                seen: seen
            )
        }
    }

    // MARK: - Fetch Messages

    func getAllMessages(senderId: String, receiverId: String) {
        inboxCollection
            .whereField("\(senderId).isExist", isEqualTo: true)
            .whereField("\(receiverId).isExist", isEqualTo: true)
            .getDocuments { snapshot, _ in
                guard let document = snapshot?.documents.first else { return }

                document.reference.collection("Message")
                    .order(by: "timestamp", descending: false)
                    .addSnapshotListener { [weak self] snapshot, _ in
                        guard let self = self else { return }
                        guard let documents = snapshot?.documents else {
                            self.messages = []
                            return
                        }

                        self.messages = documents.compactMap { self.getMessage(document: $0) }
                    }
            }
    }

    private func getMessage(document: QueryDocumentSnapshot) -> Message? {
        let data = document.data()
        var time = Date().timeIntervalSince1970
        if let timestamp = data["timestamp"] as? Timestamp {
            time = timestamp.dateValue().timeIntervalSince1970
        }
        return Message(
            id: data["id"] as? String ?? "\(UUID())",
            senderId: data["senderId"] as? String ?? "",
            message: data["message"] as? String ?? "",
            timestamp: time
        )
    }

    // MARK: - Send Message

    func sendMessage(currentUser: ChatUser, inbox: Inbox, message: Message, completion: @escaping (Error?) -> Void) {
        let currentUserID = currentUser.id
        let receiverID = inbox.user?.id ?? ""
        let inboxDocumentRef = inboxCollection.document()

        let senderData: [String: Any] = [
            "isExist": true,
            "image": currentUser.photo ?? "",
            "name": currentUser.name,
            "seen": currentUser.seen,
        ]

        let receiverData: [String: Any] = [
            "isExist": true,
            "image": inbox.user?.photo ?? "",
            "name": inbox.user?.name ?? "",
            "seen": inbox.user?.seen ?? false,
        ]

        inboxCollection
            .whereField("\(currentUserID).isExist", isEqualTo: true)
            .whereField("\(receiverID).isExist", isEqualTo: true)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    log.error("querySnapshot in sendMessage errror \(error.localizedDescription)")
                    return completion(error)
                }

                if querySnapshot?.isEmpty ?? true {
                    // No document exists, create a new one
                    let inboxData: [String: Any] = [
                        currentUserID: senderData,
                        receiverID: receiverData,
                        "lastMessage": inbox.lastMessage ?? "",
                        "timestamp": Timestamp(date: Date(timeIntervalSince1970: inbox.timestamp ?? Date().timeIntervalSince1970)),
                    ]

                    inboxDocumentRef.setData(inboxData, merge: true) { error in
                        if let error = error {
                            log.error("inboxDocumentRef.setData error \(error.localizedDescription)")
                            return completion(error)
                        } else {
                            self.sendNewMessage(inboxDocumentRef: inboxDocumentRef, message: message, completion: completion)
                        }
                    }
                } else {
                    // Document already exists, add the message to it
                    let inboxDocRef = querySnapshot?.documents.first?.reference
                    inboxDocRef?.updateData([
                        receiverID: receiverData,
                        currentUserID: senderData,
                        "lastMessage": inbox.lastMessage ?? "",
                        "timestamp": Timestamp(date: Date(timeIntervalSince1970: inbox.timestamp ?? Date().timeIntervalSince1970)),
                    ]) { error in
                        if let error = error {
                            log.error("Updating inbox failed: \(error.localizedDescription)")
                            return completion(error)
                        } else {
                            self.sendNewMessage(inboxDocumentRef: inboxDocRef!, message: message, completion: completion)
                        }
                    }
                }
            }
    }

    private func sendNewMessage(inboxDocumentRef: DocumentReference, message: Message, completion: @escaping (Error?) -> Void) {
        let messageData: [String: Any] = [
            "message": message.message,
            "senderId": message.senderId,
            "timestamp": Timestamp(date: Date(timeIntervalSince1970: message.timestamp)),
        ]

        inboxDocumentRef.collection("Message").addDocument(data: messageData) { error in
            if let error = error {
                log.error("Message Sending Failed: \(error.localizedDescription)")
                return completion(error)
            } else {
                return completion(nil)
            }
        }
    }

    // MARK: - Update Seen status

    func updateSeenStatus(currentUID: String, receiverID: String, isSeen: Bool, completion: @escaping (Error?) -> Void) {
        inboxCollection
            .whereField("\(currentUID).isExist", isEqualTo: true)
            .whereField("\(receiverID).isExist", isEqualTo: true)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    log.error("Error updating seen status: \(error.localizedDescription)")
                    return completion(error)
                }

                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    log.error("documents is empty in updating seen status")
                    return completion(nil)
                }

                let inboxDocRef = documents[0].reference
                inboxDocRef.updateData([
                    "\(currentUID).seen": isSeen,
                ]) { error in
                    if let error = error {
                        log.error("Seen status update failed: \(error.localizedDescription)")
                        return completion(error)
                    } else {
                        return completion(nil)
                    }
                }
            }
    }
    // MARK: - Messages Sceen Params
    @Published var newMessage: String = ""
    @Published var textEditorHeight: CGFloat = 40
    @Published var isKeyboardVisible = false
    // MARK: - Messages View functions
    
    func sendMessage(messageReceiverInfo: ChatUser) {
        if newMessage.trim().count == 0 {
            return
        }
        let cUser = ChatUser(id: userModel.user!.id, name: userModel.user!.name, photo: userModel.user!.photo, seen: true)
        let receiver = ChatUser(id: messageReceiverInfo.id, name: messageReceiverInfo.name, photo: messageReceiverInfo.photo, seen: false)
        let inbox = Inbox(id: "\(UUID())", user: receiver, lastMessage: newMessage.trim(), timestamp: Date().timeIntervalSince1970)
        let message = Message(id: "\(UUID())", senderId: self.userModel.user!.id, message: newMessage.trim(), timestamp:  Date().timeIntervalSince1970)
        self.sendMessage(currentUser: cUser, inbox: inbox, message: message) { [weak self] error in
            if let err = error {
                BannerHelper.displayBanner(.error, message: err.localizedDescription)
            } else {
                
                self?.notification.sendNotification(title: messageReceiverInfo.name, body: self?.newMessage.trim() ?? "", toId: "\(Apis.TOPIC)\(Apis.TROOUTE_TOPIC)\(messageReceiverInfo.id)", data: NotificationRequest.Data(dl: "chat")) { result in
                    switch result {
                    case .success(let success):
                        log.info("sendMessage notification send")
                    case .failure(let failure):
                        log.error("sendMessage notification send error  \(failure.localizedDescription)")
                    }
                    self?.newMessage = ""
                }
                
            }
        }
    }
    
    func markAsRead(messageReceiverInfo: ChatUser) {
        if let currentUserId = userModel.user?.id {
            self.updateSeenStatus(currentUID: currentUserId, receiverID: messageReceiverInfo.id, isSeen: true) { error in
                
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
    
    func getMessages(messageReceiverInfo: ChatUser) {
        if let current = userModel.user?.id {
            self.getAllMessages(senderId: current, receiverId: messageReceiverInfo.id)
            self.markAsRead(messageReceiverInfo: messageReceiverInfo)
        }
    }
}
