//
//  AuthTokens.swift
//  ar3dprofile
//
//  Created by ark on 22.06.2025.
//

import Foundation

struct AuthTokens: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresAt: String
}
