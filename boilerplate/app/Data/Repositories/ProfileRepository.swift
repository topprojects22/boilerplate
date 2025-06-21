//
//  ProfileRepository.swift
//  ar3dprofile
//
//  Created by ark on 21.06.2025.
//

/// Протокол для работы с пользователями
protocol ProfileRepositoryProtocol {
    /// Получить список пользователей
    func fetchProfile() async throws -> Profile
}

class ProfileRepository: ProfileRepositoryProtocol {
    private let networkService: ProfileNetworkService
    private let localStore: UserLocalStore
    
    init(networkService: ProfileNetworkService, localStore: UserLocalStore) {
        self.networkService = networkService
        self.localStore = localStore
    }
    
    func fetchProfile() async throws -> Profile {
        let networkProfile = try await networkService.fetchProfile()
        return networkProfile
    }
}
