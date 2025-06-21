//
//  ProfileNetworkService.swift
//  ar3dprofile
//
//  Created by ark on 21.06.2025.
//

import Foundation

class ProfileNetworkService {
    func fetchProfile() async throws -> Profile {
        guard let url = URL(string: "http://localhost:3100/user/current") else {
            throw AppError.networkError
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw AppError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(Profile.self, from: data)
        } catch {
            throw AppError.parsingError
        }
    }
}
