# To Do App

A clean, modern iOS app built with SwiftUI following the **MVVM** architecture. The app includes three core features: a countdown timer, a to-do list, and a settings panel — all wrapped in a polished, cohesive design system.

---

## Screenshots

<img width="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-04-05 at 23 12 03" src="https://github.com/user-attachments/assets/0dbf2df3-7681-4955-8368-6472ec5dcbe2" />
<img width="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-04-05 at 23 12 25" src="https://github.com/user-attachments/assets/c12e4e38-3bec-4618-a7ca-05dd43bed97c" />
<img width="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-04-05 at 23 13 13" src="https://github.com/user-attachments/assets/31f55e2c-0b4a-4120-aaec-a7ebf50771ee" />
<img width="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-04-05 at 23 13 31" src="https://github.com/user-attachments/assets/d033c80d-f5c0-4f4d-b159-72af575a3e13" />

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
To Do App/
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
   git clone https://github.com/<your-username>/to-do-app.git
   ```

2. Open the project in Xcode:
   ```bash
   open SampleApp/SampleApp.xcodeproj  # or double-click SampleApp.xcodeproj
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
