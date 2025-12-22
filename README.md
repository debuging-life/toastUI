# ToastUI 🎉

A powerful, all-in-one notification and dialog system for SwiftUI with toasts, dialogs, and clipboard support - built with environment-based API for seamless integration.

![Platform](https://img.shields.io/badge/platform-iOS%2016%2B%20%7C%20macOS%2013%2B-blue)
![Swift](https://img.shields.io/badge/Swift-6.2+-orange)
![License](https://img.shields.io/badge/license-MIT-green)

https://github.com/user-attachments/assets/bef65af7-a544-4396-83aa-c99411154cc4

https://github.com/user-attachments/assets/dbba4945-59e7-473b-ba64-7b959b42ce5a

https://github.com/user-attachments/assets/6ed6bc9d-5206-4749-bca3-9561bcd00f4b


## Features ✨

### Toast Notifications
- 🎯 **Simple API** - Just `@Environment(\.toast) var toast`
- 🎨 **5 Toast Types** - Success, Error, Warning, Info, Progress
- 📍 **3 Alignments** - Top, Center, Bottom
- 🎭 **Custom Icons** - Use any SwiftUI View as icon
- 🌈 **Custom Colors** - Override default colors with your brand colors
- 🎨 **Custom Styling** - Configure corner radius, shadows, padding
- 💬 **Optional Message** - Title-only or title + message
- 📋 **Copy to Clipboard** - One-tap copy for error messages and logs
- 📚 **Multiple Toasts** - Stack toasts with visual depth effect
- 🔄 **FILO Behavior** - First In, Last Out (newest dismisses first)
- ❌ **Optional Close Button** - Show/hide close button per toast
- ⏱️ **Smart Auto-dismiss** - Proper timer management with stacking
- 🎯 **Progress Toast** - Single, non-stacking progress indicator

### Dialog System
- 💬 **Custom Dialogs** - Build any dialog with SwiftUI views
- 🎨 **Pre-built Components** - Alert, Confirmation dialogs ready to use
- ⚙️ **Configurable** - Customize size, appearance, and behavior
- 🎭 **Backdrop Control** - Dismiss on tap or require explicit action
- 🎬 **Smooth Animations** - Bouncy slide-up transitions
- 🔗 **Toast Integration** - Use toasts and dialogs together seamlessly

### General
- 📱 **SwiftUI Native** - Pure SwiftUI, no UIKit dependencies
- 🚀 **Easy Integration** - One-time setup, use anywhere
- 🧩 **ViewModel Support** - Works seamlessly with ViewModels
- 🎬 **Smooth Animations** - Spring-based transitions
- 🎯 **Swift 6 Ready** - Built with modern Swift concurrency

## Requirements

- iOS 16.0+
- Swift 6.2+
- Xcode 16.2+
- macOS 13.0+

## Installation

### Swift Package Manager

1. In Xcode, select **File** → **Add Package Dependencies**
2. Enter the package URL: `https://github.com/debuging-life/ToastUI.git`
3. Select **Up to Next Major Version** with `3.2.0`
4. Click **Add Package**

Or add it to your `Package.swift`:
```swift
dependencies: [
    .package(url: "https://github.com/debuging-life/ToastUI.git", from: "3.2.0")
]
```

## Quick Start

### 1. Setup (One-time)

Add `.setupToastUI()` to your root view in your App file:
```swift
import SwiftUI
import ToastUI

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

### 2. Use Toasts in Views
```swift
import SwiftUI
import ToastUI

struct ContentView: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        Button("Show Success") {
            toast.success(title: "Success!", message: "Operation completed")
        }
    }
}
```

### 3. Use Dialogs in Views
```swift
struct ContentView: View {
    @State private var showDialog = false
    
    var body: some View {
        Button("Show Dialog") {
            showDialog = true
        }
        .dialog(isPresented: $showDialog) {
            VStack(spacing: 20) {
                Text("Hello Dialog!")
                    .font(.title)
                
                Button("Close") {
                    showDialog = false
                }
            }
            .padding()
        }
    }
}
```

That's it! No additional setup needed. 🎊

## Toast Features

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

### Copy to Clipboard Feature 📋

Enable copy button for error messages, API responses, or any content users might need to share or report:
```swift
struct CopyFeatureExample: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        VStack(spacing: 20) {
            // Error with copy button
            Button("API Error (Copyable)") {
                toast.error(
                    title: "API Error",
                    message: "Error Code: 500\nEndpoint: /api/users\nMessage: Internal Server Error",
                    duration: 10.0,
                    enableCopy: true // ← Enable copy button
                )
            }
            
            // Stack trace with copy
            Button("Stack Trace (Copyable)") {
                toast.error(
                    title: "Exception",
                    message: """
                    at MyApp.ViewController.loadData()
                    at MyApp.NetworkManager.request()
                    at Foundation.URLSession.dataTask()
                    """,
                    duration: 15.0,
                    enableCopy: true
                )
            }
            
            // Debug info with copy
            Button("Debug Info") {
                toast.info(
                    title: "Session ID",
                    message: "abc123-def456-ghi789",
                    enableCopy: true
                )
            }
        }
    }
}
```

**How it works:**
- Shows a copy icon next to the close button
- Icon changes to checkmark on successful copy
- Copies both title and message to clipboard
- Visual feedback with smooth animation
- Works on both iOS and macOS

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

### Custom Styling

Use `ToastConfiguration` to customize appearance:
```swift
struct CustomStylingExample: View {
    @Environment(\.toast) var toast
    
