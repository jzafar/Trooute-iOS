//
//  NetworkService.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-10-12.
//

// NetworkService.swift
import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        url: String,
        method: HTTPMethod,
        queryParams: [String: String]?,
        httpBody: [String: Any?]?,
        isMultipart: Bool,
        completion: @escaping (Result<Response<T>, Error>) -> Void
    )
}

class NetworkService: NetworkServiceProtocol {
    func request<T: Decodable>(
        url: String,
        method: HTTPMethod,
        queryParams: [String: String]? = nil,
        httpBody: [String: Any?]? = nil,
        isMultipart: Bool = false,
        completion: @escaping (Result<Response<T>, Error>) -> Void
    ) {
        log.debug("calling api \(url)")
        guard var urlComponents = URLComponents(string: url) else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            }
            return
        }

        if let queryParams = queryParams {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        guard let finalURL = urlComponents.url else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            }
            return
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        if isMultipart {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            if let parameters = httpBody {
                let httpBody = createMultipartBody(parameters: parameters as [String: Any], boundary: boundary)
                request.httpBody = httpBody
            }

        } else {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if let parameters = httpBody {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    request.httpBody = jsonData
                } catch let error {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: error.localizedDescription, code: 0, userInfo: nil)))
                    }
                    return
                }
            }
        }
        
        if let token = UserDefaults.standard.string(forKey: UserDefaultsKey.token.key) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode

                do {
                    let str = String(decoding: data, as: UTF8.self)
                    log.debug(str)
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    let response = Response(data: decodedData, statusCode: statusCode)
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
                } catch let error {
                    if let err = error as? DecodingError {
                        switch err {
                        case .keyNotFound(let key, let context):
                            print("Missing key: \(key) in \(context)")
                        case .typeMismatch(let type, let context):
                            print("Type mismatch: \(type) in \(context)")
                        case .valueNotFound(let value, let context):
                            print("Value not found: \(value) in \(context)")
                        case .dataCorrupted(let context):
                            print("Data corrupted: \(context)")
                        default:
                            print("Decoding error: \(err)")
                        }
                    }
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }.resume()
    }

    private func createMultipartBody(parameters: [String: Any], boundary: String) -> Data {
        var body = Data()

        // Add parameters
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            if let stringValue = value as? String {
                body.append("\(stringValue)\r\n")
            } else if let imageData = value as? Data {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(String(describing: Date().fullFormatDate)).jpg\"\r\n")
                body.append("Content-Type: image/jpeg\r\n\r\n")
                body.append(imageData)
                body.append("\r\n")
            }
        }

        body.append("--\(boundary)--\r\n")

        return body
    }
}

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension NetworkServiceProtocol {
    func request<T: Decodable>(
        url: String,
        method: HTTPMethod,
        queryParams: [String: String]? = nil,
        httpBody: [String: Any?]? = nil,
        isMultipart: Bool = false,
        completion: @escaping (Result<Response<T>, Error>) -> Void
    ) {
        request(url: url, method: method, queryParams: queryParams, httpBody: httpBody, isMultipart: isMultipart, completion: completion)
    }
}

struct Response<T: Decodable> {
    let data: T
    let statusCode: Int
}
