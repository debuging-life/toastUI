# ToastUI

A simple and elegant toast notification library for SwiftUI.

## Installation

### Swift Package Manager

Add ToastUI to your project:

1. In Xcode, select **File → Add Packages...**
2. Enter the repository URL: `https://github.com/yourusername/ToastUI.git`
3. Select the version you want to use

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/debuging-life/toastUI.git", from: "1.0.0")
]
```

## Usage

### Basic Usage

```swift
import SwiftUI
import ToastUI

struct ContentView: View {
    @State private var toast: Toast?

    var body: some View {
        VStack {
            Button("Show Toast") {
                toast = Toast(message: "Hello, World!", type: .success)
            }
        }
        .toast($toast)
    }
}
```

### MVVM Usage (ViewModel)

```swift
import Foundation
import Clerk
import SwiftfulRouting
import SwiftUI
import ToastUI

@Observable
class AuthVM {
    var authService: AuthServiceProtocol
    var currentSignup: SignUp?
    var errorMessage: String?
    var isRedirect: Bool = false
    var toast: Toast?

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    func signUp(data: RegisterModel) async  {
        do {
            currentSignup = try await authService.signup(data: data)
            isRedirect = true
        } catch  {
            guard let error = error as? AuthError else { return }
            toast = Toast(message: error.errorDescription!, type: .error)
        }

    }
}
```

### View

```swift
struct AnyView: View {
  @State var authVM: AuthVM
  var body: some View {
    VStack {
      // your code
    }
    .toast($authVM.taost)
  }
}
```

### Using ToastManager

```swift
import SwiftUI
import ToastUI

struct ContentView: View {
    @StateObject private var toastManager = ToastManager.shared

    var body: some View {
        VStack {
            Button("Show Success") {
                toastManager.showSuccess("Operation completed!")
            }

            Button("Show Error") {
                toastManager.showError("Something went wrong!")
            }
        }
        .toast($toastManager.toast)
    }
}
```

## Toast Types

- `.success` - Green background with checkmark icon
- `.error` - Red background with X icon
- `.warning` - Orange background with warning icon
- `.info` - Blue background with info icon

## Customization

```swift
Toast(
    message: "Custom duration",
    type: .success,
    duration: 5.0  // Show for 5 seconds
)
```

## License

MIT License