    var body: some View {
        VStack(spacing: 20) {
            // Pre-defined styles
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

## Dialog Features 💬

### Basic Dialog Usage
```swift
struct BasicDialogExample: View {
    @State private var showDialog = false
    
    var body: some View {
        Button("Show Custom Dialog") {
            showDialog = true
        }
        .dialog(isPresented: $showDialog) {
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.green)
                
                Text("Success!")
                    .font(.title)
                
                Text("Your action was completed successfully.")
                    .multilineTextAlignment(.center)
                
                Button("Close") {
                    showDialog = false
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}
```

### Pre-built Dialog Components

#### Alert Dialog
```swift
struct AlertDialogExample: View {
    @Environment(\.toast) var toast
    @State private var showAlert = false
    
    var body: some View {
        Button("Show Alert") {
            showAlert = true
        }
        .dialog(isPresented: $showAlert) {
            AlertDialog(
                title: "Update Available",
                message: "A new version is available. Would you like to update now?",
                primaryButton: DialogButton(title: "Update") {
                    showAlert = false
                    toast.success(title: "Updating...")
                },
                secondaryButton: DialogButton(title: "Later") {
                    showAlert = false
                }
            )
        }
    }
}
```

#### Confirmation Dialog
```swift
struct ConfirmationDialogExample: View {
    @Environment(\.toast) var toast
    @State private var showConfirmation = false
    
    var body: some View {
        Button("Delete Item") {
            showConfirmation = true
        }
        .dialog(isPresented: $showConfirmation) {
            ConfirmationDialog(
                title: "Delete Item?",
                message: "This action cannot be undone.",
                destructiveAction: "Delete",
                cancelAction: "Cancel",
                onConfirm: {
                    showConfirmation = false
                    toast.success(title: "Deleted")
                },
                onCancel: {
                    showConfirmation = false
                    toast.info(title: "Cancelled")
                }
            )
        }
    }
}
```

### Custom Dialog Configuration
```swift
struct CustomDialogExample: View {
    @State private var showDialog = false
    
    var body: some View {
        Button("Custom Styled Dialog") {
            showDialog = true
        }
        .dialog(
            config: DialogConfiguration(
                backgroundColor: .black.opacity(0.5),
                cornerRadius: 20,
                shadowRadius: 25,
                maxWidth: 400,
                horizontalPadding: 24,
                dismissOnBackgroundTap: true,
                animationDuration: 0.35
            ),
            isPresented: $showDialog
        ) {
            VStack(spacing: 20) {
                Text("Custom Dialog")
                    .font(.title)
                
                Text("With custom configuration")
                
                Button("Close") {
                    showDialog = false
                }
            }
            .padding()
        }
    }
}
```

### Dialog Configuration Presets
```swift
// Default configuration
.dialog(config: .default, isPresented: $showDialog) { }

// Compact dialog
.dialog(config: .compact, isPresented: $showDialog) { }

// Wide dialog
.dialog(config: .wide, isPresented: $showDialog) { }
```

### Combining Toasts & Dialogs

The real power comes from using toasts and dialogs together:
```swift
struct CombinedExample: View {
    @Environment(\.toast) var toast
    @State private var showDeleteDialog = false
    
    var body: some View {
        Button("Delete Account") {
            showDeleteDialog = true
        }
        .dialog(isPresented: $showDeleteDialog) {
            ConfirmationDialog(
                title: "Delete Account?",
                message: "All your data will be permanently deleted. This action cannot be undone.",
                destructiveAction: "Delete Forever",
                cancelAction: "Cancel",
                onConfirm: {
                    showDeleteDialog = false
                    performDeletion()
                },
                onCancel: {
                    showDeleteDialog = false
                    toast.info(title: "Cancelled", message: "Your account is safe")
                }
            )
        }
    }
    
    func performDeletion() {
        toast.progress(title: "Deleting account...")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            toast.dismiss()
            toast.success(
                title: "Account Deleted",
                message: "Your account has been permanently deleted"
            )
        }
    }
}
```

### Form Dialog Example
```swift
struct FormDialogExample: View {
    @State private var showForm = false
    @State private var name = ""
    @State private var email = ""
    @Environment(\.toast) var toast
    
    var body: some View {
        Button("Add User") {
            showForm = true
        }
        .dialog(isPresented: $showForm) {
            VStack(spacing: 20) {
                Text("New User")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                VStack(spacing: 12) {
                    TextField("Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                }
                
                HStack(spacing: 12) {
                    Button("Cancel") {
                        showForm = false
                        name = ""
                        email = ""
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    
                    Button("Save") {
                        showForm = false
                        toast.success(
                            title: "User Added",
                            message: "\(name) has been added"
                        )
                        name = ""
                        email = ""
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                }
            }
            .padding()
        }
    }
}
```

## Real-World Examples

### Error Reporting with Copy
```swift
struct ErrorReportingExample: View {
    @Environment(\.toast) var toast
    
    func handleAPIError(_ error: Error) {
        toast.error(
            title: "Network Error",
            message: """
            Code: 500
            Message: \(error.localizedDescription)
            Timestamp: \(Date().ISO8601Format())
            """,
            duration: 15.0,
            enableCopy: true, // User can copy to report the bug
            showCloseButton: true
        )
    }
    
    var body: some View {
        Button("Simulate API Error") {
            let error = NSError(
                domain: "com.app",
                code: 500,
                userInfo: [NSLocalizedDescriptionKey: "Internal Server Error"]
            )
            handleAPIError(error)
        }
    }
}
```

### Delete Confirmation Flow
```swift
struct DeleteFlowExample: View {
    @Environment(\.toast) var toast
    @State private var showDeleteDialog = false
    @State private var itemToDelete = "Document.pdf"
    
    var body: some View {
        Button("Delete \(itemToDelete)") {
            showDeleteDialog = true
        }
        .dialog(isPresented: $showDeleteDialog) {
            ConfirmationDialog(
                title: "Delete \(itemToDelete)?",
                message: "This file will be moved to trash. You can restore it within 30 days.",
                destructiveAction: "Delete",
                cancelAction: "Keep",
                onConfirm: {
                    showDeleteDialog = false
                    deleteFile()
                },
                onCancel: {
                    showDeleteDialog = false
                }
            )
        }
    }
    
    func deleteFile() {
        toast.progress(title: "Deleting...")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            toast.dismiss()
            toast.success(
                title: "Deleted",
                message: "\(itemToDelete) moved to trash"
            )
        }
    }
}
```

### Form Validation with Toasts
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

## ViewModel Integration

### Method 1: Pass as Parameter (Recommended)
```swift
import SwiftUI
import ToastUI

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
                message: error.localizedDescription,
                alignment: .bottom,
                enableCopy: true // Let user copy error for support
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

## API Reference

### Toast Manager Methods
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
    showCloseButton: Bool = true,
    enableCopy: Bool = false // ← NEW
)

// Convenience methods (all support enableCopy)
func success(title: String, message: String? = nil, duration: TimeInterval = 3.0, alignment: ToastAlignment = .top, backgroundColor: Color? = nil, configuration: ToastConfiguration = .default, showCloseButton: Bool = true, enableCopy: Bool = false)

func error(title: String, message: String? = nil, duration: TimeInterval = 3.0, alignment: ToastAlignment = .top, backgroundColor: Color? = nil, configuration: ToastConfiguration = .default, showCloseButton: Bool = true, enableCopy: Bool = false)

func warning(title: String, message: String? = nil, duration: TimeInterval = 3.0, alignment: ToastAlignment = .top, backgroundColor: Color? = nil, configuration: ToastConfiguration = .default, showCloseButton: Bool = true, enableCopy: Bool = false)

func info(title: String, message: String? = nil, duration: TimeInterval = 3.0, alignment: ToastAlignment = .top, backgroundColor: Color? = nil, configuration: ToastConfiguration = .default, showCloseButton: Bool = true, enableCopy: Bool = false)

// Dismiss methods
func dismiss() // Dismisses topmost toast
func dismissAll() // Dismisses all toasts
```

### Dialog View Modifier
```swift
func dialog<Content: View>(
    config: DialogConfiguration = .default,
    isPresented: Binding<Bool>,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping () -> Content
) -> some View
```

### Pre-built Dialog Components
```swift
// Alert Dialog
AlertDialog(
    title: String,
    message: String,
    primaryButton: DialogButton,
    secondaryButton: DialogButton? = nil
)

// Confirmation Dialog
ConfirmationDialog(
    title: String,
    message: String,
    destructiveAction: String = "Delete",
    cancelAction: String = "Cancel",
    onConfirm: @escaping () -> Void,
    onCancel: @escaping () -> Void
)

// Dialog Button
DialogButton(
    title: String,
    style: DialogButtonStyle = .primary,
    action: @escaping () -> Void
)
```

### DialogConfiguration
```swift
public struct DialogConfiguration {
    public let backgroundColor: Color // Backdrop color
    public let cornerRadius: CGFloat // Dialog corner radius
    public let shadowRadius: CGFloat // Shadow blur radius
    public let maxWidth: CGFloat // Maximum dialog width
    public let horizontalPadding: CGFloat // Screen edge padding
    public let dismissOnBackgroundTap: Bool // Tap backdrop to dismiss
    public let animationDuration: Double // Animation speed
    
    // Pre-defined styles
    public static let `default`: DialogConfiguration
    public static let compact: DialogConfiguration
    public static let wide: DialogConfiguration
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

## Best Practices

### ✅ Do

**Toasts:**
- Use appropriate toast types for different scenarios
- Keep messages concise and actionable
- Enable copy for error messages and technical info
- Use progress toasts for operations over 1 second
- Choose appropriate alignment based on context
- Use custom colors for brand consistency

**Dialogs:**
- Use dialogs for actions requiring confirmation
- Keep dialog content focused and minimal
- Provide clear primary and secondary actions
- Use pre-built components for common patterns
- Combine with toasts for complete feedback flow

### ❌ Don't

**Toasts:**
- Don't use toasts for critical errors requiring user action (use dialogs)
- Don't set extremely long durations (> 10 seconds)
- Don't forget to dismiss progress toasts
- Don't stack too many toasts (users get overwhelmed)

**Dialogs:**
- Don't use dialogs for simple notifications (use toasts)
- Don't create forms with too many fields
- Don't forget to handle both confirm and cancel actions
- Don't disable background tap dismiss unless necessary

## Troubleshooting

### Toast not showing?

Make sure `.setupToastUI()` is in your root view:
```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .setupToastUI() // ← Required!
        }
    }
}
```

### Copy button not working?

The copy button should work automatically:
1. Make sure `enableCopy: true` is set
2. Click the document icon (changes to checkmark on success)
3. Works on both iOS (UIPasteboard) and macOS (NSPasteboard)

### Dialog not dismissing?

Check these common issues:
1. Make sure `isPresented` is a `@State` variable
2. Set `isPresented = false` in your button actions
3. Check `dismissOnBackgroundTap` in config
4. Ensure no animation conflicts

### Using with multiple windows?

Each window needs its own `.setupToastUI()`:
```swift
WindowGroup {
    ContentView()
        .setupToastUI()
}

