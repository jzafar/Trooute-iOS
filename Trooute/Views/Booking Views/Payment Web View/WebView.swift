//
//  WebView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-01.
//

import SwiftUI
@preconcurrency import WebKit
import SwiftLoader

struct WebView: UIViewRepresentable {
    @StateObject var webViewModel: WebViewModel
    @Environment(\.dismiss) var dismiss
        func makeCoordinator() -> WebView.Coordinator {
            Coordinator(self, webViewModel)
        }

        func makeUIView(context: Context) -> WKWebView {
            guard let url = URL(string: self.webViewModel.url) else {
                return WKWebView()
            }

            let request = URLRequest(url: url)
            let webView = WKWebView()
            webView.navigationDelegate = context.coordinator
            webView.load(request)
            if webViewModel.adjustFont {
                webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
            }
            return webView
        }

        func updateUIView(_ uiView: WKWebView, context: Context) {
            if webViewModel.shouldGoBack {
                uiView.goBack()
                webViewModel.shouldGoBack = false
                dismiss()
            }
        }
}

extension WebView {
    class Coordinator: NSObject, WKNavigationDelegate {
        @ObservedObject private var webViewModel: WebViewModel
        private let parent: WebView

        init(_ parent: WebView, _ webViewModel: WebViewModel) {
            self.parent = parent
            self.webViewModel = webViewModel
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            webViewModel.isLoading = true
            SwiftLoader.show(title: "Loading...", animated: true)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webViewModel.isLoading = false
            webViewModel.title = webView.title ?? ""
            webViewModel.canGoBack = webView.canGoBack
            SwiftLoader.hide()
            if webViewModel.adjustFont {
                let js = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='200%'"//dual size
                    webView.evaluateJavaScript(js, completionHandler: nil)
            }
            
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

                let url = navigationAction.request.url?.absoluteString
                print("onLoadResource: url -> \(url ?? "")")

                // Check if the URL contains "payment-success"
                if let url = url, url.contains("payment-success") {
                    let modifiedUrl = url.replacingOccurrences(of: "http://localhost:4000", with: "")
                    webViewModel.paymentSuccess(url: modifiedUrl)
                }

                if let url = url, url.contains("payment-failed") {
                    webViewModel.shouldGoBack = true
                }

                decisionHandler(.allow)
            }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            webViewModel.isLoading = false
            SwiftLoader.hide()
        }
    }
}
