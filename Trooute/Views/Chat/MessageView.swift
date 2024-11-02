//
//  MessageView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-11-01.
//

import Combine
import SDWebImageSwiftUI
import SwiftUI

struct MessageView: View {
    @ObservedObject var viewModel: FirebaseViewModel
    var messageReceiverInfo: ChatUser
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                List(viewModel.messages) { message in
                    Messages(currentMessage: message)
                        .id(message)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
                .onChange(of: viewModel.messages) { _ in
                    // When items update, scroll to the last item
                    if let lastItem = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastItem, anchor: .bottom)
                        }
                    }
                }
                .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                    if let lastItem = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastItem, anchor: .bottom)
                        }
                    }
                }
                .onReceive(Just(viewModel.messages)) { _ in
                    withAnimation {
                        proxy.scrollTo(viewModel.messages.last, anchor: .bottom)
                    }
                }
            }.onTapGesture {
                hideKeyboard()
            }
            .onAppear {
                Tabbar.shared.hide = true
                viewModel.getMessages(messageReceiverInfo: messageReceiverInfo)
            }
            .ignoresSafeArea(edges: .bottom)
            .toolbarRole(.editor)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        if let photo = messageReceiverInfo.photo {
                            WebImage(url: URL(string: Utils.getImageFullUrl(photo))) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Image("profile_place_holder")
                                    .resizable()
                            }

                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            .padding(.vertical, 5)
                        }
                        Text(messageReceiverInfo.name)
                            .bold()
                    }
                }
            }
            Spacer()
            chatMessageComposer()
        }
    }

    @ViewBuilder
    func chatMessageComposer() -> some View {
        HStack(alignment: .bottom) {
            ZStack(alignment: .leading) {
                TextEditor(text: $viewModel.newMessage)
                    .frame(height: viewModel.textEditorHeight)
                    .background(.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 8)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary).opacity(0.5))
                    .onChange(of: viewModel.newMessage) { _ in
                        viewModel.adjustTextEditorHeight()
                    }

                if viewModel.newMessage.isEmpty {
                    Text("Send a message")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .allowsHitTesting(false)
                }
            }

            Button(action: {
                viewModel.sendMessage(messageReceiverInfo: messageReceiverInfo)
            }) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.blue)
                    .padding(8)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

// #Preview {
//    MessageView()
// }
struct MessageCell: View {
    var contentMessage: Message
    var isCurrentUser: Bool

    var body: some View {
        VStack(alignment: isCurrentUser ? .trailing : .leading) {
            Text(contentMessage.message)
            Text(contentMessage.timestamp.formatMessageTimeInterval())
                .font(.caption)

        }.padding(10)
            .foregroundColor(isCurrentUser ? .white : .black)
            .background(isCurrentUser ? .blue : .white)
            .cornerRadius(10)
    }
}

struct Messages: View {
    var currentMessage: Message
    @StateObject var userModel: UserUtils = UserUtils.shared
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            if userModel.user?.id == currentMessage.senderId {
                Spacer()
            }
            MessageCell(contentMessage: currentMessage,
                        isCurrentUser: userModel.user?.id == currentMessage.senderId)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
