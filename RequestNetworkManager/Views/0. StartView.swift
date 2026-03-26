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

struct StartView: View {
    @State private var viewOption: ViewOption = .first
    var body: some View {
        NavigationStack {
            viewOption
                .navigationTitle(viewOption.title)
                .toolbarTitleDisplayMode(.inlineLarge)
        }
        .safeAreaInset(edge: .bottom) {
            Picker("View Option", selection: $viewOption) {
                ForEach(ViewOption.allCases) { viewCase in
                    Text(viewCase.picker)
                }
            }
            .background(.thinMaterial, in: Capsule())
            .shadow(color: .black.opacity(0.5), radius: 8, x: 5, y: 5)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal)
        }
    }
}

#Preview {
    StartView()
        .environment(UsersViewModel())
}
