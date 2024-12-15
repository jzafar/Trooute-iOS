//
//  CustomViews.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-20.
//
import SwiftUI

struct PrimaryGreenButton: View {
    var title: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.horizontal, 1)
                .padding(.vertical)
                .background(.primaryGreen)
                .cornerRadius(8)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct WhiteBorderButton: View {
    var title: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .font(.headline)
                .padding(.horizontal, 1)
                .padding(.horizontal, 1)
                .padding(.vertical)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white, lineWidth: 2)
                )
        }.background(.clear)
    }
}

struct PrimaryGreenText: View {
    var title: String
    var body: some View {
        Text(title)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .font(.headline)
            .fontWeight(.bold)
            .padding()
            .background(.primaryGreen)
            .cornerRadius(8)
    }
}

struct SecondaryGrayButton: View {
    var title: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
                .font(.headline)
                .fontWeight(.bold)
                .padding()
                .background(.white)
                .cornerRadius(8)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct SecondaryBookingButton: View {
    var title: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
                .font(.headline)
                .fontWeight(.semibold)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct TextViewLableText: View {
    var text: String
    var textFont: Font = .headline
    var body: some View {
        Text(text)
            .font(textFont)
            .foregroundColor(.black)
    }
}

struct LocalizedTextViewLableText: View {
    var text: String
    var textFont: Font = .headline
    var body: some View {
        Text(LocalizedStringKey(text))
            .font(textFont)
            .foregroundColor(.black)
    }
}

struct ListRowText: View {
    var text: String
    var body: some View {
        Text(text)
            .foregroundColor(.black)
    }
}

struct AppTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(8)
    }
}

struct RadioButtonField: View {
    var label: String
    @Binding var isSelected: String
    var value: String

    var body: some View {
        HStack {
            Button(action: {
                isSelected = value
            }) {
                Image(systemName: isSelected == value ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(Color("PrimaryGreen"))
            }
            Text(label)
                .foregroundColor(.primary)
        }
    }
}

// struct CheckboxToggleStyle: ToggleStyle {
//    func makeBody(configuration: Configuration) -> some View {
//        Button(action: {
//            configuration.isOn.toggle()
//        }) {
//            HStack {
//                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
//                    .foregroundColor(.green)
//            }
//        }
//    }
// }

struct PriceView: View {
    let price: Double
    let bookingSeats: Int?
    let showPersonText: Bool
    var body: some View {
        HStack {
            Text("€\(String(format: "%.1f", price + Double(bookingSeats ?? 0)))")
                .font(.title3).bold()
                .foregroundColor(.white)
            if showPersonText {
                Text("/Person")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                    .padding(.leading, -3)
            }
        }.padding(.horizontal)
            .padding(.vertical, 5)
    }
}

struct XMarkButton: View {
    var color: Color = .black
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.headline)
                .foregroundStyle(color)
        }.buttonStyle(PlainButtonStyle())
    }
}
