//
//  InboxView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import SwiftUI

struct InboxView: View {
    @ObservedObject var viewModel: FirebaseViewModel
    @StateObject var userModel: UserUtils = UserUtils.shared
    var body: some View {
        List {
            ForEach(viewModel.inbox) { inbox in
                Text(inbox.user?.name ?? "No Nmae")
            }
        }.onAppear {
            if let id = userModel.user?.id {
                viewModel.getAllInbox(userId: id)
            }
        }
    }
}

//#Preview {
//    InboxView()
//}
