//
//  BluePriceView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-06.
//
import SwiftUI
struct PriceView1: View {
    let finalPrice: Double
    let bookingSeats: Int?
    let bookingSeatsPrice: Double?
    let showPersonText: Bool
    let showSeatsRow: Bool
    let showPlateformFee: Bool
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if showSeatsRow {
                    HStack {
                        Text("\(bookingSeats ?? 10000) x Seats")
                            .foregroundStyle(.white)
                        Spacer()
                        Text(self.bookPrice(bookingSeatsPrice))
                            .foregroundStyle(.white)

                    }.padding(.bottom, 1)

                    if showPlateformFee {
                        HStack {
                            Text("Platform fee")
                                .foregroundStyle(.white)
                            Spacer()
                            Text("€1.0")
                                .foregroundStyle(.white)

                        }.padding(.bottom, 1)
                    }
                }
                
                if (showSeatsRow || showPlateformFee) {
                    HStack {
                    }.frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .padding(.vertical, 4)
                }
                HStack {
                    Text("€\(String(format: "%.1f", finalPrice))")
                        .font(.title3).bold()
                        .foregroundColor(.white)
                    if showPersonText {
                        Text("/Person")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .padding(.top, 5)
                            .padding(.leading, -3)
                    }
                }
                
            }.padding()
        }.background(Color("TitleColor"))
    }
    func bookPrice(_ price: Double?) -> String {
        return "€\(String(format: "%.1f", price ?? 0.0))"
    }
}
#Preview {
    PriceView1(finalPrice: 52.0, bookingSeats: 2, bookingSeatsPrice: 50.0, showPersonText: true, showSeatsRow: true, showPlateformFee: true)
}
