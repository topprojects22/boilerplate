import SwiftUI

// Цветовая палитра, вдохновленная дизайном
extension Color {
    static let appBackgroundGradientStart = Color(red: 0.85, green: 0.9, blue: 0.98) // Светло-голубой
    static let appBackgroundGradientEnd = Color(red: 0.75, green: 0.8, blue: 0.95)   // Чуть темнее голубой
    static let appCardBackground = Color.white.opacity(0.8) // Полупрозрачный белый для карточек
    static let appPrimaryText = Color.black.opacity(0.8)
    static let appSecondaryText = Color.gray
    static let appAccent = Color(red: 1.0, green: 0.4, blue: 0.2) // Оранжево-красный акцент (как кнопка Reload)
    static let appWarning = Color(red: 0.9, green: 0.3, blue: 0.25) // Для предупреждений, как на индикаторе температуры
    static let appYellowAccent = Color(red: 0.98, green: 0.84, blue: 0.22) // Желтый акцент (как "Active")
}

// Стиль для кнопок
struct AppButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.appAccent)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

// Стиль для текстовых полей
struct AppTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.gray.opacity(0.1))
            )
            .padding(.bottom, 8) // Небольшой отступ снизу
    }
}

// Фоновый градиент
struct AppBackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.appBackgroundGradientStart, Color.appBackgroundGradientEnd]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

// Стиль для карточек
struct AppCardView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Material.ultraThinMaterial) // Эффект "frosted glass"
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
    }
}