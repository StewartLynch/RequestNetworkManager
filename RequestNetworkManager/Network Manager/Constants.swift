//
//----------------------------------------------
// Original project: RequestNetworkManager
// by  Stewart Lynch on 2026-03-25
//
// Follow me on Mastodon: @StewartLynch@iosdev.space
// Follow me on Threads: @StewartLynch (https://www.threads.net)
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch
//----------------------------------------------
// Copyright © 2026 CreaTECH Solutions. All rights reserved.

import Foundation

enum TestURL {
    static let jokesURL = "https://stewartlynch.github.io/Samples/jokes.json"
    static let gorestURL = "https://gorest.co.in/public/v2/users"
}

enum TestEndpoint {
    static var jokesEndpoint = Endpoint(urlString: TestURL.jokesURL)
    static var userWithHeader = Endpoint(urlString: TestURL.gorestURL, method: .get)
}

let token = "YOUR KEY GOES HERE WIHIN THESE QUOTES"
