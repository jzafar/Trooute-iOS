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
                .padding()
                .background(.primaryGreen)
                .cornerRadius(8)
        }
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


struct ScendoryGrayButton: View {
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
        }
    }
}

struct PersonButton: View {
    let text: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.largeTitle)
                .foregroundColor(Color("TitleColor"))
                .frame(width: 40, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.lightBlue)
                )
        }
    }
}

struct TextViewLableText: View {
    var text: String
    var textFont: Font = .headline
    var body: some View {
        Text(text)
            .font(textFont)
            .foregroundColor(Color("TitleColor"))
    }
}

struct ListRowText: View {
    var text: String
    var body: some View {
        Text(text)
            .foregroundColor(Color("TitleColor"))
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

//struct CheckboxToggleStyle: ToggleStyle {
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
//}

struct PriceView: View {
    let price: Double
    let bookingSeats: Int?
    let showPersonText: Bool
    var body: some View {
        HStack {
            Text( "€\(String(format: "%.1f", (price + Double(bookingSeats ?? 0))))")
                .font(.title3).bold()
                .foregroundColor(.white)
            if showPersonText {
                Text("/Person")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                    .padding(.leading, -3)
            }
        }.padding()
    }
}



struct XMarkButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.headline)
                .foregroundStyle(Color.black)
        }
    }
}
