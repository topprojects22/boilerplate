//
//  IdentifiableError.swift
//  boilerplate
//
//  Created by ark on 02.05.2025.
//


// MARK: - Utils/IdentifiableError.swift
import Foundation

/// Обертка для ошибки, чтобы она соответствовала Identifiable
struct IdentifiableError: Identifiable {
    let error: Error
    let id = UUID()
    
    var localizedDescription: String {
        error.localizedDescription
    }
}