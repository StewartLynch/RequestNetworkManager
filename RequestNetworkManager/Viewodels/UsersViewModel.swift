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
class UsersViewModel {
    var users: [User] = []
    
    func fetchUsers() async throws(NetworkError){
        var endpoint = TestEndpoint.userWithHeader
        endpoint.addHeader("application/json", forHTTPHeaderField: "Content-Type")
        endpoint.addHeader("Bearer \(token)", forHTTPHeaderField: "Authorization")
        users = try await NetworkManager.shared.fetchAndDecodeJSON(from: endpoint)
    }
    
    func createUser(
        name: String,
        email: String,
        gender: User.Gender,
        status: User.Status
    ) async throws(NetworkError) {
        struct NewUserRequest: Encodable {
            let name: String
            let email: String
            let gender: User.Gender
            let status: User.Status
        }
        let payload = NewUserRequest(
            name: name,
            email: email,
            gender: gender,
            status: status
        )
        var endpoint = TestEndpoint.createUser
        endpoint.addHeader("application/json", forHTTPHeaderField: "Content-Type")
        endpoint.addHeader("Bearer \(token)", forHTTPHeaderField: "Authorization")
        endpoint.addHeader("application/json", forHTTPHeaderField: "Accept")
        
        let _: User = try await NetworkManager.shared.sendJSONAndDecodeResponse(
            from: endpoint,
            payload: payload
        )
        
        try await fetchUsers()
    }

    func updateUserUser(
        id: Int,
        name: String,
        email: String,
        gender: User.Gender,
        status: User.Status
    ) async throws(NetworkError) {
        struct UpdateUserRequest: Encodable {
            let name: String
            let email: String
            let gender: User.Gender
            let status: User.Status
        }
        let payload = UpdateUserRequest(
            name: name,
            email: email,
            gender: gender,
            status: status
        )
        var endpoint = TestEndpoint.updateUser(id: id)
        endpoint.addHeader("application/json", forHTTPHeaderField: "Content-Type")
        endpoint.addHeader("Bearer \(token)", forHTTPHeaderField: "Authorization")
        endpoint.addHeader("application/json", forHTTPHeaderField: "Accept")
        
        let _: User = try await NetworkManager.shared.sendJSONAndDecodeResponse(
            from: endpoint,
            payload: payload
        )
        
        try await fetchUsers()
    }
    
    func deleteUsers(at offsets: IndexSet) async throws(NetworkError) {
        let ids = offsets.map { users[$0].id}
        for id in ids {
            var endpoint = TestEndpoint.deleteUser(id: id)
            endpoint.addHeader("application/json", forHTTPHeaderField: "Content-Type")
            endpoint.addHeader("Bearer \(token)", forHTTPHeaderField: "Authorization")
            endpoint.addHeader("application/json", forHTTPHeaderField: "Accept")
            try await NetworkManager.shared.sendRequest(from: endpoint)
        }
        try await fetchUsers()
    }
}
