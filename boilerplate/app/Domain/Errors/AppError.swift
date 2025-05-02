//
//  AppError.swift
//  boilerplate
//
//  Created by ark on 02.05.2025.
//

import Foundation

enum AppError: Error, LocalizedError {
    case networkError
    case invalidResponse
    case parsingError
    
    var errorDescription: String? {
        switch self {
        case .networkError: return "Ошибка сети"
        case .invalidResponse: return "Неверный ответ сервера"
        case .parsingError: return "Ошибка парсинга данных"
        }
    }
}
