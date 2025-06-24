//
//  AuthInterceptor.swift
//  ar3dprofile
//
//  Created by ark on 22.06.2025.
//

import Foundation

final class AuthInterceptor {
    private let keychainService: KeychainService

    init(keychainService: KeychainService) {
        self.keychainService = keychainService
    }

    func intercept(request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) async throws {
        var request = request

        guard let accessToken = try keychainService.load()?.accessToken else {
            handler(.failure(NetworkError.unauthorized))
            return
        }

        request.setValue("Bearer $accessToken)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 401 {
                    // Токен истек — обновляем
                    do {
                        // try await sessionManager.handleUnauthorized {}
                        try await retryRequest(request, handler: handler)
                    } catch {
                        handler(.failure(error))
                    }
                } else if (200..<300).contains(httpResponse.statusCode) {
                    handler(.success(data))
                } else {
                    handler(.failure(NetworkError.unknown))
                }
            }
        } catch {
            handler(.failure(error))
        }
    }

    private func retryRequest(_ request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) async throws {
        var request = request
        guard let accessToken = try keychainService.load()?.accessToken else {
            handler(.failure(NetworkError.unauthorized))
            return
        }

        request.setValue("Bearer $accessToken)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse,
               (200..<300).contains(httpResponse.statusCode) {
                handler(.success(data))
            } else {
                handler(.failure(NetworkError.unknown))
            }
        } catch {
            handler(.failure(error))
        }
    }
}
