# Glass Effect Toast - iOS 26+ Feature

## Overview

The ToastUI package now includes a beautiful glass effect toast that automatically detects iOS version and provides appropriate styling. On iOS 26+, it uses the new ultra-thin material effect for a stunning glass-like appearance. On older iOS versions, it gracefully falls back to a regular material effect.

## Features

- **Automatic OS Detection**: Checks for iOS 26+ before applying glass effect
- **Graceful Fallback**: Uses regular material effect on iOS < 26
- **Consistent API**: Same convenience method works across all iOS versions
- **Adaptive Styling**: Text colors adapt to light/dark mode automatically
- **All Standard Features**: Supports custom icons, copy-to-clipboard, and close buttons

## Usage

### Basic Glass Toast

```swift
import SwiftUI
import ToastUI

struct ContentView: View {
    @Environment(\.toast) var toast

    var body: some View {
        Button("Show Glass Toast") {
            toast.glass(
                title: "Glass Effect",
                message: "Beautiful translucent design"
            )
        }
    }
}
```

### With Custom Configuration

```swift
Button("Custom Glass Toast") {
    toast.glass(
        title: "Premium Feature",
        message: "Exclusive glass design for iOS 26+",
        duration: 5.0,
        alignment: .top,
        configuration: .rounded,
        showCloseButton: true,
        enableCopy: false
    )
}
```

### With Custom Icon

```swift
Button("Glass with Icon") {
    toast.present(
        title: "New Message",
        message: "You have a notification",
        type: .glass,
        duration: 4.0
    ) {
        Image(systemName: "bell.fill")
            .font(.title2)
            .foregroundStyle(.primary)
    }
}
```

### Different Alignments

```swift
VStack(spacing: 20) {
    Button("Glass - Top") {
        toast.glass(
            title: "Top Position",
            message: "Glass effect at the top",
            alignment: .top
        )
    }

    Button("Glass - Center") {
        toast.glass(
            title: "Center Position",
            message: "Glass effect in center",
            alignment: .center
        )
    }

    Button("Glass - Bottom") {
        toast.glass(
            title: "Bottom Position",
            message: "Glass effect at bottom",
            alignment: .bottom
        )
    }
}
```

### Enable Copy Feature

```swift
Button("Glass with Copy") {
    toast.glass(
        title: "Session ID",
        message: "abc-123-def-456",
        enableCopy: true
    )
}
```

## Implementation Details

### iOS 26+ (Glass Effect)
- Uses `.ultraThinMaterial` for maximum translucency
- Subtle white border overlay for definition
- Adapts text colors using `.primary` and `.secondary`
- Fully supports dark mode

### iOS < 26 (Fallback)
- Uses `.regularMaterial` for compatibility
- Slightly less translucent but still beautiful
- Same layout and functionality
- Seamless user experience

## Technical Details

### Device Detection

The package includes a `DeviceCapabilities` utility that checks:

```swift
struct DeviceCapabilities {
    static var supportsGlassEffect: Bool {
        #if os(iOS)
        if #available(iOS 26.0, *) {
            return true
        }
        return false
        #else
        return false
        #endif
    }
}
```

### Toast Type

A new `.glass` case has been added to `ToastType`:

```swift
public enum ToastType {
    case success
    case error
    case warning
    case info
    case progress
    case glass  // New!
}
```

## Visual Comparison

### iOS 26+ Glass Effect
- Ultra-thin translucent background
- Content behind the toast is clearly visible with blur
- White border for subtle definition
- Modern, premium appearance

### iOS < 26 Fallback
- Regular material translucent background
- Slightly more opaque than iOS 26+ version
- Maintains consistent look and feel
- Still provides beautiful blur effect

## Best Practices

1. **Use for Premium Features**: The glass effect is perfect for highlighting premium features or important notifications

2. **Consider Background**: Glass effects work best when there's interesting content behind them

3. **Don't Overuse**: Reserve glass toasts for special occasions to maintain their impact

4. **Test on Multiple iOS Versions**: Verify the fallback appearance on iOS < 26

5. **Combine with Other Types**: Mix glass toasts with standard colored toasts for visual hierarchy

## Example Scenarios

### Premium Feature Unlock
```swift
toast.glass(
    title: "Premium Unlocked!",
    message: "You now have access to all features",
    duration: 5.0,
    alignment: .center
)
```

### System Notification
```swift
toast.glass(
    title: "System Update",
    message: "iOS 26 features are now available",
    alignment: .top,
    showCloseButton: true
)
```

### Subtle Information
```swift
toast.glass(
    title: "Tip",
    message: "Swipe down to refresh",
    duration: 4.0,
    alignment: .bottom
)
```

## API Reference

```swift
@MainActor
public func glass(
    title: String,
    message: String? = nil,
    duration: TimeInterval = 3.0,
    alignment: ToastAlignment = .top,
    configuration: ToastConfiguration = .default,
    showCloseButton: Bool = true,
    enableCopy: Bool = false
)
```

### Parameters

- `title`: The main text displayed in the toast
- `message`: Optional secondary text (default: nil)
- `duration`: How long the toast stays visible in seconds (default: 3.0)
- `alignment`: Position on screen - `.top`, `.center`, or `.bottom` (default: .top)
- `configuration`: Styling preset - `.default`, `.compact`, `.rounded`, or `.minimal` (default: .default)
- `showCloseButton`: Whether to show the X button (default: true)
- `enableCopy`: Whether to show the copy button (default: false)

## Requirements

- iOS 16.0+ (glass effect available on iOS 26.0+)
- Swift 6.2+
- ToastUI 3.2.0+

## Notes

- The glass effect automatically detects the iOS version at runtime
- No additional configuration needed - it just works!
- The fallback ensures a consistent experience across all supported iOS versions
- Works seamlessly with all existing ToastUI features (stacking, alignment, timers, etc.)
