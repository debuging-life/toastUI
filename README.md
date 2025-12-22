# ToastUI 🎉

A powerful, highly customizable toast notification system for SwiftUI with automatic root view attachment, stacking support, and environment-based API.

![Platform](https://img.shields.io/badge/platform-iOS%2016%2B%20%7C%20macOS%2013%2B-blue)
![Swift](https://img.shields.io/badge/Swift-6.2+-orange)
![License](https://img.shields.io/badge/license-MIT-green)

https://github.com/user-attachments/assets/093dc837-9f03-4cb5-8369-543c931411ee

## Features ✨

- 🎯 **Simple API** - Just `@Environment(\.toast) var toast`
- 🎨 **5 Toast Types** - Success, Error, Warning, Info, Progress
- 📍 **3 Alignments** - Top, Center, Bottom
- 🎭 **Custom Icons** - Use any SwiftUI View as icon
- 🌈 **Custom Colors** - Override default colors with your brand colors
- 🎨 **Custom Styling** - Configure corner radius, shadows, padding
- 💬 **Optional Message** - Title-only or title + message
- 📚 **Multiple Toasts** - Stack toasts with visual depth effect
- 🔄 **FILO Behavior** - First In, Last Out (newest dismisses first)
- ❌ **Optional Close Button** - Show/hide close button per toast
- ⏱️ **Smart Auto-dismiss** - Proper timer management with stacking
- 🎯 **Progress Toast** - Single, non-stacking progress indicator
- 📱 **SwiftUI Native** - Built with SwiftUI, no UIKit dependencies
- 🚀 **Easy Integration** - One-time setup, use anywhere
- 🧩 **ViewModel Support** - Works seamlessly with ViewModels
- 🎬 **Smooth Animations** - Spring-based transitions

## Requirements

- iOS 16.0+
- Swift 6.2+
- Xcode 16.2+

## Installation

### Swift Package Manager

1. In Xcode, select **File** → **Add Package Dependencies**
2. Enter the package URL: `https://github.com/debuging-life/ToastUI.git`
3. Select **Up to Next Major Version** with `3.1.1`
4. Click **Add Package**

Or add it to your `Package.swift`:
```swift
dependencies: [
    .package(url: "https://github.com/debuging-life/ToastUI.git", from: "3.1.1")
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
                .setupToastUI() // ✅ One-time setup
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

## Core Features

### Toast Types
```swift
struct ToastTypesExample: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        VStack(spacing: 20) {
            // Success Toast (Green)
            Button("Success") {
                toast.success(
                    title: "Success!",
                    message: "Your changes have been saved"
                )
            }
            
            // Error Toast (Red)
            Button("Error") {
                toast.error(
                    title: "Error",
                    message: "Failed to connect to server"
                )
            }
            
            // Warning Toast (Orange)
            Button("Warning") {
                toast.warning(
                    title: "Warning",
                    message: "Your session will expire soon"
                )
            }
            
            // Info Toast (Blue)
            Button("Info") {
                toast.info(
                    title: "Did you know?",
                    message: "You can customize everything!"
                )
            }
            
            // Progress Toast (Purple - No auto-dismiss)
            Button("Progress") {
                toast.progress(title: "Loading...")
                
                // Must dismiss manually
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    toast.dismiss()
                }
            }
        }
        .padding()
    }
}
```

### Multiple Toasts & Stacking

Toasts stack on top of each other with a beautiful card-stacking effect. Users can see up to 3 toasts at once, with a visual depth effect.
```swift
struct StackingExample: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Add Single Toast") {
                toast.success(title: "Toast #1", duration: 5.0)
            }
            
            Button("Stack 5 Toasts") {
                for i in 1...5 {
                    toast.success(
                        title: "Toast #\(i)",
                        message: "Stacking beautifully",
                        duration: 8.0
                    )
                }
            }
            
            Text("Toasts stack with scale & offset effect")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
```

**Visual Effect:**
```
┌─────────────────────────┐  ← Newest (100% size)
│ Toast 3                 │
└─────────────────────────┘
  ┌───────────────────────┐  ← 2nd (95% size, +8pt offset)
  │ Toast 2               │
  └───────────────────────┘
    ┌─────────────────────┐  ← 3rd (90% size, +16pt offset)
    │ Toast 1             │
    └─────────────────────┘
