import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CounterView()
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }

            TodoView()
                .tabItem {
                    Label("To-Do", systemImage: "checklist")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(.appPrimary)
    }
}

#Preview {
    ContentView()
}
