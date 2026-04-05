# SampleApp

A clean, modern iOS app built with SwiftUI following the **MVVM** architecture. The app includes three core features: a countdown timer, a to-do list, and a settings panel — all wrapped in a polished, cohesive design system.

---

## Screenshots

> _Add screenshots here after running on simulator or device._

---

## Features

### Timer
- Set hours, minutes, and seconds using an Apple-style wheel picker
- Animated circular countdown ring that changes color by state
  - **Indigo** — running
  - **Amber** — paused
  - **Emerald** — finished
- Start, Pause, Resume, and Cancel controls
- Elapsed time indicator while the timer is running
- "Time's Up!" completion screen

### To-Do List
- Add, complete, and delete tasks
- Circular progress ring and progress bar showing completion percentage
- Motivational status message based on progress
- "Clear Done" button to remove completed tasks
- Smooth spring animations throughout

### Settings
- Set a display name (persisted with `@AppStorage`)
- Toggle notifications and sound preferences
- Haptic feedback toggle
- App version and build info

---

## Architecture

This project follows the **MVVM (Model-View-ViewModel)** pattern.

```
SampleApp/
├── App/
│   ├── SampleAppApp.swift       — App entry point
│   └── ContentView.swift        — Tab bar root
├── Models/
│   └── TodoItem.swift           — Todo data model
├── ViewModels/
│   ├── CounterViewModel.swift   — Timer state & Combine-based countdown
│   ├── TodoViewModel.swift      — Todo list logic
│   └── SettingsViewModel.swift  — Settings & AppStorage bindings
├── Views/
│   ├── CounterView.swift        — Timer UI (picker + ring)
│   ├── TodoView.swift           — To-do list UI
│   └── SettingsView.swift       — Settings form UI
└── Theme/
    └── AppTheme.swift           — Colors, gradients, and button styles
```

| Layer | Responsibility |
|---|---|
| **Model** | Plain data structs (`TodoItem`) |
| **ViewModel** | Business logic, state, Combine timers — no SwiftUI imports except where needed |
| **View** | Pure rendering, binds to ViewModel via `@StateObject` / `@Published` |

---

## Tech Stack

- **Swift 5.9+**
- **SwiftUI** — declarative UI
- **Combine** — reactive timer in `CounterViewModel`
- **@AppStorage** — lightweight persistent settings
- **No third-party dependencies**

---

## Requirements

| Requirement | Version |
|---|---|
| iOS | 17.0+ |
| Xcode | 15.0+ |
| Swift | 5.9+ |

---

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/SampleApp.git
   ```

2. Open the project in Xcode:
   ```bash
   open SampleApp/SampleApp.xcodeproj
   ```

3. Select a simulator or connected device and press **⌘R** to run.

> No dependencies to install — the project uses only Apple frameworks.

---

## Design System

All colors, gradients, and button styles live in `AppTheme.swift` for easy customization.

| Token | Value | Usage |
|---|---|---|
| `appPrimary` | `#6366F1` Indigo | Primary actions, timer ring |
| `appSuccess` | `#10B981` Emerald | Positive states, completed |
| `appWarning` | `#FDB930` Amber | Paused state |
| `appDanger` | `#EF4444` Red | Destructive actions |
| `appBackground` | `#F5F4FC` | Screen backgrounds |

---

## License

This project is available under the [MIT License](LICENSE).
