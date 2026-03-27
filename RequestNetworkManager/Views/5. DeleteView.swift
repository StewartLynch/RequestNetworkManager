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

struct DeleteView: View {
    @Environment(UsersViewModel.self) var model
    var body: some View {
        List {
            ForEach(model.users) { user in
                VStack(alignment: .leading) {
                    HStack {
                        Text(user.gender.icon).font(.largeTitle)
                        Text(user.name).font(.title.bold())
                    }
                    HStack {
                        Text(user.email)
                        Spacer()
                        Text(verbatim: String(user.id)).font(.caption.smallCaps())
                    }
                }
                .strikethrough(user.status == .inactive)
            }
            .onDelete { offsets in
                Task {
                    do {
                        try await model.deleteUsers(at: offsets)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        .task {
            do {
                try await model.fetchUsers()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DeleteView()
            .navigationTitle(ViewOption.fifth.title)
            .toolbarTitleDisplayMode(.inlineLarge)
            .environment(UsersViewModel())
    }
}
