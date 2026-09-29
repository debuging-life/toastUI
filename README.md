# ToastUI 🎉

A powerful notification system for SwiftUI with toasts, progress overlays, and dialogs - built with modern Swift concurrency and environment-based API.

![Platform](https://img.shields.io/badge/platform-iOS%2017%2B%20%7C%20macOS%2014%2B%20%7C%20watchOS%2010%2B-blue)
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
- **Actions** - an Undo / Retry / View button inside the toast, or a tap handler on the whole thing
- **Swipe to dismiss** - flick a toast away, in the direction it came from
- **Grouping** - repeat events replace each other instead of piling up
- **Sticky** - a toast that waits for the user ("You're offline")
- **Haptics** - opt-in success/error feedback, per-toast override, or your own
- **VoiceOver** - toasts are announced, buttons are labelled

### 🎞️ Rive Animations (optional `ToastUIRive` product)
- **Animated icons** - any `.riv` file as a toast icon
- **Animated loading** - a Rive loading animation, driven by real progress through a state-machine input
- **Celebrations** - full-screen moments for streaks, personal bests and finished challenges
- **Safe by default** - a missing file or Reduce Motion falls back to an SF Symbol instead of crashing
- **Opt-in** - the core `ToastUI` product still has zero dependencies

### 🧵 Async loading
- **`withLoading`** - runs your work behind the overlay and always takes it away again, on success, error or cancellation
- **Progress reporting** - forward 0...1 straight from an upload
- **Cancellable** - a Cancel button that cancels the task

### ⏳ Progress Overlay
- **Independent System** - Separate from toasts for full-screen progress indication
- **Highly Customizable** - Control size, colors, position, and style
- **Multiple Positions** - Top, Center, Bottom, or Custom coordinates
- **Glass Effect Support** - Beautiful translucent glass overlay (iOS 26+)
- **Custom Views** - Pass your own SwiftUI views for complete control
- **Blocking/Non-blocking** - Choose whether to block user interaction
- **Clear Background** - Option for transparent background showing only content
- **Dismissible** - Optional close button for user dismissal
- **Determinate progress** - pass `progress: 0...1` for a percentage ring, and update it in place
- **Cancellable** - pass `onCancel` for uploads and long syncs

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
    .package(url: "https://github.com/debuging-life/ToastUI.git", from: "3.3.0")
]
```

The package ships **two products**:

| Product | Contents | Dependencies |
| --- | --- | --- |
| `ToastUI` | toasts, progress overlays, dialogs | none |
| `ToastUIRive` | Rive icons, loading animations, celebrations | [rive-ios](https://github.com/rive-app/rive-ios) |

Add `ToastUIRive` only if you want Rive; apps that don't never link the runtime.



---

## Actions, taps and sticky toasts

Build a `ToastMessage` when you want more than a title, and present it:

```swift
toast.present(
    ToastMessage(
        title: "Activity deleted",
        type: .info,
        action: ToastAction(title: "Undo") { store.undoDelete() }
    )
)

// Tapping the toast opens the run that just synced
toast.present(
    ToastMessage(title: "Run synced", type: .success, onTap: { router.push(.activity(id: id)) })
)

// Repeat events replace each other instead of stacking
toast.present(ToastMessage(title: "GPS signal lost", type: .warning, groupID: "gps"))

// Stays until you dismiss it by id
toast.present(ToastMessage(title: "You're offline", type: .warning, isSticky: true))
```

Toasts can be flicked away — up from the top stack, down from the bottom. When the
stack is full the least important toast makes way, so an error is never pushed off
screen by a run of info messages.

## Async loading 🧵

```swift
let run = try await toast.withLoading("Uploading run", determinate: true, cancellable: true,
                                      errorTitle: "Upload failed") { report in
    try await api.upload(run) { report($0) }   // 0...1
}
```

The overlay appears, follows the progress, and is taken away on success, on a thrown
error, and on cancellation — the usual way a loading overlay gets stuck on screen.

## Haptics

**Off by default.** Turn them on once, wherever you configure the app:

```swift
ToastManager.shared.hapticsEnabled = true       // success, error and warning
ToastManager.shared.haptics = { type in myHaptics.play(type) }   // or use your own
```

A single toast can override the app-wide setting either way — handy when haptics are
off generally but a personal best deserves one:

```swift
toast.present(ToastMessage(title: "New personal best", type: .success, playsHaptic: true))
toast.present(ToastMessage(title: "Synced", type: .info, playsHaptic: false))
```

If your app has a "Haptics" switch in Settings, bind it straight to `hapticsEnabled`.

---

## Rive Animations 🎞️

Add the `ToastUIRive` product, drop your `.riv` files in the app bundle, and describe
one with `RiveAnimationSource`:

```swift
import ToastUIRive

