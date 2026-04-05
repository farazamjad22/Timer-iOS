import SwiftUI

final class SettingsViewModel: ObservableObject {
    @AppStorage("notifications_enabled") var notificationsEnabled: Bool = true
    @AppStorage("sound_enabled")         var soundEnabled: Bool = true
    @AppStorage("haptic_enabled")        var hapticEnabled: Bool = false
    @AppStorage("user_name")             var userName: String = ""

    var displayName: String {
        userName.isEmpty ? "Tap to set name" : userName
    }

    var initials: String {
        let parts = userName.split(separator: " ").prefix(2)
        return parts.compactMap { $0.first }.map(String.init).joined().uppercased()
    }
}
