//
//  TripRouteView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-26.
//

import SwiftUI

struct TripRouteView: View {
    let info: TripRouteModel
    @State var infoHeight: CGFloat = 10
    @State var titleHeight: CGFloat = 10
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(height: 1)
                cardView
            }
        }
    }

    @ViewBuilder
    var cardView: some View {
        VStack(alignment: .leading) {
            tripDetailsView
        }
        .padding()
    }

    @ViewBuilder
    var line: some Shape {
        VLine()
            .stroke(style:
                StrokeStyle(lineWidth: 1,
                            dash: [5]))
    }

    @ViewBuilder
    var tripDetailsView: some View {
        Grid(alignment: .leading,
             horizontalSpacing: 5,
             verticalSpacing: 0) {
            GridRow {
                ZStack(alignment: .top) {}
                Text("From")
                    .foregroundStyle(.secondary)
            }
            GridRow {
                ZStack(alignment: .top) {
                    line
                        .padding(.top, 25)
                        .frame(width: 1)
                    Image(.icLocationFrom)
                        .gridCellAnchor(UnitPoint(x: 0, y: 0.14))
                        .padding(.top, 5)
                }
                .frame(width: 20, height: titleHeight)
                TextViewLableText(text: info.fromAddress, textFont: .headline)
                    .background(GeometryReader { geometry in
                        Color.clear.preference(
                            key: TitleValuePreferenceKey.self,
                            value: geometry.size.height
                        )
                    })
            }

            GridRow {
                ZStack {
                    line
                        .frame(width: 1, height: infoHeight)
                }
                .frame(width: 20)
                VStack(alignment: .leading, spacing: 10) {
                    Text(info.formattedDate)
                        .font(.subheadline)
                        .foregroundColor(Color.darkBlue)

                    Text("Where to")
                        .foregroundStyle(.secondary)
                }
                .background(GeometryReader { geometry in
                    Color.clear.preference(
                        key: InfoValuePreferenceKey.self,
                        value: geometry.size.height
                    )
                })
            }
            GridRow {
                ZStack {
                    Image(.icLocationWhereTo)
                }
                .frame(width: 20)
                .gridCellAnchor(UnitPoint(x: 0, y: 0.05))
                TextViewLableText(text: info.whereToAddress, textFont: .headline)
            }
        }
        .onPreferenceChange(InfoValuePreferenceKey.self) {
            infoHeight = $0
        }
        .onPreferenceChange(TitleValuePreferenceKey.self) {
            titleHeight = $0
        }
    }

    struct VLine: Shape {
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: rect.midX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            }
        }
    }

    struct InfoValuePreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = 0

        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = max(value, nextValue())
        }
    }

    struct TitleValuePreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = 0

        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = max(value, nextValue())
        }
    }
}

#Preview {
    TripRouteView(info: TripRouteModel(fromAddress: "Stock holm long address to check of it working as expexed well to sksks klf lsdafjlsad fsd;af sdaf fdsjalkk kfjhdsak skf   klfksdla fskalf hklsa fkl  sk faslkaslk lkfsadkl sa", whereToAddress: "Upsala", date: "01 jan 2025"))
}