let savedTick = RiveAnimationSource(
    asset: "toast_success",            // toast_success.riv in your bundle
    stateMachine: "State Machine 1",
    fallbackSymbol: "checkmark.circle.fill"
)
```

### Animated toast icon

```swift
@Environment(\.toast) var toast

toast.presentRive(title: "Run saved", animation: savedTick, type: .success)
```

### Animated loading, driven by real progress

Give the source a `progressInput` — a number input (0–100) in your state machine — and
the animation follows the upload:

```swift
let uploading = RiveAnimationSource(
    asset: "loading_ring",
    progressInput: "progress",
    fallbackSymbol: "arrow.up.circle"
)

toast.showRiveProgressOverlay(animation: uploading,
                              title: "Uploading run",
                              progress: 0,
                              onCancel: { upload.cancel() })

for await fraction in upload.progress {
    toast.updateProgressOverlay(progress: fraction, title: "Uploading \(Int(fraction * 100))%")
}

toast.dismissProgressOverlay()
```

Leave `progress` nil for a looping animation with no percentage.

### Celebration

```swift
toast.showRiveCelebration(
    animation: RiveAnimationSource(asset: "celebrate_streak", fallbackSymbol: "flame.fill"),
    title: "7-day streak",
    message: "Keep it going tomorrow.",
    actionTitle: "Nice!"
)
```

### What it does for you

- **Files load once** and are cached; view models are cheap after that.
- **A missing or renamed `.riv` never crashes** — `RiveViewModel(fileName:)` force-tries
  internally, so loading goes through the throwing API and falls back to the SF Symbol,
  with one log line.
- **Reduce Motion** skips Rive entirely and shows the symbol.
- **Animations stop on disappear**, so Rive's display link doesn't keep running.

> One gotcha from the Rive runtime: `RiveRuntime` exports its own `Color` type. In a file
> that imports both it and SwiftUI, write `SwiftUI.Color` (this package exposes
> `RiveToastColor` for that).


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
2. [Progress Overlay](#progress-overlay)
3. [Dialog System](#dialog-system)
4. [Advanced Features](#advanced-features)

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
## Progress Overlay

The Progress Overlay system provides a powerful way to show loading states with full customization over appearance, position, and behavior. Unlike toasts, progress overlays are designed for longer-running operations and provide more control over blocking user interaction.

### Basic Usage

```swift
@Environment(\.toast) var toast

// Simple progress overlay
Button("Show Progress") {
    toast.showProgressOverlay()
    
    // Dismiss after task completes
    Task {
        await performTask()
        toast.dismissProgressOverlay()
    }
}

// With title and message
toast.showProgressOverlay(
    title: "Loading",
    message: "Please wait..."
)

// Dismiss
toast.dismissProgressOverlay()
```

### Positions

```swift
// Top position
toast.showProgressOverlay(
    title: "Loading",
    position: .top
)

// Center position (default)
toast.showProgressOverlay(
    title: "Processing",
    position: .center
)

// Bottom position
toast.showProgressOverlay(
    title: "Uploading",
    position: .bottom
)

// Custom position
toast.showProgressOverlay(
    title: "Loading",
    position: .custom(x: 200, y: 300)
)
```

### Built-in Configurations

```swift
// Default - dark background
toast.showProgressOverlay(
    title: "Loading",
    configuration: .default
)

// Glass effect (iOS 26+)
toast.showProgressOverlay(
    title: "Processing",
    configuration: .glass
)

// Light theme
toast.showProgressOverlay(
    title: "Uploading",
    configuration: .light
)

// Minimal size
toast.showProgressOverlay(configuration: .minimal)

// Large size
toast.showProgressOverlay(
    title: "Downloading",
    message: "This may take a while",
    configuration: .large
)