```

### FILO Behavior (First In, Last Out)

Toasts dismiss in reverse order - the newest toast dismisses first, then the next newest, etc.
```swift
Button("Test FILO") {
    toast.success(title: "First (5s)", duration: 5.0)
    toast.info(title: "Second (3s)", duration: 3.0)
    toast.warning(title: "Third (4s)", duration: 4.0)
}
// Dismisses: Third (4s) → Second (3s) → First (5s)
```

### Toast Alignment
```swift
struct AlignmentExample: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Top (Default)") {
                toast.success(
                    title: "Top Toast",
                    alignment: .top
                )
            }
            
            Button("Center") {
                toast.warning(
                    title: "Center Toast",
                    alignment: .center
                )
            }
            
            Button("Bottom") {
                toast.info(
                    title: "Bottom Toast",
                    alignment: .bottom
                )
            }
        }
    }
}
```

### Optional Message
```swift
// Title only
toast.success(title: "Saved!")

// Title + Message
toast.success(
    title: "Saved!",
    message: "Your changes have been saved successfully"
)
```

### Custom Duration
```swift
// Short toast (1 second)
toast.success(title: "Quick!", duration: 1.0)

// Long toast (10 seconds)
toast.error(title: "Important", message: "Read carefully", duration: 10.0)
```

### Optional Close Button
```swift
// With close button (default)
toast.success(
    title: "Dismissible",
    message: "Click X to close"
)

// Without close button
toast.info(
    title: "Auto-dismiss only",
    duration: 3.0,
    showCloseButton: false
)

// Progress toasts NEVER have close button
toast.progress(title: "Loading...") // No close button
```

### Manual Dismiss
```swift
// Dismiss the topmost toast
toast.dismiss()

// Dismiss all toasts
toast.dismissAll()
```

## Advanced Features

### Custom Styling

Use `ToastConfiguration` to customize appearance:
```swift
struct CustomStylingExample: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        VStack(spacing: 20) {
            // Pre-defined styles
            Button("Default Style") {
                toast.success(
                    title: "Default",
                    configuration: .default
                )
            }
            
            Button("Compact Style") {
                toast.success(
                    title: "Compact",
                    configuration: .compact
                )
            }
            
            Button("Rounded Style") {
                toast.success(
                    title: "Very Rounded",
                    configuration: .rounded
                )
            }
            
            Button("Minimal Style") {
                toast.info(
                    title: "Minimal",
                    configuration: .minimal
                )
            }
            
            // Custom configuration
            Button("Fully Custom") {
                let customConfig = ToastConfiguration(
                    cornerRadius: 25,
                    shadowRadius: 20,
                    shadowColor: .purple.opacity(0.3),
                    shadowX: 0,
                    shadowY: 10,
                    horizontalPadding: 20,
                    verticalPadding: 20
                )
                
                toast.success(
                    title: "Custom Style",
                    message: "Unique appearance",
                    configuration: customConfig
                )
            }
        }
    }
}
```

**Available Configuration Options:**
```swift
ToastConfiguration(
    cornerRadius: CGFloat = 12,
    shadowRadius: CGFloat = 10,
    shadowColor: Color = .black.opacity(0.2),
    shadowX: CGFloat = 0,
    shadowY: CGFloat = 5,
    horizontalPadding: CGFloat = 16,
    verticalPadding: CGFloat = 16
)
```

### Custom Colors
```swift
struct CustomColorsExample: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        VStack(spacing: 20) {
            // Custom solid color
            Button("Pink Toast") {
                toast.success(
                    title: "Custom Pink",
                    backgroundColor: .pink
                )
            }
            
            // Brand color
            Button("Brand Color") {
                toast.info(
                    title: "Branded",
                    backgroundColor: Color(hex: "#6366f1")
                )
            }
            
