//
//  IntroView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-22.
//

import SwiftUI

struct OnboardView: View {
    @State private var currentPage = 0
    
    @State private var signIn = false
    @State private var signup = false
    private let totalPages = 4
    
    var body: some View {
        VStack {
            // Title and Description for each page
            TabView(selection: $currentPage) {
                ForEach(0..<totalPages, id: \.self) { index in
                    VStack(alignment: .leading) {
                        Spacer()
                        Text(pageTitle(for: currentPage))
                            .foregroundColor(.darkBlue)
                            .font(.largeTitle).bold()
                            .padding(.horizontal, 30)
                            .padding(.bottom, -2)

                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.appOrange)
                            .frame(width: 150)
                            .padding(.horizontal, 30)
                            .padding(.bottom, 10)

                        Text(pageDescription(for: currentPage))
                            .font(.system(size: 16))
                            .foregroundColor(.title)
                            .multilineTextAlignment(.leading)
                            .padding(.horizontal, 30)
                    }.padding()
                        .tag(index)
                }
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .fullScreenCover(isPresented: $signup) {
                    SignUpView()
                }
                .fullScreenCover(isPresented: $signIn) {
                    SigninView()
                }

            // Page Indicators
            HStack(spacing: 10) {
                ForEach(0 ..< totalPages, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? .darkBlue : Color.gray.opacity(0.3))
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.bottom, 30)

            // Navigation buttons
            HStack {
                switch currentPage {
                case 0:
                    firstPageView()
                case 1,2:
                    secondPageView()
                case 3:
                    lastPageView()
                default:
                    EmptyView()
                }
            }
            .padding(.horizontal, 50)
            .padding(.bottom, 40)
        }
        .animation(.easeInOut, value: UUID())
    }

    @ViewBuilder
    func firstPageView() -> some View {
        PrimaryGreenButton(title: "Next") {
            if currentPage < totalPages - 1 {
                currentPage += 1
            }

        }.frame(width: 150)
    }

    @ViewBuilder
    func secondPageView() -> some View {
        SecondaryGrayButton(title: "Previous") {
            if currentPage > 0 {
                currentPage -= 1
            }
        }.frame(width: 150)
        
        PrimaryGreenButton(title: "Next") {
            if currentPage < totalPages - 1 {
                currentPage += 1
            }
        }.frame(width: 150)
    }

    @ViewBuilder
    func lastPageView() -> some View {
        PrimaryGreenButton(title: "Let's go") {
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
            signIn = true
        }.frame(width: 150)
        
//        PrimaryGreenButton(title: "Sign up") {
//            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
//            signup = true
//        }.frame(width: 150)
    }

    private func pageTitle(for index: Int) -> String {
        switch index {
        case 0:
            return "Welcome to \nTrooute!"
        case 1:
            return "Find Travel Partners"
        case 2:
            return "Hassle-Free Bookings"
        case 3:
            return "Connect and Go"
        default:
            return ""
        }
    }

    private func pageDescription(for index: Int) -> String {
        switch index {
        case 0:
            return "Join travelers, share experiences. Your journey, their company."
        case 1:
            return "Match with travelers, journey together. Connect, travel, bond."
        case 2:
            return "Book rides seamlessly, travel hassle-free. Your seat, a tap away."
        case 3:
            return "Chat, plan, explore as companions. New friendships, shared roads."
        default:
            return ""
        }
    }
}

#Preview {
    OnboardView()
}

// Helper extension to use hex colors
// extension Color {
//    init(hex: String) {
//        let scanner = Scanner(string: hex)
//        scanner.currentIndex = hex.startIndex
//        var rgbValue: UInt64 = 0
//        scanner.scanHexInt64(&rgbValue)
//
//        let red = Double((rgbValue & 0xff0000) >> 16) / 255
//        let green = Double((rgbValue & 0xff00) >> 8) / 255
//        let blue = Double(rgbValue & 0xff) / 255
//
//        self.init(red: red, green: green, blue: blue)
//    }
// }
