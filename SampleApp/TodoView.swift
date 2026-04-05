import SwiftUI

struct TodoView: View {
    @StateObject private var vm = TodoViewModel()
    @FocusState private var isInputFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Progress Header
                    progressHeader
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        .padding(.bottom, 20)

                    // Task List
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(vm.items) { item in
                                TodoRowView(item: item) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        vm.toggle(item)
                                    }
                                } onDelete: {
                                    withAnimation(.spring()) {
                                        if let index = vm.items.firstIndex(where: { $0.id == item.id }) {
                                            vm.delete(at: IndexSet(integer: index))
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }

                // Floating Add Bar
                VStack {
                    Spacer()
                    addBar
                }
            }
            .navigationTitle("To-Do")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !vm.items.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Clear Done") {
                            withAnimation {
                                vm.items.removeAll(where: \.isDone)
                            }
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.appDanger)
                    }
                }
            }
        }
    }

    private var progressHeader: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(vm.completedCount) of \(vm.totalCount) done")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.appTextPrimary)
                    Text(progressMessage)
                        .font(.system(size: 13))
                        .foregroundStyle(Color.appTextSecondary)
                }
                Spacer()
                ZStack {
                    Circle()
                        .stroke(Color.appPrimary.opacity(0.15), lineWidth: 4)
                        .frame(width: 44, height: 44)
                    Circle()
                        .trim(from: 0, to: vm.progress)
                        .stroke(AppGradients.primary, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 44, height: 44)
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(), value: vm.progress)
                    Text("\(Int(vm.progress * 100))%")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.appPrimary)
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.appPrimary.opacity(0.12))
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppGradients.primary)
                        .frame(width: geo.size.width * vm.progress, height: 6)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: vm.progress)
                }
            }
            .frame(height: 6)
        }
        .cardStyle()
    }

    private var progressMessage: String {
        if vm.totalCount == 0 { return "Add your first task below" }
        if vm.progress == 1   { return "All tasks complete!" }
        if vm.progress > 0.5  { return "More than halfway there!" }
        return "Keep going, you've got this!"
    }

    private var addBar: some View {
        HStack(spacing: 12) {
            TextField("Add a new task...", text: $vm.newItemText)
                .font(.system(size: 16))
                .focused($isInputFocused)
                .onSubmit { vm.addItem() }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.appSurface)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)

            Button {
                vm.addItem()
                isInputFocused = false
            } label: {
                Image(systemName: "arrow.up")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(vm.isInputEmpty ? Color.appTextSecondary : Color.appPrimary)
                    .clipShape(Circle())
                    .shadow(color: Color.appPrimary.opacity(vm.isInputEmpty ? 0 : 0.4), radius: 10, x: 0, y: 5)
            }
            .disabled(vm.isInputEmpty)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: vm.isInputEmpty)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
        .padding(.top, 12)
        .background(
            Color.appBackground
                .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: -4)
        )
    }
}

struct TodoRowView: View {
    let item: TodoItem
    let onToggle: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Button(action: onToggle) {
                ZStack {
                    Circle()
                        .stroke(item.isDone ? Color.appSuccess : Color.appDivider, lineWidth: 2)
                        .frame(width: 26, height: 26)
                    if item.isDone {
                        Circle()
                            .fill(Color.appSuccess)
                            .frame(width: 26, height: 26)
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: item.isDone)
            }
            .buttonStyle(.plain)

            Text(item.title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(item.isDone ? Color.appTextSecondary : Color.appTextPrimary)
                .strikethrough(item.isDone, color: Color.appTextSecondary)
                .animation(.easeInOut(duration: 0.2), value: item.isDone)

            Spacer()

            Button(action: onDelete) {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.appTextSecondary)
                    .frame(width: 26, height: 26)
                    .background(Color.appDivider)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .cardStyle(padding: 16)
    }
}

#Preview {
    TodoView()
}
