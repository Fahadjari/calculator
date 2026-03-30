# 🧮 Flutter Calculator

A **production-ready** Flutter calculator app with a premium dark-mode UI, smooth animations, and clean architecture.

---

## ✨ Features

| Feature | Details |
|---------|---------|
| **UI** | Material 3, DM Sans font, rounded buttons, soft shadows |
| **Dark / Light** | Toggle via the sun/moon icon (top-right) |
| **Animations** | Scale press on every button, AnimatedSwitcher for display |
| **Haptic feedback** | Light → digits, Medium → clear/backspace, Heavy → equals |
| **Architecture** | `/logic` ↔ `/widgets` ↔ `/screens` — fully separated |
| **State** | `ChangeNotifier` + `Provider` — minimal, no boilerplate |
| **Tests** | Unit tests for all arithmetic + edge cases |

---

## 🗂 Project Structure

```
lib/
├── main.dart                   # Entry point, theme toggle
├── logic/
│   ├── calculator_logic.dart   # Pure computation (no Flutter deps)
│   └── calculator_provider.dart # ChangeNotifier state bridge
├── theme/
│   └── app_theme.dart          # All colors, typography, button roles
├── widgets/
│   ├── calc_button.dart        # Reusable animated button
│   ├── calc_display.dart       # Animated display area
│   └── button_grid.dart        # Grid of all 19 buttons
└── screens/
    └── calculator_screen.dart  # Root screen composition
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK **≥ 3.0.0**
- Dart **≥ 3.0.0** (null safety)

### Install & Run

```bash
# 1. Navigate into project
cd flutter_calculator

# 2. Get dependencies
flutter pub get

# 3. Run on device / emulator
flutter run

# 4. Run unit tests
flutter test
```

### Build APK

```bash
# Debug APK
flutter build apk --debug

# Release APK (requires signing)
flutter build apk --release

# Release App Bundle (for Play Store)
flutter build appbundle --release
```

---

## 🏗 Architecture

```
UI Action (button tap)
       │
       ▼
 CalcButton.onTap()
       │
       ▼
 CalculatorProvider.dispatch(action)   ← ChangeNotifier
       │
       ▼
 CalculatorLogic.process(state, action) ← Pure Dart, testable
       │
       ▼
 New CalculatorState (immutable record)
       │
       ▼
 notifyListeners() → Widget tree rebuilds
```

---

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `provider ^6.1.2` | State management |
| `google_fonts ^6.2.1` | DM Sans typography |
| `flutter_animate ^4.5.0` | Animation helpers |
| `vibration ^1.9.0` | Haptic feedback |

---

## 🧪 Tests

```bash
flutter test
```

Tests cover:
- Single and multi-digit input
- All four arithmetic operations  
- Division by zero → `"Error"`
- Decimal input chaining
- Clear, backspace, sign toggle, percent

---

## 📱 Screenshots

| Dark Mode | Light Mode |
|-----------|------------|
| Deep charcoal background | Soft white/grey surface |
| Purple-tinted operators | Indigo operators |
| Glowing equals button | Solid indigo equals |
