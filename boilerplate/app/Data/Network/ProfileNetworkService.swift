//
//  ProfileNetworkService.swift
//  ar3dprofile
//
//  Created by ark on 21.06.2025.
//

import Foundation

class ProfileNetworkService {
    func fetchProfile() async throws -> Profile {
        guard let url = URL(string: "http://localhost:4000/user/current") else {
            throw AppError.networkError
        }
        var request = URLRequest(url: url)
        
        await try AuthInterceptor(keychainService: KeychainService()).intercept(request: request) { result in
                switch result {
                case .success(let data):
                    print("1", data)
                case .failure(let error):
                    print("2", error)
                }
        }
//        let (data, response) = try await URLSession.shared.data(from: url)
//        
//        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
//            throw AppError.invalidResponse
//        }
//        
//        do {
//            return try JSONDecoder().decode(Profile.self, from: data)
//        } catch {
//            throw AppError.parsingError
//        }
        return Profile(id: 1, name: "test@test.com")
    }
}
