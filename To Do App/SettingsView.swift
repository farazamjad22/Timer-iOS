import SwiftUI

struct SettingsView: View {
    @StateObject private var vm = SettingsViewModel()
    @State private var showNameSheet = false
    @State private var tempName = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Profile Card
                        profileCard
                            .padding(.horizontal, 20)
                            .padding(.top, 8)

                        // Notifications Section
                        settingsSection(title: "Notifications") {
                            settingsToggleRow(
                                icon: "bell.fill", iconColor: .appPrimary,
                                title: "Enable Notifications",
                                isOn: $vm.notificationsEnabled
                            )
                            Divider().padding(.leading, 56)
                            settingsToggleRow(
                                icon: "speaker.wave.2.fill", iconColor: .appAccent,
                                title: "Sound",
                                isOn: $vm.soundEnabled
                            )
                            .opacity(vm.notificationsEnabled ? 1 : 0.4)
                            .disabled(!vm.notificationsEnabled)
                        }
                        .padding(.horizontal, 20)

                        // Haptics Section
                        settingsSection(title: "Interaction") {
                            settingsToggleRow(
                                icon: "hand.tap.fill", iconColor: .appSuccess,
                                title: "Haptic Feedback",
                                isOn: $vm.hapticEnabled
                            )
                        }
                        .padding(.horizontal, 20)

                        // About Section
                        settingsSection(title: "About") {
                            settingsInfoRow(icon: "app.fill", iconColor: .appPrimaryLight,
                                           title: "Version", value: "1.0.0")
                            Divider().padding(.leading, 56)
                            settingsInfoRow(icon: "hammer.fill", iconColor: .appWarning,
                                           title: "Build", value: "1")
                            Divider().padding(.leading, 56)
                            settingsInfoRow(icon: "swift", iconColor: Color(red: 0.9, green: 0.35, blue: 0.2),
                                           title: "Framework", value: "SwiftUI")
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showNameSheet) {
                nameSheet
            }
        }
    }

    private var profileCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppGradients.primary)
                    .frame(width: 60, height: 60)
                if vm.initials.isEmpty {
                    Image(systemName: "person.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                } else {
                    Text(vm.initials)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
            }
            .shadow(color: Color.appPrimary.opacity(0.35), radius: 10, x: 0, y: 5)

            VStack(alignment: .leading, spacing: 4) {
                Text(vm.userName.isEmpty ? "Your Name" : vm.userName)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color.appTextPrimary)
                Text(vm.userName.isEmpty ? "Tap to set your name" : "To Do App User")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.appTextSecondary)
            }

            Spacer()

            Button {
                tempName = vm.userName
                showNameSheet = true
            } label: {
                Image(systemName: "pencil")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.appPrimary)
                    .frame(width: 34, height: 34)
                    .background(Color.appPrimary.opacity(0.1))
                    .clipShape(Circle())
            }
        }
        .cardStyle()
    }

    private var nameSheet: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(AppGradients.primary)
                    Text("What's your name?")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(Color.appTextPrimary)
                    Text("This is displayed on your profile card.")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.appTextSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 32)

                TextField("Enter your name", text: $tempName)
                    .font(.system(size: 17))
                    .padding(16)
                    .background(Color.appBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .padding(.horizontal, 24)

                Button("Save") {
                    vm.userName = tempName
                    showNameSheet = false
                }
                .buttonStyle(PrimaryButtonStyle(isFullWidth: true))
                .padding(.horizontal, 24)

                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") { showNameSheet = false }
                        .foregroundStyle(Color.appTextSecondary)
                }
            }
        }
        .presentationDetents([.medium])
    }

    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.appTextSecondary)
                .textCase(.uppercase)
                .tracking(1)
                .padding(.leading, 4)

            VStack(spacing: 0) {
                content()
            }
            .cardStyle(padding: 0)
        }
    }

    private func settingsToggleRow(icon: String, iconColor: Color, title: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 14) {
            iconBadge(icon: icon, color: iconColor)
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.appTextPrimary)
            Spacer()
            Toggle("", isOn: isOn)
                .tint(.appPrimary)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private func settingsInfoRow(icon: String, iconColor: Color, title: String, value: String) -> some View {
        HStack(spacing: 14) {
            iconBadge(icon: icon, color: iconColor)
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.appTextPrimary)
            Spacer()
            Text(value)
                .font(.system(size: 15))
                .foregroundStyle(Color.appTextSecondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private func iconBadge(icon: String, color: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(color)
                .frame(width: 32, height: 32)
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    SettingsView()
}
