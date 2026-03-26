//
//----------------------------------------------
// Original project: RequestNetworkManager
// by  Stewart Lynch on 2026-03-11
//
// Follow me on Mastodon: @StewartLynch@iosdev.space
// Follow me on Threads: @StewartLynch (https://www.threads.net)
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch
//----------------------------------------------
// Copyright © 2026 CreaTECH Solutions. All rights reserved.


import SwiftUI

struct PostView: View {
    @State private var isPresentingCreateSheet = false

    var body: some View {
        HeaderView()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresentingCreateSheet = true
                    } label: {
                        Label("Create New User", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingCreateSheet) {
                CreateUserSheetView()
            }
    }
}

#Preview {
    NavigationStack {
        PostView()
            .navigationTitle(ViewOption.third.title)
            .toolbarTitleDisplayMode(.inlineLarge)
            .environment(UsersViewModel())
    }
}
