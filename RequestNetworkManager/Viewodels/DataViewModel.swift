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

import SwiftUI

@Observable
class DataViewModel<T: Decodable> {
    var data: T?
    private let manager = NetworkManager.shared
    var networkError: NetworkError? = nil
    var isLoading = false
    let urlString: String
    private let configurator: ((JSONDecoder) -> Void)?
    
    init(urlString: String, configurator: ((JSONDecoder) -> Void)? = nil) {
        self.urlString = urlString
        self.configurator = configurator
    }
    
    func fetchData() async {
        isLoading = true
        networkError = nil
        defer { isLoading = false }
        #if DEBUG
        try? await Task.sleep(for: .seconds(1))
        #endif
        do {
            if let configurator {
                data = try await manager.fetchAndDecodeJSON(from: urlString, configureDecoder: configurator)
            } else {
                data = try await manager.fetchAndDecodeJSON(from: urlString)
            }
        } catch let error {
            networkError = error
        }
    }
}

struct Loader: ViewModifier {
    let isLoading: Bool
    let title: String
    func body(content: Content) -> some View {
        if isLoading {
            ProgressView("Loading \(title)")
        } else {
            content
        }
    }
}

extension View {
    func withLoader(isLoading: Bool, title: String) -> some View {
        modifier(Loader(isLoading: isLoading, title: title))
    }
}