            // Semi-transparent
            Button("Transparent") {
                toast.warning(
                    title: "Semi-transparent",
                    backgroundColor: .purple.opacity(0.7)
                )
            }
        }
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
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}
```

### Custom Icons
```swift
struct CustomIconsExample: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        VStack(spacing: 20) {
            // Custom SF Symbol
            Button("Custom Icon") {
                toast.present(
                    title: "New Message",
                    message: "You have mail",
                    type: .info
                ) {
                    Image(systemName: "envelope.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
            
            // Heart icon
            Button("Heart") {
                toast.present(
                    title: "Liked!",
                    type: .success
                ) {
                    Image(systemName: "heart.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
            
            // Custom view
            Button("Badge") {
                toast.present(
                    title: "Achievement!",
                    message: "Level up!",
                    type: .success
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
        }
    }
}
```

### Progress Toast Behavior

Progress toasts are special:
- ✅ **Single per alignment** - New progress replaces old one
- ✅ **No close button** - Must be dismissed programmatically
- ✅ **No auto-dismiss** - Stays until you call `dismiss()`
- ✅ **No stacking** - Always singular
```swift
struct ProgressExample: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Show Progress") {
                toast.progress(title: "Processing...")
                
                Task {
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                    toast.dismiss()
                    toast.success(title: "Complete!")
                }
            }
            
            Button("Replace Progress") {
                toast.progress(title: "First operation...")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    // This replaces the first progress
                    toast.progress(title: "Second operation...")
                }
            }
            
            Button("Multiple Alignments") {
                // These DON'T replace each other (different alignments)
                toast.progress(title: "Top", alignment: .top)
                toast.progress(title: "Bottom", alignment: .bottom)
            }
        }
    }
}
```

### Combining All Features
```swift
Button("Ultimate Toast") {
    let customConfig = ToastConfiguration(
        cornerRadius: 25,
        shadowRadius: 20,
        shadowColor: .purple.opacity(0.3),
        shadowY: 10,
        horizontalPadding: 24,
        verticalPadding: 20
    )
    
    toast.present(
        title: "Fully Featured",
        message: "All options enabled!",
        type: .success,
        duration: 5.0,
        alignment: .center,
        backgroundColor: Color(hex: "#FF6B6B"),
        configuration: customConfig,
        showCloseButton: true
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
```

## ViewModel Integration

### Method 1: Pass as Parameter (Recommended)
```swift
import SwiftUI
import ToastPackage

class DataViewModel: ObservableObject {
    @Published var data: [String] = []
    
    func loadData(toast: ToastManager) async {
        toast.progress(title: "Loading...", alignment: .bottom)
        
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
            toast.success(title: "Welcome!")
        } catch {
            toast.error(title: "Login Failed", message: error.localizedDescription)
        }
    }
}

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
            SecureField("Password", text: $password)
            
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
            SecureField("Confirm", text: $confirmPassword)
            
            Button("Sign Up") {
                validateAndSignUp()
            }
        }
    }
    
    func validateAndSignUp() {
        guard !email.isEmpty else {
            toast.warning(title: "Email Required")
            return
        }
        
        guard password.count >= 8 else {
            toast.warning(
                title: "Weak Password",
                message: "Use at least 8 characters"
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
        
        toast.success(title: "Account Created!")
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
            title: "Uploading...",
            alignment: .bottom,
            configuration: .rounded
        )
        
        do {
            try await Task.sleep(nanoseconds: 3_000_000_000)
            toast.success(
                title: "Upload Complete",
                alignment: .bottom,
                configuration: .rounded
            )
        } catch {
            toast.error(
                title: "Upload Failed",
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
        toast.progress(title: "Fetching...")
        
        do {
            try await performRequest()
            toast.success(title: "Data Loaded")
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
    
    func performRequest() async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}
```

### Sequential Operations
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
            message: "Processed \(items.count) items"
        )
    }
}
```

## API Reference

### ToastManager Methods
```swift
// Generic present
func present(
    title: String,
    message: String? = nil,
    type: ToastType,
    duration: TimeInterval = 3.0,
    alignment: ToastAlignment = .top,
    backgroundColor: Color? = nil,
    configuration: ToastConfiguration = .default,
    showCloseButton: Bool = true
)

// Present with custom icon
func present<Icon: View>(
    title: String,
    message: String? = nil,
    type: ToastType,
    duration: TimeInterval = 3.0,
    alignment: ToastAlignment = .top,
    backgroundColor: Color? = nil,
    configuration: ToastConfiguration = .default,
    showCloseButton: Bool = true,
    @ViewBuilder icon: () -> Icon
)

// Convenience methods
func success(title: String, message: String? = nil, duration: TimeInterval = 3.0, alignment: ToastAlignment = .top, backgroundColor: Color? = nil, configuration: ToastConfiguration = .default, showCloseButton: Bool = true)

func error(title: String, message: String? = nil, duration: TimeInterval = 3.0, alignment: ToastAlignment = .top, backgroundColor: Color? = nil, configuration: ToastConfiguration = .default, showCloseButton: Bool = true)

func warning(title: String, message: String? = nil, duration: TimeInterval = 3.0, alignment: ToastAlignment = .top, backgroundColor: Color? = nil, configuration: ToastConfiguration = .default, showCloseButton: Bool = true)

func info(title: String, message: String? = nil, duration: TimeInterval = 3.0, alignment: ToastAlignment = .top, backgroundColor: Color? = nil, configuration: ToastConfiguration = .default, showCloseButton: Bool = true)

func progress(title: String, alignment: ToastAlignment = .top, backgroundColor: Color? = nil, configuration: ToastConfiguration = .default)

// Dismiss methods
func dismiss() // Dismisses topmost toast
func dismissAll() // Dismisses all toasts
```

### ToastType
```swift
public enum ToastType {
    case success    // Green with checkmark
    case error      // Red with X mark
    case warning    // Orange with exclamation
    case info       // Blue with info icon
    case progress   // Purple with spinner (no close button, single per alignment)
}
```

### ToastAlignment
```swift
public enum ToastAlignment {
    case top        // Appears at top
    case center     // Appears in center
    case bottom     // Appears at bottom
}
```

### ToastConfiguration
```swift
public struct ToastConfiguration {
    public let cornerRadius: CGFloat
    public let shadowRadius: CGFloat
    public let shadowColor: Color
    public let shadowX: CGFloat
    public let shadowY: CGFloat
    public let horizontalPadding: CGFloat
    public let verticalPadding: CGFloat
    
    // Pre-defined styles
    public static let `default`: ToastConfiguration
    public static let compact: ToastConfiguration
    public static let rounded: ToastConfiguration
    public static let minimal: ToastConfiguration
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

## Toast Behavior

### Stacking Rules
- Up to 3 toasts visible at once
- Visual depth effect (scale + offset)
- Newest toast on top (100% size)
- Older toasts scaled down (95%, 90%)
- 4+ toasts hidden but queued

### Dismiss Behavior
- **FILO** (First In, Last Out) - Newest dismisses first
- **Auto-dismiss** - All toasts except progress
- **Manual dismiss** - Click X button (if enabled)
- **Timer management** - Paused when stacked, resumes when topmost

### Progress Toast Special Rules
- Only one progress per alignment
- No close button
- No auto-dismiss
- Must be dismissed manually
- Replaces existing progress

## Best Practices

### ✅ Do

- Use appropriate toast types for different scenarios
- Keep messages concise and actionable
- Use progress toasts for operations over 1 second
- Manually dismiss progress toasts when complete
- Use title-only for quick feedback
- Choose appropriate alignment based on context
- Use custom colors for brand consistency
- Show close button for long-duration toasts

### ❌ Don't

- Don't use toasts for critical errors requiring user action
- Don't set extremely long durations (> 10 seconds)
- Don't use toasts as primary navigation
- Don't forget to dismiss progress toasts
- Don't overuse custom colors (be consistent)
- Don't stack too many toasts (users get overwhelmed)

## Troubleshooting

### Toast not showing?

Make sure `.setupToast()` is in your root view:
```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .setupToast() // ← Required!
        }
    }
}
```

### Close button not working?

The close button should work on all toasts. If not:
1. Make sure `showCloseButton: true` (default)
2. Progress toasts never have close buttons
3. Try clicking directly on the X icon

### Toast stuck and won't dismiss?

- Progress toasts must be dismissed manually: `toast.dismiss()`
- Check if you have a long duration set
- Try `toast.dismissAll()` to clear everything

### Animations look weird?

This usually means multiple `.setupToast()` calls. Only call it once at the root:
```swift
// ✅ Correct
ContentView()
    .setupToast()

// ❌ Wrong - don't call multiple times
ContentView()
    .setupToast()
    .someView()
    .setupToast() // Remove this!
```

### Using with multiple windows?

Each window needs its own `.setupToast()`:
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

### From Basic Toast to Advanced

**Old way:**
```swift
toast.success(title: "Success")
```

**New features available:**
```swift
// Optional message
toast.success(title: "Success") // Still works!
toast.success(title: "Success", message: "With details")

// Custom alignment
toast.success(title: "Success", alignment: .bottom)

// Custom styling
toast.success(title: "Success", configuration: .rounded)

// Custom color
toast.success(title: "Success", backgroundColor: .pink)

// Hide close button
toast.success(title: "Success", showCloseButton: false)

// Custom icon
toast.present(title: "Success", type: .success) {
    Image(systemName: "heart.fill")
}

// Everything combined
toast.present(
    title: "Success",
    message: "All features!",
    type: .success,
    duration: 5.0,
    alignment: .center,
    backgroundColor: .pink,
    configuration: .rounded,
    showCloseButton: true
) {
    Image(systemName: "star.fill")
}
```

## Roadmap

- [ ] SwiftUI animations customization
- [ ] Sound effects support
- [ ] Haptic feedback
- [ ] Swipe to dismiss gesture
- [ ] Custom positions (offset from edges)
- [ ] Accessibility improvements
- [ ] macOS menu bar integration
- [ ] Async/await dismiss callbacks

## Performance

- ✅ Lightweight - Minimal memory footprint
- ✅ Efficient - Reuses views, cancels timers properly
- ✅ Smooth - 60fps animations
- ✅ Thread-safe - All operations on MainActor

## License

MIT License - feel free to use in your projects!

## Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Author

Pardip Bhatti - iOS Developer & Mobile Architect

## Acknowledgments

Built with ❤️ using SwiftUI

Special thanks to the SwiftUI community for inspiration and feedback.

---

**If you find this package useful, please ⭐ star the repo!**

**Questions or issues?** Open an issue on GitHub or reach out on Twitter.

**Want to support development?** Consider sponsoring the project on GitHub Sponsors.
