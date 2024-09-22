//
//  TripsView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import SwiftUI

struct TripsView: View {
    var body: some View {
            List(0..<100) {
                Text("Row \($0)")
            }
        
        
    }
}

#Preview {
    TripsView()
}
