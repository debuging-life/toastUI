# New Configuration API

## Clean and Sophisticated Configuration Structure

The configuration system has been refactored for maximum clarity and ease of use. All style-related properties (`backdropOpacity`, `cornerRadius`, `maxWidth`) are now encapsulated within the `OverlayStyle` enum cases.

## API Structure

```swift
UIOverlayConfiguration(
    style: .glass() or .solid(color:opacity:backdropOpacity:cornerRadius:maxWidth:),
    titleStyle: TextStyleConfiguration,
    messageStyle: TextStyleConfiguration,
    showCloseButton: Bool,
    autoDismissAfter: TimeInterval?
)
```

## OverlayStyle Options

### Glass Effect
```swift
.glass(
    backdropOpacity: Double = 0.3,
    cornerRadius: CGFloat = 20,
    maxWidth: CGFloat = 340
)
```

### Solid Color
```swift
.solid(
    backgroundColor: Color,
    opacity: Double = 1.0,
    backdropOpacity: Double = 0.3,
    cornerRadius: CGFloat = 20,
    maxWidth: CGFloat = 340
)
```

## TextStyleConfiguration

Encapsulates all text styling properties:
```swift
TextStyleConfiguration(
    color: Color = .primary,
    font: Font = .headline,
    fontWeight: Font.Weight = .semibold
)
```

### Built-in Presets
- `.title` - Default title style
- `.message` - Default message style
- `.largeBoldTitle` - Large impactful title
- `.smallLightMessage` - Subtle small message

## Usage Examples

### Example 1: Simple Glass Effect
```swift
.uiOverlay(
    state: $uiState,
    configuration: .init(
        style: .glass()
    )
)
```

### Example 2: Custom Glass with Modified Properties
```swift
.uiOverlay(
    state: $uiState,
    configuration: .init(
        style: .glass(
            backdropOpacity: 0.5,
            cornerRadius: 24,
            maxWidth: 400
        ),
        showCloseButton: true
    )
)
```

### Example 3: Solid Color with All Options
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

### Example 4: Using Text Style Presets
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

### Example 5: Dark Theme
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

## Creating Custom Text Style Presets

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

## Benefits

1. **Clean Syntax** - All related properties grouped together
2. **Type-Safe** - Compiler ensures correct usage
3. **Extensible** - Easy to add new style properties within enum cases
4. **Readable** - Clear separation between style, text, and behavior
5. **Flexible** - Use defaults or customize everything
6. **Future-Proof** - Can add new properties without breaking changes

## Migration from Old API

**Before:**
```swift
UIOverlayConfiguration(
    style: .solid(backgroundColor: .white, opacity: 1.0),
    backdropOpacity: 0.5,
    cornerRadius: 24,
    maxWidth: 380,
    titleColor: .blue,
    titleFont: .title2,
    titleFontWeight: .bold,
    messageColor: .gray,
    messageFont: .body,
    messageFontWeight: .regular,
    showCloseButton: true
)
```

**After:**
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
    showCloseButton: true
)
```
