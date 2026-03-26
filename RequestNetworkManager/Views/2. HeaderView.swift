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

struct User: Identifiable, Codable {
    enum Gender: String, Codable {
        case male
        case female
        
        var icon: String {
            switch self {
            case .male:
                "👱‍♂️"
            case .female:
                "👩🏽"
            }
        }
    }
    enum Status: String, Codable {
        case active, inactive
    }
    
    let id: Int
    var name: String
    var email: String
    var gender: Gender
    var status: Status
}



struct HeaderView: View {
    @Environment(UsersViewModel.self) var model
    var body: some View {
        List(model.users) { user in
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
        .listStyle(.plain)
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
        HeaderView()
            .navigationTitle(ViewOption.second.title)
            .toolbarTitleDisplayMode(.inlineLarge)
            .environment(UsersViewModel())
    }
}
