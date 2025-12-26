# ToastUI 🎉

A powerful, all-in-one notification and overlay system for SwiftUI with toasts, dialogs, UI overlays, custom loaders, and Rive animation support - built with modern Swift concurrency and environment-based API.

![Platform](https://img.shields.io/badge/platform-iOS%2016%2B%20%7C%20macOS%2013.1%2B-blue)
![Swift](https://img.shields.io/badge/Swift-6.2+-orange)
![License](https://img.shields.io/badge/license-MIT-green)

## Features ✨

### 🍞 Toast Notifications
- **Simple API** - Just `@Environment(\.toast) var toast`
- **6 Toast Types** - Success, Error, Warning, Info, Progress, Glass Effect
- **Glass Effect** - Beautiful translucent glass toast (iOS 26+, auto-fallback to regular material)
- **3 Alignments** - Top, Center, Bottom
- **Custom Icons** - Use any SwiftUI View as icon
- **Custom Colors** - Brand your toasts
- **Copy to Clipboard** - One-tap copy for errors
- **Multiple Toasts** - Stack with depth effect
- **Smart Auto-dismiss** - Proper timer management

### 🎭 UI Overlay System
- **5 Built-in States** - Loading, Empty, Failure, Success, Idle
- **Custom Views** - Create any overlay with SwiftUI
- **Rive Animations** - Interactive animated overlays
- **Custom Loaders** - Provide your own loading indicators
- **Glass/Solid Styles** - Choose your visual style with full customization
- **Text Styling** - Complete control over fonts, colors, and weights
- **Auto-dismiss** - Configurable auto-dismiss timers
- **Close Button** - Optional dismissal
- **Retry Support** - Built-in retry callbacks

### 💬 Dialog System
- **Custom Dialogs** - Build with SwiftUI views
- **Pre-built Components** - Alert, Confirmation
- **Smooth Animations** - Bouncy slide-up
- **Backdrop Control** - Tap to dismiss or require action

### 🚀 General
- **SwiftUI Native** - Pure SwiftUI
- **iOS 16+ & macOS 13.1+** - Cross-platform
- **Swift 6 Ready** - Modern concurrency
- **Environment-based** - Seamless integration

---

## Requirements

- iOS 16.0+ / macOS 13.1+
- Swift 6.2+
- Xcode 16.2+

---

## Installation

### Swift Package Manager

1. In Xcode: **File** → **Add Package Dependencies**
2. Enter: `https://github.com/debuging-life/ToastUI.git`
3. Select **Up to Next Major Version** with `3.2.0`

Or in `Package.swift`:
```swift
dependencies: [
    .package(url: "https://github.com/debuging-life/ToastUI.git", from: "3.2.0")
]
```

---

## Quick Start

### Setup (One-time)

Add `.setupToastUI()` to your root view:

```swift
import SwiftUI
import ToastUI

@main
struct YourApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .setupToastUI() // ✅ Add this
        }
    }
}
```

### Basic Toast Usage

```swift
import SwiftUI
import ToastUI

struct ContentView: View {
    @Environment(\.toast) var toast

    var body: some View {
        VStack(spacing: 20) {
            Button("Show Success") {
                toast.success("Operation completed!")
            }

            Button("Show Error") {
                toast.error("Something went wrong")
            }

            Button("Show Warning") {
                toast.warning("Please check your input")
            }
        }
    }
}
```

---

## 📖 Complete Guide

## Table of Contents

1. [Toast Notifications](#toast-notifications)
2. [UI Overlay System](#ui-overlay-system)
3. [Overlay Configuration](#overlay-configuration)
4. [Custom Loaders](#custom-loaders)
5. [Custom Overlays](#custom-overlays)
6. [Rive Animations](#rive-animations)
7. [Dialog System](#dialog-system)
8. [Advanced Features](#advanced-features)

---

## Toast Notifications

### Basic Toast Types

```swift
@Environment(\.toast) var toast

// Success
toast.success("Saved successfully!")

// Error
toast.error("Failed to save")

// Warning
toast.warning("Low battery")

// Info
toast.info("New update available")

// Glass effect (iOS 26+, auto-fallback)
toast.glass("Beautiful glass toast", alignment: .top)

// Progress (single, non-stacking)
toast.progress("Uploading...", alignment: .center)
```

### Toast with Message

```swift
toast.success(
    "Payment Complete",
    message: "Your order #12345 has been confirmed"
)
```

### Custom Alignment

```swift
toast.success("Top toast", alignment: .top)
toast.info("Center toast", alignment: .center)
toast.error("Bottom toast", alignment: .bottom)
```

### Custom Icon

```swift
toast.success("Custom icon") {
    Image(systemName: "star.fill")
        .font(.largeTitle)
        .foregroundStyle(.yellow)
}
```

### Custom Colors

```swift
toast.show(
    ToastMessage(
        type: .custom(
            backgroundColor: .purple,
            foregroundColor: .white,
            iconColor: .yellow
        ),
        title: "Custom Colors",
        alignment: .top
    )
)
```

### Copy to Clipboard

```swift
// Shows a copy button that copies the message
toast.error("Error: File not found", enableCopy: true)
```

---

## UI Overlay System

The UI Overlay system provides a powerful way to show loading states, empty states, errors, and custom content over your UI.

### Basic Usage

```swift
struct MyView: View {
    @State private var uiState: UIState = .idle

    var body: some View {
        YourContent()
            .uiOverlay(state: $uiState)
    }

    func loadData() {
        uiState = .loading(message: "Loading...")

        // After loading
        uiState = .success(message: "Data loaded!")

        // Or on error
        uiState = .failure(message: "Failed to load")
    }
}
```

### Built-in States

```swift
// Loading
uiState = .loading(message: "Please wait...")

// Empty state
uiState = .empty(message: "No data found")

// Failure
uiState = .failure(message: "Network error")

// Success
uiState = .success(message: "Done!")

// Idle (dismisses overlay)
uiState = .idle
```

### Retry Callback

```swift
.uiOverlay(
    state: $uiState,
    onRetry: {
        // Retry logic
        await loadData()
    }
)
```

### Custom Icons

```swift
// Empty state with custom icon
uiState = .empty(message: "No favorites yet") {
    Image(systemName: "heart.slash")
        .font(.system(size: 50))
        .foregroundStyle(.pink)
}

// Success with custom icon
uiState = .success(message: "Uploaded!") {
    Image(systemName: "cloud.fill")
        .font(.system(size: 50))
        .foregroundStyle(.blue)
}
```

---

## Overlay Configuration

The configuration system provides clean, sophisticated control over overlay appearance and behavior.

### Configuration Structure

```swift
UIOverlayConfiguration(
    style: OverlayStyle,                    // Glass or solid background
    titleStyle: TextStyleConfiguration,     // Title text styling
    messageStyle: TextStyleConfiguration,   // Message text styling
    showCloseButton: Bool,                  // Show close button
    autoDismissAfter: TimeInterval?         // Auto-dismiss duration
)
```

### Overlay Styles

#### Glass Effect
```swift
.glass(
    intensity: GlassIntensity = .ultraThin,
    backdropOpacity: Double = 0.3,
    cornerRadius: CGFloat = 20,
    maxWidth: CGFloat = 340
)
```

**Glass Intensity Options:**
- `.ultraThin` - Lightest blur effect (default)
- `.thin` - Light blur effect
- `.regular` - Medium blur effect
- `.thick` - Heavy blur effect
- `.ultraThick` - Heaviest blur effect

#### Solid Color
```swift
.solid(
    backgroundColor: Color,
    opacity: Double = 1.0,
    backdropOpacity: Double = 0.3,
    cornerRadius: CGFloat = 20,
    maxWidth: CGFloat = 340
)
```

### Text Style Configuration

```swift
TextStyleConfiguration(
    color: Color = .primary,
    font: Font = .headline,
    fontWeight: Font.Weight = .semibold
)
```

**Built-in Presets:**
- `.title` - Default title style (primary, headline, semibold)
- `.message` - Default message style (secondary, subheadline, regular)
- `.largeBoldTitle` - Large impactful title
- `.smallLightMessage` - Subtle small message

### Configuration Examples

#### Example 1: Simple Glass Effect
```swift
.uiOverlay(
    state: $uiState,
    configuration: .init(
        style: .glass()
    )
)
```

#### Example 2: Glass Effect with Different Intensities
```swift
// Ultra thin glass (lightest)
.uiOverlay(
    state: $uiState,
    configuration: .glass
)

// Thick glass (heavy blur)
.uiOverlay(
    state: $uiState,
    configuration: .glassThick
)

// Custom glass intensity
.uiOverlay(
    state: $uiState,
    configuration: .glass(intensity: .regular, backdropOpacity: 0.5)
)
```

#### Example 3: Custom Glass with Modified Properties
```swift
.uiOverlay(
    state: $uiState,
    configuration: .init(
        style: .glass(
            intensity: .thick,
            backdropOpacity: 0.5,
            cornerRadius: 24,
            maxWidth: 400
        ),
        showCloseButton: true
    )
)
```

#### Example 4: Solid Color with Custom Text Styles
```swift
.uiOverlay(
    state: $uiState,
    configuration: .init(
        style: .solid(
            backgroundColor: .white,
            opacity: 1.0,
            backdropOpacity: 0.5,
            cornerRadius: 24,
            maxWidth: 380
        ),
        titleStyle: TextStyleConfiguration(
            color: .blue,
            font: .title2,
            fontWeight: .bold
        ),
        messageStyle: TextStyleConfiguration(
            color: .gray,
            font: .body,
            fontWeight: .regular
        ),
        showCloseButton: true,
        autoDismissAfter: 3.0
    )
)
```

#### Example 4: Dark Theme
```swift
.uiOverlay(
    state: $uiState,
    configuration: .init(
        style: .solid(
            backgroundColor: .black,
            opacity: 0.95,
            backdropOpacity: 0.4
        ),
        titleStyle: TextStyleConfiguration(
            color: .white,
            font: .headline,
            fontWeight: .semibold
        ),
        messageStyle: TextStyleConfiguration(
            color: .white.opacity(0.7),
            font: .subheadline,
            fontWeight: .regular
        ),
        showCloseButton: true
    )
)
```

#### Example 5: Using Presets
```swift
// Built-in glass presets
.uiOverlay(state: $uiState, configuration: .glass)           // Ultra-thin (default)
.uiOverlay(state: $uiState, configuration: .glassThin)       // Thin blur
.uiOverlay(state: $uiState, configuration: .glassRegular)    // Regular blur
.uiOverlay(state: $uiState, configuration: .glassThick)      // Thick blur
.uiOverlay(state: $uiState, configuration: .glassUltraThick) // Ultra-thick blur
.uiOverlay(state: $uiState, configuration: .glassWithClose)  // Glass with close button

// Solid color presets
.uiOverlay(state: $uiState, configuration: .default)         // White background
.uiOverlay(state: $uiState, configuration: .solidBlack)      // Black background

// Custom text styles with preset
.uiOverlay(
    state: $uiState,
    configuration: .init(
        style: .glass(intensity: .thick),
        titleStyle: .largeBoldTitle,
        messageStyle: .smallLightMessage
    )
)
```

### Creating Custom Text Style Presets

```swift
extension TextStyleConfiguration {
    static let errorStyle = TextStyleConfiguration(
        color: .red,
        font: .title3,
        fontWeight: .bold
    )

    static let successStyle = TextStyleConfiguration(
        color: .green,
        font: .headline,
        fontWeight: .semibold
    )
}

// Usage
.uiOverlay(
    state: $uiState,
    configuration: .init(
        style: .glass(),
        titleStyle: .errorStyle,
        messageStyle: .message
    )
)
```

---

## Custom Loaders

Create your own loading indicators or use the default one.

### Default Loader

```swift
// Uses built-in gradient circle loader
uiState = .loading(message: "Loading...")
```

### Custom Loader

```swift
// Bouncing dots
uiState = .loading(message: "Please wait...") {
    HStack(spacing: 8) {
        ForEach(0..<3) { index in
            Circle()
                .fill(Color.blue)
                .frame(width: 12, height: 12)
                .offset(y: animating ? -15 : 0)
                .animation(
                    .easeInOut(duration: 0.6)
                    .repeatForever()
                    .delay(Double(index) * 0.2),
                    value: animating
                )
        }
    }
}
```

### System ProgressView

```swift
uiState = .loading(message: "Loading...") {
    ProgressView()
        .progressViewStyle(.circular)
        .scaleEffect(1.5)
        .tint(.blue)
}
```

### Custom Animated Loader

```swift
uiState = .loading(message: "Uploading...") {
    ZStack {
        ForEach(0..<3, id: \.self) { index in
            Circle()
                .stroke(Color.blue.opacity(0.5), lineWidth: 2)
                .scaleEffect(scale + CGFloat(index) * 0.3)
                .opacity(opacity - Double(index) * 0.3)
        }
    }
    .onAppear {
        withAnimation(
            .easeInOut(duration: 1.5)
            .repeatForever(autoreverses: false)
        ) {
            scale = 1.5
            opacity = 0
        }
    }
}
```

---

## Custom Overlays

Create completely custom overlay content.

### Basic Custom Overlay

```swift
uiState = .custom {
    VStack(spacing: 16) {
        Image(systemName: "star.fill")
            .font(.system(size: 60))
            .foregroundStyle(.yellow)

        Text("You earned a star!")
            .font(.title2)
            .fontWeight(.bold)

        Button("Awesome!") {
            uiState = .idle
        }
        .buttonStyle(.borderedProminent)
    }
    .padding()
}
```

### Interactive Rating Overlay

```swift
@State private var rating = 0

uiState = .custom(id: "rating") {
    VStack(spacing: 20) {
        Text("Rate Your Experience")
            .font(.title2)
            .fontWeight(.bold)

        HStack(spacing: 12) {
            ForEach(1...5, id: \.self) { star in
                Button {
                    rating = star
                } label: {
                    Image(systemName: star <= rating ? "star.fill" : "star")
                        .font(.system(size: 32))
                        .foregroundStyle(star <= rating ? .yellow : .gray)
                }
            }
        }

        if rating > 0 {
            Text("Selected: \(rating) stars")
                .font(.caption)
        }
    }
    .padding()
}
```

---

## Rive Animations

Integrate Rive animations into your overlays.

### Setup

1. Add your `.riv` file to your Xcode project
2. Include it in "Copy Bundle Resources"
3. Use the `.riveAnimation()` modifier

### Basic Rive Overlay

```swift
uiState = .riveAnimation(
    riveName: "loading_spinner",
    stateMachineName: "State Machine 1",
    title: "Processing",
    message: "Please wait..."
)
```

### Rive with Animation Name

```swift
uiState = .riveAnimation(
    riveName: "success_animation",
    animationName: "celebrate",
    title: "Success!",
    message: "Task completed"
)
```

---

## Dialog System

### Basic Dialog

```swift
@State private var showDialog = false

Button("Show Dialog") {
    showDialog = true
}
.dialog(isPresented: $showDialog) {
    VStack(spacing: 20) {
        Text("Custom Dialog")
            .font(.title)

        Text("This is a custom dialog")

        Button("Close") {
            showDialog = false
        }
    }
    .padding()
}
```

### Dialog Configuration

```swift
.dialog(
    config: DialogConfiguration(
        backgroundColor: .black.opacity(0.6),
        cornerRadius: 24,
        dismissOnBackgroundTap: true,
        animationDuration: 0.35
    ),
    isPresented: $showDialog
) {
    DialogContent()
}
```

---

## Advanced Features

### Combining Toasts and Overlays

```swift
struct MyView: View {
    @Environment(\.toast) var toast
    @State private var uiState: UIState = .idle

    func performAction() async {
        // Show loading overlay
        uiState = .loading(message: "Processing...")

        do {
            try await someAsyncTask()

            // Dismiss overlay
            uiState = .idle

            // Show success toast
            toast.success("Task completed!")
        } catch {
            // Dismiss overlay
            uiState = .idle

            // Show error toast
            toast.error("Task failed", enableCopy: true)
        }
    }
}
```

### ViewModel Integration

```swift
@Observable
class MyViewModel {
    var uiState: UIState = .idle

    func loadData() async {
        uiState = .loading(message: "Loading...")

        do {
            let data = try await api.fetchData()
            uiState = data.isEmpty ? .empty(message: "No data") : .idle
        } catch {
            uiState = .failure(message: error.localizedDescription)
        }
    }
}

struct MyView: View {
    @State private var viewModel = MyViewModel()

    var body: some View {
        Content()
            .uiOverlay(
                state: $viewModel.uiState,
                onRetry: {
                    await viewModel.loadData()
                }
            )
    }
}
```

### Network Request Pattern

```swift
func fetchUsers() async {
    uiState = .loading(message: "Fetching users...") {
        // Custom loader
        ProgressView()
            .scaleEffect(1.5)
    }

    do {
        let users = try await api.getUsers()

        if users.isEmpty {
            uiState = .empty(message: "No users found")
        } else {
            // Process users
            uiState = .idle
            toast.success("Loaded \(users.count) users")
        }
    } catch {
        uiState = .failure(message: "Failed to fetch users")
    }
}
```

---

## Platform Support

### iOS 26+ Glass Effect

On iOS 26+, the `.glass` style uses `.ultraThinMaterial` for a true glass effect.

### iOS 16-25 Fallback

On iOS 16-25, the `.glass` style automatically falls back to `.regularMaterial`.

### macOS Support

Full support on macOS 13.1+. Toast notifications use overlay-based rendering on macOS.

---

## API Reference

### Toast API

```swift
@Environment(\.toast) var toast

// Show methods
toast.show(_ message: ToastMessage)
toast.success(_ title: String, message: String? = nil, alignment: ToastAlignment = .top)
toast.error(_ title: String, message: String? = nil, alignment: ToastAlignment = .top, enableCopy: Bool = false)
toast.warning(_ title: String, message: String? = nil, alignment: ToastAlignment = .top)
toast.info(_ title: String, message: String? = nil, alignment: ToastAlignment = .top)
toast.glass(_ title: String, message: String? = nil, alignment: ToastAlignment = .top)
toast.progress(_ title: String, message: String? = nil, alignment: ToastAlignment = .center)

// Dismiss
toast.dismiss(id: UUID)
```

### UIState Enum

```swift
public enum UIState {
    case idle
    case loading(message: String? = nil, loader: AnyView? = nil)
    case empty(message: String = "No data found", icon: AnyView? = nil)
    case failure(message: String, icon: AnyView? = nil)
    case success(message: String, icon: AnyView? = nil)
    case custom(id: String, view: AnyView)
    case rive(id: String, riveName: String, stateMachineName: String? = nil, animationName: String? = nil, title: String? = nil, message: String? = nil)
}
```

### OverlayStyle Enum

```swift
public enum OverlayStyle {
    case glass(
        backdropOpacity: Double = 0.3,
        cornerRadius: CGFloat = 20,
        maxWidth: CGFloat = 340
    )

    case solid(
        backgroundColor: Color,
        opacity: Double = 1.0,
        backdropOpacity: Double = 0.3,
        cornerRadius: CGFloat = 20,
        maxWidth: CGFloat = 340
    )
}
```

### TextStyleConfiguration

```swift
public struct TextStyleConfiguration {
    public let color: Color
    public let font: Font
    public let fontWeight: Font.Weight

    // Presets
    public static let title: TextStyleConfiguration
    public static let message: TextStyleConfiguration
    public static let largeBoldTitle: TextStyleConfiguration
    public static let smallLightMessage: TextStyleConfiguration
}
```

### UIOverlayConfiguration

```swift
public struct UIOverlayConfiguration {
    public let style: OverlayStyle
    public let titleStyle: TextStyleConfiguration
    public let messageStyle: TextStyleConfiguration
    public let showCloseButton: Bool
    public let autoDismissAfter: TimeInterval?

    // Computed properties from style
    public var backdropOpacity: Double
    public var cornerRadius: CGFloat
    public var maxWidth: CGFloat
    public var backgroundColor: Color?
    public var overlayOpacity: Double?
}
```

---

## Examples

Check out the included example files:
- `ToastExamplesView.swift` - Toast notifications
- `CustomLoaderExamples.swift` - Custom loading indicators
- `CustomUIStateExamples.swift` - Custom overlays and Rive animations
- `UIOverlayAdvancedExamples.swift` - Advanced overlay features
- `UIOverlayConfigurationExamples.swift` - Configuration examples

---

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

## License

ToastUI is available under the MIT license. See the LICENSE file for more info.

---

## Credits

Created by [Pardip Bhatti](https://github.com/debuging-life)

---

## Support

If you find this package useful, please consider:
- ⭐️ Starring the repo
- 🐛 Reporting issues
- 💡 Suggesting new features
- 📖 Improving documentation

---

**Made with ❤️ for the SwiftUI community**
