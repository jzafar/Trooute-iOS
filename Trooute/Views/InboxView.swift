//
//  InboxView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import SwiftUI
import SDWebImageSwiftUI

struct InboxView: View {
    @ObservedObject var viewModel: FirebaseViewModel
    @StateObject var userModel: UserUtils = UserUtils.shared
    var body: some View {
        List {
            ForEach(viewModel.inbox) { inbox in
                messageCell(inbox: inbox)
                    .listRowBackground(Color.clear)
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
                if let photo = inbox.user?.photo {
                    WebImage(url: URL(string:  Utils.getImageFullUrl(photo))) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image("profile_place_holder")
                            .resizable()
                    }

                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    .padding(1)
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text(inbox.user?.name ?? "No Nmae")
                            .bold()
                            .padding(.vertical, 3)
                        Text(inbox.lastMessage ?? "")
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        if let time = inbox.timestamp {
                            Text(time.formatTimeInterval())
                        }
                        
                        if inbox.user?.seen ?? false {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 10, height: 10)
                        }
                    }
                }
                
                
            }
            
        }
    }
   
}

//#Preview {
//    InboxView()
//}
