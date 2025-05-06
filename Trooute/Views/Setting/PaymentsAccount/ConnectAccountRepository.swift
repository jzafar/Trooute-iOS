//
//  ConnectAccountRepository.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2025-04-27.
//
import AuthenticationServices
import Foundation
import SwiftLoader
protocol ConnectAccountRepositoryProtocol {
    func connectPaypal(completion: @escaping (Result<Response<PayPalLoginResponse>, Error>) -> Void)
    func updatePaypalToServer(request: UpdatePaypalRequest ,completion: @escaping (Result<Response<SigninResponse>, Error>) -> Void)
}

struct PayPalLoginData: Codable {
    let email: String
    let name: String?
}

struct PayPalLoginResponse: BaseResponse, Codable {
    typealias T = PayPalLoginData
    let success: Bool
    let data: PayPalLoginData?
    let message: String
}

class ConnectAccountRepository: NSObject, ConnectAccountRepositoryProtocol, ASWebAuthenticationPresentationContextProviding {
    private let networkService: NetworkServiceProtocol
    private var loginCompletion: ((Result<Response<PayPalLoginResponse>, Error>) -> Void)?

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    
    func updatePaypalToServer(request: UpdatePaypalRequest ,completion: @escaping (Result<Response<SigninResponse>, Error>) -> Void) {
        networkService.request(url: Apis.updatePayPal, method: .POST, queryParams: request.parameters, completion: completion)
    }
    
    func connectPaypal(completion: @escaping (Result<Response<PayPalLoginResponse>, any Error>) -> Void) {
        loginCompletion = completion
    
        guard let authURL = URL(string: PayPalService.signInUrl) else {
            completion(.failure(NSError(domain: "Invalid Auth URL", code: 0)))
            return
        }
        SwiftLoader.show(animated: true)
        let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: Constants.callbackURLScheme) { callbackURL, error in
            SwiftLoader.hide()
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let callbackURL = callbackURL else {
                completion(.failure(NSError(domain: "Missing Callback URL", code: 0)))
                return
            }

            if let urlComponents = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
               let code = urlComponents.queryItems?.first(where: { $0.name == "code" })?.value {
                self.exchangeCodeForToken(code: code)
            } else {
                completion(.failure(NSError(domain: "Authorization Code Not Found", code: 0)))
            }
        }

        session.presentationContextProvider = self
        session.start()
    }

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }

    private func exchangeCodeForToken(code: String) {
        guard let tokenURL = URL(string: PayPalService.authUrl) else {
            print("Invalid Token URL") // Debug
            loginCompletion?(.failure(NSError(domain: "Invalid Token URL", code: 0)))
            return
        }

        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"

        let credentials = "\(PayPalService.clientID):\(PayPalService.secret)"
        guard let credentialData = credentials.data(using: .utf8) else {
            print("Credential Encoding Failed") // Debug
            loginCompletion?(.failure(NSError(domain: "Credential Encoding Failed", code: 0)))
            return
        }
        let base64Credentials = credentialData.base64EncodedString()

        request.addValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyString = "grant_type=authorization_code&code=\(code)&redirect_uri=\(Constants.redirectUri)"
        request.httpBody = bodyString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Token Exchange Error: \(error)") // Debug
                self.loginCompletion?(.failure(error))
                return
            }

            guard let data = data, !data.isEmpty else {
                print("Token Exchange: No Data") // Debug
                self.loginCompletion?(.failure(NSError(domain: "No Token Response", code: 0)))
                return
            }

            print("Token Response: \(String(data: data, encoding: .utf8) ?? "Invalid JSON")") // Debug

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let accessToken = json["access_token"] as? String {
                    // Log the granted scopes
                    if let scopes = json["scope"] as? String {
                        print("Access Token Scopes: \(scopes)") // Debug
                    } else {
                        print("Access Token: No scope field in response") // Debug
                    }
                    self.fetchUserInfo(accessToken: accessToken)
                } else {
                    print("Token Exchange: Invalid JSON or missing access_token") // Debug
                    self.loginCompletion?(.failure(NSError(domain: "Invalid Token JSON", code: 0)))
                }
            } catch {
                print("Token Exchange JSON Error: \(error)") // Debug
                self.loginCompletion?(.failure(error))
            }
        }.resume()
    }

    private func fetchUserInfo(accessToken: String) {
        guard let userInfoURL = URL(string: PayPalService.userInfoURL) else {
            loginCompletion?(.failure(NSError(domain: "Invalid User Info URL", code: 0)))
            return
        }

        var request = URLRequest(url: userInfoURL)
        request.httpMethod = "GET"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                self.loginCompletion?(.failure(error))
                return
            }

            guard let data = data else {
                self.loginCompletion?(.failure(NSError(domain: "No User Info Response", code: 0)))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let email = json["email"] as? String {
                    let name = json["name"] as? String

                    let loginData = PayPalLoginData(email: email, name: name)

                    let loginResponse = PayPalLoginResponse(
                        success: true,
                        data: loginData,
                        message: "User info fetched successfully"
                    )

                    let response = Response(data: loginResponse, statusCode: 200)
                    self.loginCompletion?(.success(response))

                } else {
                    self.loginCompletion?(.failure(NSError(domain: "Invalid User Info JSON", code: 0)))
                }
            } catch {
                self.loginCompletion?(.failure(error))
            }
        }.resume()
    }
}
