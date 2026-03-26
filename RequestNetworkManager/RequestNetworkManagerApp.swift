//
//----------------------------------------------
// Original project: RequestNetworkManager
// by  Stewart Lynch on 2026-01-08
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
// Copyright © 2026 CreaTECH Solutions. All rights reserved.


import SwiftUI

@main
struct RequestNetworkManagerApp: App {
    @State private var usersModel = UsersViewModel()
    var body: some Scene {
        WindowGroup {
            StartView()
                .environment(usersModel)
        }
    }
}
