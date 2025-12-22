# ToastUI 🎉

A lightweight, highly customizable toast notification system for SwiftUI with automatic root view attachment and environment-based API.

![Platform](https://img.shields.io/badge/platform-iOS%2016%2B%20%7C%20macOS%2013%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![License](https://img.shields.io/badge/license-MIT-green)

## Features ✨

- 🎯 **Simple API** - Just `@Environment(\.toast) var toast`
- 🎨 **5 Toast Types** - Success, Error, Warning, Info, Progress
- 📍 **3 Alignments** - Top, Center, Bottom
- 🎭 **Custom Icons** - Use any SwiftUI View as icon
- 🌈 **Custom Colors** - Override default colors with your brand colors
- 💬 **Optional Message** - Title-only or title + message
- ⏱️ **Auto-dismiss** - Configurable duration with smooth animations
- 🔄 **Progress Toast** - Simplified UI for long-running operations
- 📱 **SwiftUI Native** - Built with SwiftUI, no UIKit dependencies
- 🚀 **Easy Integration** - One-time setup, use anywhere
- 🧩 **ViewModel Support** - Works seamlessly with ViewModels
- 🎬 **Smooth Animations** - Spring-based transitions

## Requirements

- iOS 16.0+ / macOS 13.0+
- Swift 5.9+
- Xcode 15.0+

## Installation

### Swift Package Manager

1. In Xcode, select **File** → **Add Package Dependencies**
2. Enter the package URL: `https://github.com/yourusername/ToastPackage.git`
3. Select **Up to Next Major Version** with `1.0.0`
4. Click **Add Package**

Or add it to your `Package.swift`:
```swift
dependencies: [
    .package(url: "https://github.com/yourusername/ToastPackage.git", from: "1.0.0")
]
```

## Quick Start

### 1. Setup (One-time)

Add `.setupToast()` to your root view in your App file:
```swift
import SwiftUI
import ToastPackage

@main
struct YourApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .setupToast() // ✅ One-time setup
        }
    }
}
```

### 2. Use in Views
```swift
import SwiftUI
import ToastPackage

struct ContentView: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        Button("Show Success") {
            toast.success(title: "Success!", message: "Operation completed")
        }
    }
}
```

That's it! No additional setup needed. 🎊

## Usage Examples

### Basic Toast Types
```swift
struct BasicToastExamples: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        VStack(spacing: 20) {
            // Success Toast
            Button("Success") {
                toast.success(
                    title: "Success!",
                    message: "Your changes have been saved"
                )
            }
            
            // Error Toast
            Button("Error") {
                toast.error(
                    title: "Error",
                    message: "Failed to connect to server"
                )
            }
            
            // Warning Toast
            Button("Warning") {
                toast.warning(
                    title: "Warning",
                    message: "Your session will expire soon"
                )
            }
            
            // Info Toast
            Button("Info") {
                toast.info(
                    title: "Did you know?",
                    message: "You can customize everything!"
                )
            }
            
            // Progress Toast (auto-simplified UI)
            Button("Progress") {
                toast.progress(title: "Loading...")
                
                // Dismiss after work
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    toast.dismiss()
                }
            }
        }
        .padding()
    }
}
```

### Title-Only Toasts (No Message)
```swift
struct TitleOnlyExamples: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Quick Success") {
                toast.success(title: "Saved!")
            }
            
            Button("Quick Error") {
                toast.error(title: "Failed")
            }
            
            Button("Quick Info") {
                toast.info(title: "Settings updated")
            }
        }
        .padding()
    }
}
```

### Toast Alignment
```swift
struct AlignmentExamples: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        VStack(spacing: 20) {
            // Top (default)
            Button("Top Toast") {
                toast.success(
                    title: "Top Position",
                    message: "This appears at the top",
                    alignment: .top
                )
            }
            
            // Center
            Button("Center Toast") {
                toast.warning(
                    title: "Center Position",
                    message: "This appears in the center",
                    alignment: .center
                )
            }
            
            // Bottom
            Button("Bottom Toast") {
                toast.info(
                    title: "Bottom Position",
                    message: "This appears at the bottom",
                    alignment: .bottom
                )
            }
        }
        .padding()
    }
}
```

### Custom Background Colors
```swift
struct CustomColorExamples: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        VStack(spacing: 20) {
            // Custom solid color
            Button("Pink Background") {
                toast.success(
                    title: "Custom Color",
                    message: "This has a pink background",
                    backgroundColor: .pink
                )
            }
            
            // Brand color
            Button("Brand Color") {
                toast.info(
                    title: "Branded Toast",
                    message: "Using your brand color",
                    backgroundColor: Color(hex: "#6366f1")
                )
            }
            
            // Semi-transparent
            Button("Transparent") {
                toast.warning(
                    title: "Semi-transparent",
                    message: "With opacity",
                    backgroundColor: .purple.opacity(0.7)
                )
            }
            
            // Custom progress color
            Button("Custom Progress") {
                toast.progress(
                    title: "Loading...",
                    backgroundColor: .indigo
                )
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    toast.dismiss()
                }
            }
        }
        .padding()
    }
}

// Helper extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
```

### Custom Icons
```swift
struct CustomIconExamples: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        VStack(spacing: 20) {
            // Custom SF Symbol
            Button("Custom Icon") {
                toast.present(
                    title: "New Message",
                    message: "You have 3 unread messages",
                    type: .info
                ) {
                    Image(systemName: "envelope.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
            
            // Heart icon
            Button("Heart Icon") {
                toast.present(
                    title: "Liked!",
                    type: .success
                ) {
                    Image(systemName: "heart.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
            
            // Custom view icon
            Button("Badge Icon") {
                toast.present(
                    title: "Achievement Unlocked!",
                    message: "You've completed 10 tasks",
                    type: .success,
                    alignment: .center
                ) {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 30, height: 30)
                        
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                    }
                }
            }
            
            // Custom icon with custom color
            Button("Full Custom") {
                toast.present(
                    title: "Fully Customized",
                    message: "Custom icon and color!",
                    type: .info,
                    backgroundColor: .teal
                ) {
                    Image(systemName: "sparkles")
                        .font(.title2)
                        .foregroundStyle(.yellow)
                }
            }
        }
        .padding()
    }
}
```

### Custom Duration
```swift
Button("Long Toast") {
    toast.success(
        title: "Extended Duration",
        message: "This will stay for 5 seconds",
        duration: 5.0
    )
}

Button("Quick Toast") {
    toast.info(
        title: "Quick Message",
        duration: 1.0
    )
}
```

### Manual Dismiss
```swift
Button("Show & Dismiss") {
    toast.progress(title: "Processing...")
    
    // Manually dismiss after 2 seconds
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        toast.dismiss()
        toast.success(title: "Complete!")
    }
}
```

### Async Operations
```swift
struct AsyncExampleView: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        Button("Fetch Data") {
            Task {
                await fetchData()
            }
        }
    }
    
    func fetchData() async {
        toast.progress(title: "Loading data...")
        
        do {
            try await Task.sleep(nanoseconds: 2_000_000_000)
            toast.success(
                title: "Success",
                message: "Data loaded successfully!"
            )
        } catch {
            toast.error(
                title: "Error",
                message: error.localizedDescription
            )
        }
    }
}
```

## ViewModel Integration

### Method 1: Pass as Parameter (Recommended)
```swift
import SwiftUI
import ToastPackage

class DataViewModel: ObservableObject {
    @Published var data: [String] = []
    
    func loadData(toast: ToastManager) async {
        toast.progress(title: "Fetching data...", alignment: .bottom)
        
        do {
            try await Task.sleep(nanoseconds: 2_000_000_000)
            data = ["Item 1", "Item 2", "Item 3"]
            toast.success(
                title: "Success",
                message: "Loaded \(data.count) items",
                alignment: .bottom
            )
        } catch {
            toast.error(
                title: "Error",
                message: "Failed to load data",
                alignment: .bottom
            )
        }
    }
}

struct DataView: View {
    @Environment(\.toast) var toast
    @StateObject private var viewModel = DataViewModel()
    
    var body: some View {
        VStack {
            Button("Load Data") {
                Task {
                    await viewModel.loadData(toast: toast)
                }
            }
            
            List(viewModel.data, id: \.self) { item in
                Text(item)
            }
        }
    }
}
```

### Method 2: Inject in Initializer
```swift
class UserViewModel: ObservableObject {
    private let toast: ToastManager
    @Published var user: User?
    
    init(toast: ToastManager) {
        self.toast = toast
    }
    
    func login(email: String, password: String) async {
        toast.progress(title: "Authenticating...")
        
        do {
            try await Task.sleep(nanoseconds: 1_500_000_000)
            user = User(email: email)
            toast.success(title: "Welcome!", message: "Login successful")
        } catch {
            toast.error(title: "Login Failed", message: error.localizedDescription)
        }
    }
}

// Wrapper view to inject toast
struct LoginViewWrapper: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        LoginViewContent(viewModel: UserViewModel(toast: toast))
    }
}

struct LoginViewContent: View {
    @StateObject var viewModel: UserViewModel
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            Button("Login") {
                Task {
                    await viewModel.login(email: email, password: password)
                }
            }
        }
        .padding()
    }
}
```

## Real-World Examples

### Form Validation
```swift
struct SignupView: View {
    @Environment(\.toast) var toast
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        Form {
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            SecureField("Confirm Password", text: $confirmPassword)
            
            Button("Sign Up") {
                validateAndSignUp()
            }
        }
    }
    
    func validateAndSignUp() {
        guard !email.isEmpty else {
            toast.warning(
                title: "Email Required",
                message: "Please enter your email"
            )
            return
        }
        
        guard password.count >= 8 else {
            toast.warning(
                title: "Weak Password",
                message: "Password must be at least 8 characters"
            )
            return
        }
        
        guard password == confirmPassword else {
            toast.error(
                title: "Passwords Don't Match",
                message: "Please check your passwords"
            )
            return
        }
        
        toast.success(
            title: "Account Created",
            message: "Welcome aboard!"
        )
    }
}
```

### File Upload with Progress
```swift
struct FileUploadView: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        Button("Upload File") {
            Task {
                await uploadFile()
            }
        }
    }
    
    func uploadFile() async {
        toast.progress(
            title: "Uploading file...",
            alignment: .bottom
        )
        
        do {
            try await Task.sleep(nanoseconds: 3_000_000_000)
            toast.success(
                title: "Upload Complete",
                message: "File uploaded successfully",
                alignment: .bottom
            )
        } catch {
            toast.error(
                title: "Upload Failed",
                message: "Please try again",
                alignment: .bottom
            )
        }
    }
}
```

### Network Request with Retry
```swift
struct NetworkView: View {
    @Environment(\.toast) var toast
    @State private var retryCount = 0
    
    var body: some View {
        Button("Fetch Data") {
            Task {
                await fetchWithRetry()
            }
        }
    }
    
    func fetchWithRetry() async {
        toast.progress(title: "Fetching data...")
        
        do {
            try await performNetworkRequest()
            toast.success(title: "Data loaded")
            retryCount = 0
        } catch {
            if retryCount < 3 {
                retryCount += 1
                toast.warning(
                    title: "Retrying...",
                    message: "Attempt \(retryCount) of 3"
                )
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                await fetchWithRetry()
            } else {
                toast.error(
                    title: "Failed",
                    message: "Max retries reached"
                )
                retryCount = 0
            }
        }
    }
    
    func performNetworkRequest() async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}
```

### Sequential Operations with Updates
```swift
struct BatchOperationView: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        Button("Process Batch") {
            Task {
                await processBatch()
            }
        }
    }
    
    func processBatch() async {
        let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
        
        for (index, _) in items.enumerated() {
            toast.progress(
                title: "Processing \(index + 1)/\(items.count)..."
            )
            try? await Task.sleep(nanoseconds: 800_000_000)
        }
        
        toast.success(
            title: "Complete!",
            message: "Processed all \(items.count) items"
        )
    }
}
```

### Combining All Features
```swift
struct FullFeatureExample: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        Button("Ultimate Toast") {
            toast.present(
                title: "Fully Featured",
                message: "Custom everything!",
                type: .success,
                duration: 4.0,
                alignment: .center,
                backgroundColor: Color(hex: "#FF6B6B")
            ) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.3))
                        .frame(width: 35, height: 35)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                }
            }
        }
    }
}
```

## API Reference

### ToastManager

#### Main Methods
```swift
// Generic present method
func present(
    title: String,
    message: String? = nil,
    type: ToastType,
    duration: TimeInterval = 3.0,
    alignment: ToastAlignment = .top,
    backgroundColor: Color? = nil
)

// Present with custom icon
func present<Icon: View>(
    title: String,
    message: String? = nil,
    type: ToastType,
    duration: TimeInterval = 3.0,
    alignment: ToastAlignment = .top,
    backgroundColor: Color? = nil,
    @ViewBuilder icon: () -> Icon
)
```

#### Convenience Methods
```swift
func success(
    title: String,
    message: String? = nil,
    duration: TimeInterval = 3.0,
    alignment: ToastAlignment = .top,
    backgroundColor: Color? = nil
)

func error(
    title: String,
    message: String? = nil,
    duration: TimeInterval = 3.0,
    alignment: ToastAlignment = .top,
    backgroundColor: Color? = nil
)

func warning(
    title: String,
    message: String? = nil,
    duration: TimeInterval = 3.0,
    alignment: ToastAlignment = .top,
    backgroundColor: Color? = nil
)

func info(
    title: String,
    message: String? = nil,
    duration: TimeInterval = 3.0,
    alignment: ToastAlignment = .top,
    backgroundColor: Color? = nil
)

func progress(
    title: String,
    alignment: ToastAlignment = .top,
    backgroundColor: Color? = nil
)

func dismiss()
```

### ToastType
```swift
public enum ToastType {
    case success    // Green with checkmark (default)
    case error      // Red with X mark (default)
    case warning    // Orange with exclamation (default)
    case info       // Blue with info icon (default)
    case progress   // Purple with loading spinner (default)
}
```

### ToastAlignment
```swift
public enum ToastAlignment {
    case top        // Appears at top of screen
    case center     // Appears in center of screen
    case bottom     // Appears at bottom of screen
}
```

### Default Colors

| Type | Default Color |
|------|--------------|
| Success | Green |
| Error | Red |
| Warning | Orange |
| Info | Blue |
| Progress | Purple |

*All colors can be overridden with the `backgroundColor` parameter*

## Best Practices

### ✅ Do

- Use appropriate toast types for different scenarios
- Keep messages concise and actionable
- Use progress toasts for operations over 1 second
- Manually dismiss progress toasts when complete
- Use custom durations for important messages
- Use title-only toasts for quick feedback
- Choose appropriate alignment based on context
- Use custom colors for brand consistency

### ❌ Don't

- Don't show multiple toasts simultaneously (they replace each other)
- Don't use toasts for critical errors requiring user action
- Don't set extremely long durations (> 10 seconds)
- Don't use toasts as primary navigation
- Don't forget to dismiss progress toasts
- Don't overuse custom colors (be consistent)

## Customization Options

| Feature | Options | Default |
|---------|---------|---------|
| **Type** | success, error, warning, info, progress | - |
| **Alignment** | top, center, bottom | top |
| **Duration** | Any TimeInterval | 3.0 seconds |
| **Message** | Optional String | nil |
| **Icon** | Any View | Type's default icon |
| **Background** | Any Color | Type's default color |

## Troubleshooting

### Toast not showing?

Make sure you've added `.setupToast()` to your root view:
```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .setupToast() // ← Don't forget this!
        }
    }
}
```

### Toast showing behind other views?

The toast has a `zIndex` of 999, which should keep it on top. If you have custom overlays with higher `zIndex`, adjust accordingly.

### Custom icon not showing?

Make sure you're using the `present(icon:)` method:
```swift
// ✅ Correct
toast.present(title: "Title", type: .success) {
    Image(systemName: "custom.icon")
}

// ❌ Wrong
toast.success(title: "Title") // This uses default icon
```

### Using with multiple windows?

Each window needs its own `.setupToast()` call:
```swift
WindowGroup {
    ContentView()
        .setupToast()
}

WindowGroup("Settings") {
    SettingsView()
        .setupToast()
}
```

## Migration Guide

### From Version 1.0 to 2.0

**New Features:**
- ✅ Optional message parameter
- ✅ Alignment options
- ✅ Custom icons
- ✅ Custom background colors
- ✅ Simplified progress view

**Breaking Changes:**
- None! All changes are backward compatible.

**What's New:**
```swift
// Old way (still works)
toast.success(title: "Success", message: "It worked")

// New ways (all work)
toast.success(title: "Success") // No message
toast.success(title: "Success", alignment: .bottom) // Custom alignment
toast.success(title: "Success", backgroundColor: .pink) // Custom color
toast.present(title: "Success", type: .success) { // Custom icon
    Image(systemName: "heart.fill")
}
```

## Roadmap

- [ ] SwiftUI animations customization
- [ ] Sound effects support
- [ ] Haptic feedback
- [ ] Queue system for multiple toasts
- [ ] Custom corner radius
- [ ] Swipe to dismiss
- [ ] Accessibility improvements
- [ ] macOS menu bar integration

## License

MIT License - feel free to use in your projects!

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Author

Pardip Bhatti - iOS Developer

## Acknowledgments

Built with ❤️ using SwiftUI

---

**Star ⭐ this repo if you find it useful!**
