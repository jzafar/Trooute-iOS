//
//  FirebaseViewModel.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-31.
//

// import FirebaseFirestoreSwift
import Combine
import FirebaseFirestore

class FirebaseViewModel: ObservableObject {
    private let inboxCollection = Firestore.firestore().collection("TroouteInbox")

    // Publishers for inbox and messages
    @Published var inbox: [Inbox] = []
    @Published var messages: [Message] = []
    @Published var sendStatus: Resource<Bool> = .loading

    // MARK: - Fetch Inbox

    func getAllInbox(userId: String) {
        inboxCollection
            .whereField("\(userId).isExist", isEqualTo: true)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching inbox: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    self.inbox = []
                    return
                }
                self.inbox = documents.compactMap { self.getInbox(userId: userId, document: $0) }
            }
    }

    private func getInbox(userId: String, document: QueryDocumentSnapshot) -> Inbox? {
        let inboxData = document.data()
        let user = getUser(uID: userId, document: document)
        let users = getUsers(document: document)
        let lastMessage = inboxData["lastMessage"] as? String ?? ""
        if let timestamp = inboxData["timestamp"] as? Timestamp {
            return Inbox(user: user, users: users, lastMessage: lastMessage, timestamp: timestamp.dateValue().timeIntervalSince1970)
            
        }  else {
            return Inbox(user: user, users: users, lastMessage: lastMessage, timestamp: Date().timeIntervalSince1970)
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
            let name = senderInfo["name"] as? String ?? "No Name"
            let photo = senderInfo["image"] as? String
            let seen = senderInfo["seen"] as? Bool ?? false

            return ChatUser(id: uID, name: name, photo: photo, seen: seen)
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
                    .order(by: "timestamp", descending: true)
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

    func sendMessage(currentUser: ChatUser, inbox: Inbox, message: Message) {
        let inboxRef = inboxCollection.document()

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

        let inboxData: [String: Any] = [
            currentUser.id: senderData,
            inbox.user?.id ?? "": receiverData,
            "message": message.message,
            "timestamp": message.timestamp,
        ]

        inboxRef.setData(inboxData, merge: true) { error in
            if let error = error {
                self.sendStatus = .error("Failed to create inbox: \(error.localizedDescription)")
                return
            }

            let messageRef = inboxRef.collection("messageCollectionName").document()
            let messageData: [String: Any] = [
                "message": message.message,
                "senderId": message.senderId,
                "timestamp": message.timestamp,
            ]

            messageRef.setData(messageData) { error in
                if let error = error {
                    self.sendStatus = .error("Failed to send message: \(error.localizedDescription)")
                } else {
                    self.sendStatus = .success(true)
                }
            }
        }
    }
}

struct Resource<T> {
    var isLoading: Bool
    var data: T?
    var error: String?

    static var loading: Resource { Resource(isLoading: true, data: nil, error: nil) }
    static func success(_ data: T) -> Resource { Resource(isLoading: false, data: data, error: nil) }
    static func error(_ message: String) -> Resource { Resource(isLoading: false, data: nil, error: message) }
}
