import SwiftUI

struct CounterView: View {
    @StateObject private var vm = CounterViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                AppGradients.background.ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

                    // Main content switches based on state
                    Group {
                        if vm.isActive || vm.isFinished {
                            timerRingSection
                                .transition(.asymmetric(
                                    insertion: .scale(scale: 0.85).combined(with: .opacity),
                                    removal: .scale(scale: 0.85).combined(with: .opacity)
                                ))
                        } else {
                            pickerSection
                                .transition(.asymmetric(
                                    insertion: .scale(scale: 0.95).combined(with: .opacity),
                                    removal: .scale(scale: 0.95).combined(with: .opacity)
                                ))
                        }
                    }
                    .animation(.spring(response: 0.45, dampingFraction: 0.8), value: vm.isActive)
                    .animation(.spring(response: 0.45, dampingFraction: 0.8), value: vm.isFinished)

                    Spacer()

                    buttonSection
                        .padding(.horizontal, 32)
                        .padding(.bottom, 48)
                }
            }
            .navigationTitle("Timer")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Picker (idle state)

    private var pickerSection: some View {
        VStack(spacing: 20) {
            Text("Set Timer")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.appTextSecondary)
                .textCase(.uppercase)
                .tracking(1.5)

            HStack(spacing: 0) {
                pickerColumn(
                    selection: $vm.selectedHours,
                    range: 0..<24,
                    label: "hours"
                )
                dividerLine
                pickerColumn(
                    selection: $vm.selectedMinutes,
                    range: 0..<60,
                    label: "min"
                )
                dividerLine
                pickerColumn(
                    selection: $vm.selectedSeconds,
                    range: 0..<60,
                    label: "sec"
                )
            }
            .frame(height: 200)
            .cardStyle(padding: 0)
        }
        .padding(.horizontal, 24)
    }

    private func pickerColumn(selection: Binding<Int>, range: Range<Int>, label: String) -> some View {
        VStack(spacing: 0) {
            Picker("", selection: selection) {
                ForEach(range, id: \.self) { val in
                    Text(String(format: "%02d", val))
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .tag(val)
                }
            }
            .pickerStyle(.wheel)
            .frame(maxWidth: .infinity)

            Text(label)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.appTextSecondary)
                .tracking(0.5)
                .padding(.bottom, 12)
        }
    }

    private var dividerLine: some View {
        Rectangle()
            .fill(Color.appDivider)
            .frame(width: 1)
            .padding(.vertical, 20)
    }

    // MARK: - Ring (active/finished state)

    private var timerRingSection: some View {
        VStack(spacing: 28) {
            // Progress Ring
            ZStack {
                // Subtle outer glow
                Circle()
                    .fill(ringColor.opacity(0.06))
                    .frame(width: 300, height: 300)

                // Background track
                Circle()
                    .stroke(ringColor.opacity(0.15), lineWidth: 18)
                    .frame(width: 260, height: 260)

                // Progress arc
                Circle()
                    .trim(from: 0, to: vm.progress)
                    .stroke(
                        ringGradient,
                        style: StrokeStyle(lineWidth: 18, lineCap: .round)
                    )
                    .frame(width: 260, height: 260)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: vm.progress)

                // Center content
                VStack(spacing: 6) {
                    if vm.isFinished {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 52))
                            .foregroundStyle(Color.appSuccess)
                            .transition(.scale.combined(with: .opacity))
                        Text("Time's Up!")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.appTextPrimary)
                    } else {
                        Text(vm.timeString)
                            .font(.system(size: 58, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.appTextPrimary)
                            .monospacedDigit()
                            .contentTransition(.numericText(countsDown: true))
                            .animation(.linear(duration: 0.3), value: vm.remainingSeconds)

                        Text(vm.isPaused ? "Paused" : "remaining")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(vm.isPaused ? Color.appWarning : Color.appTextSecondary)
                            .animation(.easeInOut, value: vm.isPaused)
                    }
                }
            }

            // Elapsed / progress label
            if vm.isActive {
                HStack(spacing: 6) {
                    Image(systemName: "timer")
                        .font(.system(size: 12))
                    Text(vm.elapsedString)
                        .font(.system(size: 13, weight: .medium))
                }
                .foregroundStyle(Color.appTextSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.appPrimary.opacity(0.07))
                .clipShape(Capsule())
            }
        }
    }

    private var ringColor: Color {
        if vm.isFinished { return .appSuccess }
        if vm.isPaused   { return .appWarning }
        return .appPrimary
    }

    private var ringGradient: LinearGradient {
        if vm.isFinished { return AppGradients.success }
        if vm.isPaused {
            return LinearGradient(
                colors: [.appWarning, Color(red: 0.98, green: 0.60, blue: 0.1)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        }
        return AppGradients.primary
    }

    // MARK: - Buttons

    @ViewBuilder
    private var buttonSection: some View {
        switch vm.state {
        case .idle:
            Button("Start") { withAnimation { vm.start() } }
                .buttonStyle(CircleButtonStyle(
                    color: vm.isConfigured ? .appPrimary : Color.appTextSecondary,
                    size: 80
                ))
                .disabled(!vm.isConfigured)

        case .running:
            HStack(spacing: 40) {
                circleButton(label: "Cancel", color: Color(white: 0.0, opacity: 0.08), textColor: .appTextPrimary) {
                    withAnimation { vm.cancel() }
                }
                circleButton(label: "Pause", color: .appWarning) {
                    vm.pause()
                }
            }

        case .paused:
            HStack(spacing: 40) {
                circleButton(label: "Cancel", color: Color(white: 0.0, opacity: 0.08), textColor: .appTextPrimary) {
                    withAnimation { vm.cancel() }
                }
                circleButton(label: "Resume", color: .appSuccess) {
                    vm.resume()
                }
            }

        case .finished:
            Button("Done") { withAnimation { vm.cancel() } }
                .buttonStyle(CircleButtonStyle(color: .appPrimary, size: 80))
        }
    }

    private func circleButton(
        label: String,
        color: Color,
        textColor: Color = .white,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(textColor)
                .frame(width: 80, height: 80)
                .background(color)
                .clipShape(Circle())
                .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CounterView()
}