// Clear background (only shows content)
toast.showProgressOverlay(
    title: "Loading",
    configuration: .clear
)

// Non-blocking (allows user interaction)
toast.showProgressOverlay(
    title: "Background Task",
    configuration: .nonBlocking
)
```

### Custom Configuration

```swift
let config = ProgressOverlayConfiguration(
    backgroundColor: .blue,
    backgroundOpacity: 0.9,
    useGlassEffect: false,
    clearBackground: false,
    cornerRadius: 20,
    width: 250,
    height: 200,
    minWidth: 120,
    minHeight: 120,
    horizontalPadding: 24,
    verticalPadding: 24,
    shadowColor: .black.opacity(0.2),
    shadowRadius: 8,
    shadowX: 0,
    shadowY: 4,
    isBlocking: true,
    backdropOpacity: 0.3
)

toast.showProgressOverlay(
    title: "Custom Progress",
    configuration: config
)
```

### Custom Views

You can pass your own custom SwiftUI views to create completely custom progress overlays:

```swift
// Custom spinner with custom styling
toast.showProgressOverlay {
    VStack(spacing: 16) {
        ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(2)
            .tint(.green)
        Text("Custom Loading")
            .font(.headline)
            .foregroundStyle(.green)
    }
}

// Custom view with image and text
toast.showProgressOverlay {
    VStack(spacing: 16) {
        Image(systemName: "hourglass")
            .font(.system(size: 50))
            .foregroundStyle(.orange)
            .symbolEffect(.pulse, isActive: true)
        Text("Processing")
            .font(.title3)
            .fontWeight(.semibold)
        Text("This may take a moment")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}

// With configuration
toast.showProgressOverlay(
    configuration: .glass
) {
    // Your custom view here
    MyCustomProgressView()
}
```

### Dismissible Overlays

```swift
// With close button
toast.showProgressOverlay(
    title: "Loading",
    message: "Tap X to cancel",
    dismissible: true
)

// Non-blocking and dismissible
toast.showProgressOverlay(
    title: "Background Task",
    message: "You can still interact with the app",
    configuration: .nonBlocking,
    dismissible: true
)
```

### Practical Examples

#### Network Request
```swift
func loadData() async {
    toast.showProgressOverlay(
        title: "Loading Data",
        message: "Fetching from server..."
    )
    
    do {
        let data = try await api.fetchData()
        toast.dismissProgressOverlay()
        toast.success("Data loaded successfully!")
    } catch {
        toast.dismissProgressOverlay()
        toast.error("Failed to load data")
    }
}
```

#### Long Running Task
```swift
func processLargeFile() async {
    let config = ProgressOverlayConfiguration(
        backgroundColor: .purple,
        backgroundOpacity: 0.9,
        cornerRadius: 24,
        isBlocking: true
    )
    
    toast.showProgressOverlay(
        title: "Processing File",
        message: "This may take a few minutes",
        configuration: config,
        dismissible: false
    )
    
    await performLongTask()
    
    toast.dismissProgressOverlay()
    toast.success("Processing complete!")
}
```

#### Custom Progress Indicator
```swift
@State private var progress: Double = 0.0

func uploadFile() {
    toast.showProgressOverlay {
        VStack(spacing: 20) {
            ProgressView(value: progress, total: 1.0)
                .progressViewStyle(.linear)
                .tint(.blue)
                .frame(width: 200)
            
            Text("Uploading: \(Int(progress * 100))%")
                .font(.headline)
            
            Text("Please don't close the app")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    // Update progress and dismiss when done
    Task {
        for i in 0...100 {
            progress = Double(i) / 100.0
            try? await Task.sleep(nanoseconds: 50_000_000)
        }
        toast.dismissProgressOverlay()
        toast.success("Upload complete!")
    }
}
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

---

## Platform Support

### iOS 26+ Glass Effect

On iOS 26+, the `.glass` style uses `.ultraThinMaterial` for a true glass effect.

### iOS 16-25 Fallback

On iOS 16-25, the `.glass` style automatically falls back to `.regularMaterial`.

### macOS Support

Full support on macOS 13.1+.

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


---

## Examples

Check out the included example file:
- `ToastUIExamplesView.swift` - Toast and Dialog examples

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
