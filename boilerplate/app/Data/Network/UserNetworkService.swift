//
//  UserNetworkService.swift
//  boilerplate
//
//  Created by ark on 02.05.2025.
//

import Foundation

class UserNetworkService {
    func fetchUsers() async throws -> [User] {
        guard let url = URL(string: "https://api.example.com/users") else {
            throw AppError.networkError
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw AppError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode([User].self, from: data)
        } catch {
            throw AppError.parsingError
        }
    }
}
