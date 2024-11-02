//
//  View.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-21.
//

import SwiftUI
import Combine

extension View {
    func disableWithOpacity(_ condition: Bool) -> some View {
        disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }

    func withoutAnimation() -> some View {
        animation(nil, value: UUID())
    }

    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }

    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers
          .Merge(
            NotificationCenter
              .default
              .publisher(for: UIResponder.keyboardWillShowNotification)
              .map { _ in true },
            NotificationCenter
              .default
              .publisher(for: UIResponder.keyboardWillHideNotification)
              .map { _ in false })
          .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
          .eraseToAnyPublisher()
      }
}
