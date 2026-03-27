//
//----------------------------------------------
// Original project: RequestNetworkManager
//
// Follow me on Mastodon: https://iosdev.space/@StewartLynch
// Follow me on Threads: https://www.threads.net/@stewartlynch
// Follow me on Bluesky: https://bsky.app/profile/stewartlynch.bsky.social
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Email: slynch@createchsol.com
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch
//----------------------------------------------
// Copyright © 2026 CreaTECH Solutions (Stewart Lynch). All rights reserved.


import Foundation

enum NetworkError: Error {
    case badURL
    case transport(TransportError)
    case httpResponse
    case httpStatusCode(Int)
    case decoding
    
    var userMessage: String {
        switch self {
        case .transport(let transportError):
            transportError.userMessage
        case .httpStatusCode(let code):
            switch code {
            case 401: "Your session has expired.  Please sign in again."
            case 403: "You don't have permission to do that."
            case 404: "We coudn't find what you were looking for."
            case 429: "Too many requests.  Please wait a moment and try again."
            case 500...599: "The server is having trouble, please try again later."
            default: "Something went wrong.  Please try again"
            }
        default: "Something went wrong.  Please try again"
        }
    }
}

enum TransportError: Error {
    case offline, timedOut, dnsFailure, cannotConnect, cancelled, tlsFailure, unknown
    init(urlError: URLError) {
        switch urlError.code {
        case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
            self = .offline
        case .timedOut:
            self = .timedOut
        case .dnsLookupFailed, .cannotFindHost:
            self = .dnsFailure
        case .cannotConnectToHost:
            self = .cannotConnect
        case .cancelled:
            self = .cancelled
        case .secureConnectionFailed, .serverCertificateHasBadDate, .serverCertificateUntrusted, .serverCertificateHasUnknownRoot, .serverCertificateHasBadDate:
            self = .tlsFailure
        default:
            self = .unknown
        }
    }
    var userMessage: String {
        switch self {
        case .offline:
            "You appear to be offline. Check your internet connection and try again."
        case .timedOut:
            "The request timed out.  Try again."
        case .dnsFailure, .cannotConnect:
            "We can't reach the server right now.  Please try again later."
        case .cancelled:
            "The request was cancelled."
        case .tlsFailure:
            "A secure connection could not be established."
        case .unknown:
            "A network error occurred.  Please try again."
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchAndDecodeJSON<T: Decodable>(
        from url:String,
        configureDecoder: ((JSONDecoder) -> ())? = nil) async throws(NetworkError)-> T {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            throw NetworkError.badURL
        }
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Network error: Response was not HTTPURLResponse")
                    throw NetworkError.httpResponse
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    print("HTTP error: status code \(httpResponse.statusCode)")
                    throw NetworkError.httpStatusCode(httpResponse.statusCode)
                }
                do {
                    let decoder = JSONDecoder()
                    configureDecoder?(decoder)
                    return try decoder.decode(T.self, from: data)
                } catch let error as DecodingError {
                    print(decodingError(error: error))
                    throw NetworkError.decoding
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    print("Data as string: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to String")")
                    throw NetworkError.decoding
                }
            } catch let networkError as NetworkError {
                throw networkError
            } catch let urlError as URLError {
                throw NetworkError.transport(TransportError(urlError: urlError))
            } catch {
            print("Request error \(error.localizedDescription)")
                throw NetworkError.transport(.unknown)
        }
        
    }
    
    func fetchAndDecodeJSON<T: Decodable>(
        from endpoint:Endpoint,
        configureDecoder: ((JSONDecoder) -> ())? = nil) async throws(NetworkError)-> T {
            let request = try endpoint.buildRequest()
            return try await executedAndDecodeJSON(from: request, configureDecoder: configureDecoder)
    }
    
    func sendJSONAndDecodeResponse<T: Decodable, Payload: Encodable>(
        from endPoint:Endpoint,
        payload: Payload,
        configureDecoder: ((JSONDecoder) -> ())? = nil) async throws(NetworkError)-> T {
            var request = try endPoint.buildRequest()
            guard let encodedPayload = try? JSONEncoder().encode(payload) else {
                throw NetworkError.decoding
            }
            request.httpBody = encodedPayload
            return try await executedAndDecodeJSON(from: request, configureDecoder: configureDecoder)
        }
    
    func sendRequest(
        from endpoint: Endpoint
    ) async throws(NetworkError) {
        let request = try endpoint.buildRequest()
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Network error: Response was not HTTPURLResponse")
                throw NetworkError.httpResponse
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP error: status code \(httpResponse.statusCode)")
                throw NetworkError.httpStatusCode(httpResponse.statusCode)
            }
        } catch let networkError as NetworkError {
            throw networkError
        } catch let urlError as URLError {
            throw NetworkError.transport(TransportError(urlError: urlError))
        } catch {
            print("Request error \(error.localizedDescription)")
            throw NetworkError.transport(.unknown)
        }
    }
    
    func executedAndDecodeJSON<T: Decodable>(
        from request:URLRequest,
        configureDecoder: ((JSONDecoder) -> ())? = nil) async throws(NetworkError)-> T {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Network error: Response was not HTTPURLResponse")
                    throw NetworkError.httpResponse
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    print("HTTP error: status code \(httpResponse.statusCode)")
                    throw NetworkError.httpStatusCode(httpResponse.statusCode)
                }
                do {
                    let decoder = JSONDecoder()
                    configureDecoder?(decoder)
                    return try decoder.decode(T.self, from: data)
                } catch let error as DecodingError {
                    print(decodingError(error: error))
                    throw NetworkError.decoding
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    print("Data as string: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to String")")
                    throw NetworkError.decoding
                }
            } catch let networkError as NetworkError {
                throw networkError
            } catch let urlError as URLError {
                throw NetworkError.transport(TransportError(urlError: urlError))
            } catch {
            print("Request error \(error.localizedDescription)")
                throw NetworkError.transport(.unknown)
        }
    }
    
    func decodingError(error: DecodingError) -> String {
        switch error {
        case .typeMismatch(let type, let context):
            """
            Decoding Error: Type mismatch for type \(type)
            Context: \(context.debugDescription)
            Coding path: \(context.codingPath.map { $0.stringValue}.joined(separator: " -> "))
            """
        case .valueNotFound(let type, let context):
            """
            Decoding Error: Value of type \(type) not found
            Context: \(context.debugDescription)
            Coding path: \(context.codingPath.map { $0.stringValue}.joined(separator: " -> "))
            """
        case .keyNotFound(let codingKey, let context):
            """
            Decoding Error: Key '\(codingKey.stringValue)' not found
            Context: \(context.debugDescription)
            Coding path: \(context.codingPath.map { $0.stringValue}.joined(separator: " -> "))
            """
        case .dataCorrupted(let context):
            """
            Decoding Error: Data corrupted
            Context: \(context.debugDescription)
                Coding path: \(context.codingPath.map { $0.stringValue}.joined(separator: " -> "))
            """
        @unknown default:
            """
            Unknown error: \(error.localizedDescription)
            """
        }
    }
}
