//
//  TripRouteView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import SwiftUI

struct TripRouteView: View {
    let info: TripRouteModel
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack(alignment: .top) {
                // "From" Location Icon
                circleWithDottedLines()
                    .padding(.vertical, 27)

                // "From" Location Details
               
                VStack(alignment: .leading, spacing: 8) {
                    Text("From")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                    TextViewLableText(text: info.fromAddress, textFont: .headline)

                    Text(info.date)
                        .font(.subheadline)
                        .foregroundColor(Color.darkBlue)
                        .padding(.bottom)
                    
                    Text("Where to")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                    
                    TextViewLableText(text: info.whereToAddress, textFont: .headline)
                }
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func circleWithDottedLines() -> some View {
        VStack {
            Image("ic_location_from")
                .frame(width: 12, height: 12)
                .padding(.top, 5)

            // Dotted Line
            DashedLine()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                .frame(height: 65)

            Image("ic_location_where_to")
                .frame(width: 12, height: 12)
        }.frame(width: 30)
    }
}

#Preview {
    TripRouteView(info: TripRouteModel(fromAddress: "Stock", whereToAddress: "Upsala", date: "01 jan 2025"))
}
