//
//  KeychainService.swift
//  ar3dprofile
//
//  Created by ark on 22.06.2025.
//

import Foundation
import KeychainAccess

final class KeychainService {
    private let keychain = Keychain(service: "com.yourcompany.seamlessauthexample")

    func save(tokens: AuthTokens) throws {
        let data = try JSONEncoder().encode(tokens)
        keychain[data: "tokens"] = data
    }

    func load() throws -> AuthTokens? {
        guard let data = keychain[data: "tokens"] else { return nil }
        return try JSONDecoder().decode(AuthTokens.self, from: data)
    }

    func clear() {
        keychain["tokens"] = nil
    }
}
