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

enum ViewOption: CaseIterable, Identifiable, View {
    case first, second, third, fourth, fifth
    var id: Self { self }
    
    var title: String {
        switch self {
        case .first:
            "Jokes"
        case .second:
            "Get With Header"
        case .third:
            "Post"
        case .fourth:
            "Put/Patch"
        case .fifth:
            "Delete"
        }
    }
    
    var picker: String {
        switch self {
        case .first:
            "JokesView"
        case .second:
            "GET With HEADER"
        case .third:
            "POST"
        case .fourth:
            "PUT/PATCH"
        case .fifth:
            "DELETE"
        }
    }
    
    var body: some View {
        switch self {
        case .first:
            JokesView()
        case .second:
            HeaderView()
        case .third:
            PostView()
        case .fourth:
           PutPatchView()
        case .fifth:
            DeleteView()
        }
    }
    
}
