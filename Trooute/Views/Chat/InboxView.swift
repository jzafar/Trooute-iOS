//
//  InboxView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import SDWebImageSwiftUI
import SwiftUI

struct InboxView: View {
    @ObservedObject var viewModel: FirebaseViewModel
    @StateObject var userModel: UserUtils = UserUtils.shared
    
    var body: some View {
        List {
            ForEach(viewModel.inbox) { inbox in
                ZStack {
                    NavigationLink(destination: MessageView(viewModel: viewModel, messageReceiverInfo: inbox.user!)) {
                        messageCell(inbox: inbox)
                    }
                }.listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
            }
        }.onAppear {
            if let id = userModel.user?.id {
                viewModel.getAllInbox(userId: id)
            }
        }
    }

    @ViewBuilder
    func messageCell(inbox: Inbox) -> some View {
        VStack(alignment: .leading) {
            HStack {
                let user = inbox.users?.filter {$0.id == userModel.user?.id}.first
                if user?.seen ?? false {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 10, height: 10)
                } else {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 10, height: 10)
                }
                WebImage(url: URL(string: Utils.getImageFullUrl(inbox.user?.photo ?? ""))) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image("profile_place_holder")
                        .resizable()
                }

                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.black, lineWidth: 1))
                .padding(.vertical, 5)

                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(inbox.user?.name ?? "No Nmae")
                            .bold()
                            .padding(.vertical, 1)
                        Text(inbox.lastMessage ?? "")
                            .lineLimit(1)
                            .font(.caption)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        if let time = inbox.timestamp {
                            Text(time.formatTimeInterval())
                        }
                    }
                }
            }
        }
    }
}

// #Preview {
//    InboxView()
// }
