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

struct Endpoint {
    let urlString: String
    let method: HTTPMethod
    private(set) var headers: [String : String]
    
    init(urlString: String, method: HTTPMethod = .get, headers: [String : String] = [:]) {
        self.urlString = urlString
        self.method = method
        self.headers = headers
    }
    
    mutating func addHeader(_ value: String, forHTTPHeaderField: String) {
        headers[forHTTPHeaderField] = value
    }
    
    func buildRequest() throws(NetworkError) -> URLRequest {
        guard let url = URL(string: urlString) else { throw .badURL }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        for(key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}
