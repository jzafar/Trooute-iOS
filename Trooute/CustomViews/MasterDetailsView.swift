//
//  MasterDetailsView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-28.
//

import SwiftUI

struct MasterDetailsView: View {
    let master: String
    let details: String
    var body: some View {
        HStack {
            Text(master)
                .foregroundStyle(.gray)
            Spacer()
            Text(details)
                .foregroundStyle(.black)
        }.padding(.horizontal)
    }
}

#Preview {
    MasterDetailsView(master: "Type", details: "Hand carry")
}
