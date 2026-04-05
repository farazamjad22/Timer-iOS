import SwiftUI

// MARK: - Color Palette

extension Color {
    static let appPrimary      = Color(red: 0.388, green: 0.400, blue: 0.945)   // #6366F1 indigo
    static let appPrimaryLight = Color(red: 0.561, green: 0.569, blue: 0.969)   // #8F92F7
    static let appPrimaryDark  = Color(red: 0.267, green: 0.282, blue: 0.894)   // #4448E4
    static let appAccent       = Color(red: 0.925, green: 0.380, blue: 0.498)   // #EC617F pink
    static let appSuccess      = Color(red: 0.063, green: 0.725, blue: 0.506)   // #10B981 emerald
    static let appWarning      = Color(red: 0.992, green: 0.729, blue: 0.188)   // #FDB930 amber
    static let appDanger       = Color(red: 0.937, green: 0.267, blue: 0.267)   // #EF4444 red
    static let appBackground   = Color(red: 0.961, green: 0.957, blue: 0.988)   // #F5F4FC
    static let appSurface      = Color.white
    static let appTextPrimary  = Color(red: 0.106, green: 0.094, blue: 0.231)   // #1B183B
    static let appTextSecondary = Color(red: 0.435, green: 0.451, blue: 0.537)  // #6F7389
    static let appDivider      = Color(red: 0.906, green: 0.906, blue: 0.941)   // #E7E7F0
}

// MARK: - Gradients

struct AppGradients {
    static let primary = LinearGradient(
        colors: [Color(red: 0.388, green: 0.400, blue: 0.945),
                 Color(red: 0.529, green: 0.341, blue: 0.957)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let success = LinearGradient(
        colors: [Color(red: 0.063, green: 0.725, blue: 0.506),
                 Color(red: 0.063, green: 0.600, blue: 0.420)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let danger = LinearGradient(
        colors: [Color(red: 0.937, green: 0.267, blue: 0.267),
                 Color(red: 0.800, green: 0.180, blue: 0.180)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let warmSunset = LinearGradient(
        colors: [Color(red: 0.992, green: 0.549, blue: 0.298),
                 Color(red: 0.925, green: 0.380, blue: 0.498)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let background = LinearGradient(
        colors: [Color(red: 0.961, green: 0.957, blue: 0.988),
                 Color(red: 0.941, green: 0.937, blue: 0.980)],
        startPoint: .top, endPoint: .bottom
    )
}

// MARK: - View Modifiers

struct CardStyle: ViewModifier {
    var padding: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color.appPrimary.opacity(0.08), radius: 16, x: 0, y: 6)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var color: Color = .appPrimary
    var isFullWidth: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 28)
            .padding(.vertical, 14)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .background(color.opacity(configuration.isPressed ? 0.75 : 1))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    var isFullWidth: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(Color.appTextPrimary)
            .padding(.horizontal, 28)
            .padding(.vertical, 14)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .background(Color(white: 0.0, opacity: configuration.isPressed ? 0.12 : 0.08))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct CircleButtonStyle: ButtonStyle {
    var color: Color = .appPrimary
    var size: CGFloat = 80

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: size * 0.28, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(color.opacity(configuration.isPressed ? 0.75 : 1))
            .clipShape(Circle())
            .shadow(color: color.opacity(0.35), radius: 14, x: 0, y: 6)
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct IconButtonStyle: ButtonStyle {
    var color: Color = .appPrimary

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 22, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: 60, height: 60)
            .background(color.opacity(configuration.isPressed ? 0.75 : 1))
            .clipShape(Circle())
            .shadow(color: color.opacity(0.35), radius: 10, x: 0, y: 5)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

extension View {
    func cardStyle(padding: CGFloat = 20) -> some View {
        modifier(CardStyle(padding: padding))
    }
}
