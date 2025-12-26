# ToastUI Release Notes

## Version 3.3.0 - Sophisticated Configuration System

### 🎨 Major Features

#### **Clean, Sophisticated Configuration API**
Complete redesign of the overlay configuration system with a focus on clarity, organization, and extensibility.

**New Configuration Structure:**
```swift
UIOverlayConfiguration(
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
```

#### **TextStyleConfiguration Model**
New dedicated model for text styling with complete control over appearance:
- **Color** - Any SwiftUI Color
- **Font** - Any SwiftUI Font (headline, title, custom, etc.)
- **Font Weight** - Full range from ultraLight to black

**Built-in Presets:**
- `.title` - Default title style
- `.message` - Default message style
- `.largeBoldTitle` - Impactful large text
- `.smallLightMessage` - Subtle small text

#### **Enhanced OverlayStyle Enum**
Style-related properties now encapsulated within enum cases:

**Glass Effect:**
```swift
.glass(
    backdropOpacity: 0.3,
    cornerRadius: 20,
    maxWidth: 340
)
```

**Solid Color:**
```swift
.solid(
    backgroundColor: .white,  // Renamed from 'color' for clarity
    opacity: 1.0,
    backdropOpacity: 0.3,
    cornerRadius: 20,
    maxWidth: 340
)
```

### ✨ New Features

1. **Custom Text Style Presets**
   - Create reusable text style configurations
   - Example: `.errorStyle`, `.successStyle`, `.warningStyle`

2. **Improved Parameter Naming**
   - `backgroundColor` instead of `color` in `.solid()` for clarity
   - More intuitive and self-documenting API

3. **Computed Properties**
   - Access style properties through configuration
   - `backgroundColor`, `overlayOpacity`, `backdropOpacity`, etc.

4. **Default White Background**
   - Changed default from glass to solid white (1.0 opacity)
   - More predictable default appearance

### 🔧 Improvements

#### **Better Organization**
- Style properties (backdrop, corner radius, max width) grouped in `OverlayStyle`
- Text properties (color, font, weight) grouped in `TextStyleConfiguration`
- Behavior properties (close button, auto-dismiss) in `UIOverlayConfiguration`

#### **Enhanced Extensibility**
- Easy to add new text style presets
- Simple to create custom configurations
- Future-proof design for new properties

#### **Cleaner Syntax**
```swift
// Before (verbose and scattered)
UIOverlayConfiguration(
    style: .solid(color: .white),
    backdropOpacity: 0.5,
    cornerRadius: 24,
    maxWidth: 380,
    titleColor: .blue,
    titleFont: .title2,
    titleFontWeight: .bold,
    messageColor: .gray,
    messageFont: .body,
    messageFontWeight: .regular
)

// After (clean and organized)
UIOverlayConfiguration(
    style: .solid(
        backgroundColor: .white,
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
    )
)
```

### 📝 Usage Examples

#### Example 1: Simple Glass Effect
```swift
.uiOverlay(
    state: $uiState,
    configuration: .init(style: .glass())
)
```

#### Example 2: Custom Dark Theme
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

#### Example 3: Using Presets
```swift
.uiOverlay(
    state: $uiState,
    configuration: .init(
        style: .glass(),
        titleStyle: .largeBoldTitle,
        messageStyle: .smallLightMessage
    )
)
```

#### Example 4: Custom Presets
```swift
extension TextStyleConfiguration {
    static let errorStyle = TextStyleConfiguration(
        color: .red,
        font: .title3,
        fontWeight: .bold
    )
}

// Usage
.uiOverlay(
    state: $uiState,
    configuration: .init(
        style: .glass(),
        titleStyle: .errorStyle
    )
)
```

### 🐛 Bug Fixes

- Removed all debug print statements from production code
- Fixed auto-dismiss timer management
- Improved close button behavior with Binding-based approach
- Fixed pattern matching for new enum structures

### 📚 Documentation

- **Comprehensive README** - Complete guide with all features
- **Configuration Examples** - Multiple real-world examples
- **Custom Loader Guide** - Detailed custom loader documentation
- **API Reference** - Full type signatures and parameters

### 🔄 Breaking Changes

#### Parameter Rename
- `.solid(color:)` → `.solid(backgroundColor:)`
  - More explicit and clearer intent
  - Better alignment with SwiftUI conventions

#### Configuration Structure
- Individual color/font parameters replaced with `TextStyleConfiguration`
  - Old: `titleColor`, `titleFont`, `titleFontWeight`
  - New: `titleStyle: TextStyleConfiguration`

#### Migration Guide
```swift
// Old API
UIOverlayConfiguration(
    style: .solid(color: .white),
    titleColor: .blue,
    titleFont: .title2,
    titleFontWeight: .bold
)

// New API
UIOverlayConfiguration(
    style: .solid(backgroundColor: .white),
    titleStyle: TextStyleConfiguration(
        color: .blue,
        font: .title2,
        fontWeight: .bold
    )
)
```

### 🎯 Benefits

1. **Cleaner Code** - Related properties grouped together
2. **Type-Safe** - Compiler-enforced correctness
3. **Extensible** - Easy to add new presets and configurations
4. **Readable** - Self-documenting parameter names
5. **Maintainable** - Clear separation of concerns
6. **Future-Proof** - Can add properties without breaking changes

### 📦 What's Included

- ✅ Toast notifications with 6 types
- ✅ UI overlay system with 5 states
- ✅ Custom loader support
- ✅ Rive animation integration
- ✅ Dialog system
- ✅ Glass effect with iOS 26+ support
- ✅ Cross-platform (iOS 16+, macOS 13.1+)
- ✅ Swift 6 ready
- ✅ Complete documentation

### 🚀 Getting Started

```swift
// 1. Add to your app
.setupToastUI()

// 2. Use toasts
@Environment(\.toast) var toast
toast.success("Hello!")

// 3. Use overlays
@State private var uiState: UIState = .idle
YourView()
    .uiOverlay(state: $uiState)

// 4. Customize configuration
.uiOverlay(
    state: $uiState,
    configuration: .init(
        style: .glass(),
        titleStyle: .largeBoldTitle,
        showCloseButton: true
    )
)
```

### 📋 Full Changelog

**Added:**
- `TextStyleConfiguration` model for text styling
- Built-in text style presets (`.title`, `.message`, `.largeBoldTitle`, `.smallLightMessage`)
- `backgroundColor` parameter in `.solid()` style
- Style parameters in enum cases (`backdropOpacity`, `cornerRadius`, `maxWidth`)
- Computed properties for accessing style values
- `UIOverlayConfigurationExamples.swift` with comprehensive examples

**Changed:**
- Default overlay style from `.glass` to `.solid(backgroundColor: .white, opacity: 1.0)`
- Configuration structure to use `titleStyle` and `messageStyle`
- Parameter organization for better clarity

**Removed:**
- Individual text styling parameters in favor of `TextStyleConfiguration`
- Debug print statements from production code
- Redundant documentation files

**Fixed:**
- Auto-dismiss timer behavior
- Close button state management
- Build warnings and errors
- Cross-platform compatibility issues

---

### 🙏 Credits

Special thanks to all contributors and users who provided feedback to make this release possible!

---

### 📖 Documentation

Full documentation available in [README.md](README.md)

Example code in:
- `ToastExamplesView.swift`
- `CustomLoaderExamples.swift`
- `CustomUIStateExamples.swift`
- `UIOverlayAdvancedExamples.swift`
- `UIOverlayConfigurationExamples.swift`

---

**Made with ❤️ for the SwiftUI community**
