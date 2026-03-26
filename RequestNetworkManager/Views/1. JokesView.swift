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

struct Joke2:Identifiable, Codable {
    let id: Int
    let setup: String
    let punchline: String
    let entryDate: Date
}

struct JokesView: View {
    @State private var viewModel = DataViewModel<[Joke2]>(endpoint: TestEndpoint.jokesEndpoint) { decoder in
        decoder.dateDecodingStrategy = .iso8601
    }
    var body: some View {
        Group {
            if let jokes = viewModel.data, !jokes.isEmpty {
                List(jokes.shuffled()) { joke in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(joke.setup)
                            .font(.headline)
                        Text(joke.punchline)
                        Text(joke.entryDate, format: .dateTime.month().day().year())
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.plain)
                .refreshable {
                    Task {
                       await viewModel.fetchData()
                    }
                }
            } else {
                ContentUnavailableView("No Jokes available", systemImage: "hand.thumbsdown.fill")
            }
        }
        .withLoader(isLoading: viewModel.isLoading, title: "jokes")
        .task {
            await viewModel.fetchData()
        }
        .alert(
            "Unable to load jokes",
            isPresented: Binding(get: {
                viewModel.networkError != nil
            }, set: { value in
                if !value {  viewModel.networkError = nil}
            }),
            presenting:  viewModel.networkError) { _ in
                Button("OK") {
                    
                }
            } message: { networkError in
                Text(networkError.userMessage)
            }
    }
}

#Preview {
    NavigationStack {
        JokesView()
            .navigationTitle(ViewOption.first.title)
            .toolbarTitleDisplayMode(.inlineLarge)
    }
}