WindowGroup("Settings") {
    SettingsView()
        .setupToastUI()
}
```

## What's New in v3.2.0

### 📋 Copy to Clipboard Feature
- One-tap copy for error messages and logs
- Visual feedback with icon animation
- Cross-platform support (iOS & macOS)
- Perfect for bug reports and support

### 💬 Dialog System
- Custom dialog support with any SwiftUI view
- Pre-built Alert and Confirmation dialogs
- Configurable appearance and behavior
- Seamless integration with toast system
- Smooth bouncy animations

### 🔧 Improvements
- Better error handling examples
- Enhanced documentation
- More real-world use cases
- Performance optimizations

## Roadmap

- [ ] Swipe to dismiss gesture
- [ ] Haptic feedback support
- [ ] Sound effects
- [ ] More pre-built dialog types
- [ ] Dialog queue management
- [ ] Accessibility improvements
- [ ] macOS menu bar integration
- [ ] Custom dialog positions

## Performance

- ✅ Lightweight - Minimal memory footprint
- ✅ Efficient - Reuses views, cancels timers properly
- ✅ Smooth - 60fps animations
- ✅ Thread-safe - All operations on MainActor
- ✅ Swift 6 - Modern concurrency model

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
- GitHub: [@debuging-life](https://github.com/debuging-life)
- Twitter: [@your_handle](https://twitter.com/your_handle)

## Acknowledgments

Built with ❤️ using SwiftUI and Swift 6

Special thanks to the SwiftUI community for inspiration and feedback.

---

**If you find this package useful, please ⭐ star the repo!**

**Questions or issues?** Open an issue on GitHub

**Need help?** Check out the [Examples](Examples/) folder for complete working samples
