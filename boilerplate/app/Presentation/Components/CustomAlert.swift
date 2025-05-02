//
//  CustomAlert.swift
//  boilerplate
//
//  Created by ark on 02.05.2025.
//

import SwiftUI

struct CustomAlert: ViewModifier {
    @Binding var error: IdentifiableError?
    
    func body(content: Content) -> some View {
        content
            .alert(item: $error) { error in
                Alert(
                    title: Text("Ошибка"),
                    message: Text(error.localizedDescription),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
}

extension View {
    func withCustomAlert(error: Binding<IdentifiableError?>) -> some View {
        modifier(CustomAlert(error: error))
    }
}
