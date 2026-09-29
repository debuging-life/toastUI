# ToastUI 🎉

Toasts, loading overlays and dialogs for SwiftUI — with optional Rive animations.

![Platform](https://img.shields.io/badge/platform-iOS%2017%2B%20%7C%20macOS%2014%2B%20%7C%20watchOS%2010%2B-blue)
![Swift](https://img.shields.io/badge/Swift-6.2+-orange)
![License](https://img.shields.io/badge/license-MIT-green)

```swift
@Environment(\.toast) private var toast

toast.success(title: "Run saved")
toast.error(title: "Upload failed", message: "Check your connection.")

let run = try await toast.withLoading("Uploading run", determinate: true) { report in
    try await api.upload(run) { report($0) }
}
```

---

## Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Setup](#setup)
- [Toasts](#toasts)
- [Loading overlays](#loading-overlays)
- [Async loading](#async-loading)
- [Dialogs](#dialogs)
- [Rive animations](#rive-animations)
- [Examples app](#examples-app)
- [Testing](#testing)
- [API reference](#api-reference)
- [Migrating](#migrating)

---

## Requirements

Swift 6.2, and:

| Platform | Toasts | Loading overlay | Dialogs | Notes |
| --- | --- | --- | --- | --- |
| iOS 17+ | ✅ | ✅ | ✅ | one toast window per scene, so iPad and Stage Manager show them in the right place |
| macOS 14+ | ✅ | ✅ | — | rendered as an overlay on your root view |
| watchOS 10+ | ✅ | ✅ | — | no clipboard, so the copy button is hidden |

Liquid Glass (`.glass`) uses the real `glassEffect` on iOS 26 / macOS 26 / watchOS 26, and a material below that.

## Installation

In Xcode: **File ▸ Add Package Dependencies**, then `https://github.com/debuging-life/ToastUI.git`.

Or in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/debuging-life/ToastUI.git", from: "3.5.0")
]
```

The package ships three products — pick what you need:

| Product | Contents | Dependencies |
| --- | --- | --- |
| `ToastUI` | toasts, loading overlays, dialogs | none |
| `ToastUIRive` | Rive icons, loading animations, celebrations | [rive-ios](https://github.com/rive-app/rive-ios) |
| `ToastUIExamples` | the showcase screens | ToastUI + ToastUIRive |

Apps that don't add `ToastUIRive` never link the Rive runtime.

## Setup

Once, on your root view:

```swift
import SwiftUI
import ToastUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .setupToastUI()
        }
    }
}
```

Then anywhere in the hierarchy:

```swift
struct ContentView: View {
    @Environment(\.toast) private var toast

    var body: some View {
        Button("Save") { toast.success(title: "Saved") }
    }
}
```

Outside a view — in a view model or a service — use the shared manager:

```swift
ToastManager.shared.error(title: "Sync failed")
```

---

## Toasts

### The types

```swift
toast.success(title: "Run saved")
toast.error(title: "Upload failed")
toast.warning(title: "GPS signal weak")
toast.info(title: "New challenge available")
toast.glass(title: "Liquid Glass toast")     // translucent
toast.progress(title: "Syncing…")            // spinner; call again to update the text
```

### With a message

```swift
toast.error(
    title: "Couldn't sign you in",
    message: "Check your email and password and try again."
)
```

### Alignment

```swift
toast.success(title: "Saved", alignment: .top)       // default
toast.info(title: "Centred", alignment: .center)
toast.warning(title: "Bottom", alignment: .bottom)
```

Each alignment keeps its own stack.

### Duration, and toasts that wait

```swift
toast.info(title: "Quick note", duration: 1.5)

// Sticky: stays until something dismisses it
toast.present(ToastMessage(title: "You're offline", type: .warning, isSticky: true))
```

### An action button

```swift
toast.present(
    ToastMessage(
        title: "Activity deleted",
        type: .info,
        action: ToastAction(title: "Undo") { store.undoDelete() }
    )
)

// Keep the toast open after the tap
ToastAction(title: "Retry", dismissesToast: false) { sync.retry() }
```

### Tapping the toast itself

```swift
toast.present(
    ToastMessage(
        title: "Run synced",
        type: .success,
        onTap: { router.push(.activity(id: run.id)) }
    )
)
```

### Swipe to dismiss

Built in: flick a top toast up, a bottom toast down. Nothing to configure.

### Grouping repeat events

Without a group, ten "GPS signal lost" events make ten toasts. With one, they replace each other:

```swift
toast.present(ToastMessage(title: "GPS signal lost", type: .warning, groupID: "gps"))
toast.present(ToastMessage(title: "GPS signal weak", type: .warning, groupID: "gps"))
// one toast on screen, showing the latest
```

### A custom icon

Any SwiftUI view:

```swift
toast.present(title: "Achievement unlocked", type: .success) {
    Image("medal")
        .resizable()
        .scaledToFit()
}
```

### Colours and shape

```swift
toast.success(title: "Branded", backgroundColor: Color(red: 0.65, green: 0.83, blue: 0.17))

toast.info(title: "Rounded", configuration: .rounded)   // .default, .compact, .rounded, .minimal

toast.info(
    title: "Custom",
    configuration: ToastConfiguration(
        cornerRadius: 20,
        shadowRadius: 12,
        shadowColor: .black.opacity(0.25),
        shadowY: 6,
        horizontalPadding: 16,
        verticalPadding: 14
    )
)
```

### Copy to clipboard

Handy for error codes. Hidden on watchOS, which has no pasteboard:

```swift
toast.error(title: "Sync failed", message: "Code: 500-DB-TIMEOUT", enableCopy: true)
```

### Tap the stack to read it

When several toasts pile up, the top one covers the rest. Tap the stack and it fans
out into a scrollable list with **Collapse** and **Clear all**, so nothing has to be
waited out:

```swift
toast.error(title: "Upload failed")
toast.warning(title: "GPS signal weak")
toast.info(title: "Synced 3 runs")
// tap the stack → all three, newest first
```

While the list is open nothing dismisses itself. Collapse it with the button, or by
tapping anywhere else on screen, and the timers start again. It's automatic — there's
nothing to turn on.

### Stacking, and which toast makes way

Up to three toasts are visible per alignment, with a depth effect. `maximumToasts` caps how many are kept (5 by default); when the stack is full the **least important** one is dropped, so an error is never pushed out by a run of info toasts:

```swift
ToastManager.shared.maximumToasts = 3
```

Priority: `error` > `warning` > `success` / `progress` > `info` / `glass`.

### Dismissing

```swift
toast.dismiss()                 // the topmost toast
toast.dismiss(id: someToastID)  // a specific one
toast.dismissAll()
```

Keep the id when you show something sticky:

```swift
let offline = ToastMessage(title: "You're offline", type: .warning, isSticky: true)
toast.present(offline)
// later
toast.dismiss(id: offline.id)
```

### Haptics (opt-in)

Off by default. Turn them on once:

```swift
ToastManager.shared.hapticsEnabled = true                        // success, error, warning
ToastManager.shared.haptics = { type in myHaptics.play(type) }   // or use your own
```

A single toast can override the app-wide setting either way:

```swift
toast.present(ToastMessage(title: "New personal best", type: .success, playsHaptic: true))
toast.present(ToastMessage(title: "Synced", type: .info, playsHaptic: false))
```

If your app has a Haptics switch in Settings, bind it to `hapticsEnabled`.

### Pausing

Toasts stop counting down while the user is busy with them: a finger on a toast, an
expanded stack, or the app in the background. You can do it yourself too:

```swift
toast.setAutoDismissPaused(true)    // e.g. while a tutorial overlay is up
toast.setAutoDismissPaused(false)
```

With VoiceOver running, each toast's duration is stretched so it can be read out.

### Theming

Set the look once and keep call sites short:

```swift
ContentView()
    .setupToastUI(theme: ToastTheme(
        toast: .rounded,
        overlay: .glass,
        colors: [.success: .lime, .error: .red],
        defaultAlignment: .top,
        defaultDuration: 3,
        animation: .snappy,
        showsCountdownOnActionToasts: true
    ))
```

```swift
ToastManager.shared.theme.colors[.info] = .teal   // or change it later
```

An Undo-style toast draws a thin bar that drains as its time runs out, so the window
to act is visible. Turn it off with `showsCountdownOnActionToasts: false`.

### Analytics

```swift
ToastManager.shared.onEvent = { event in
    switch event {
    case .shown(_, let title, let type): analytics.log("toast_shown", ["title": title, "type": "\(type)"])
    case .actionTapped(_, let title): analytics.log("toast_action", ["title": title])
    case .dismissed(_, let reason): analytics.log("toast_dismissed", ["reason": "\(reason)"])
    case .stackExpanded(let count): analytics.log("toast_stack_expanded", ["count": count])
    default: break
    }
}
```

### Accessibility

Handled for you: each toast is announced to VoiceOver as it appears, the type is spoken ("Error…") so colour isn't the only signal, the close and copy buttons are labelled, a Dismiss action is exposed, and the loading ring reports its percentage.

---

## Loading overlays

### Indeterminate

```swift
toast.showProgressOverlay(title: "Syncing your runs")
// ... work ...
toast.dismissProgressOverlay()
```

### Determinate, updated as work proceeds

```swift
toast.showProgressOverlay(title: "Uploading run", progress: 0)

for await fraction in upload.progress {
    toast.updateProgressOverlay(progress: fraction, title: "Uploading \(Int(fraction * 100))%")
}

toast.dismissProgressOverlay()
```

`updateProgressOverlay` changes the panel in place — no re-animation, no flicker — and clamps to `0...1`.

### Cancellable

```swift
toast.showProgressOverlay(
    title: "Uploading run",
    progress: 0,
    onCancel: { upload.cancel() }
)
```

### Dismissible by the user

```swift
toast.showProgressOverlay(title: "Working…", dismissible: true)
```

### Positions

```swift
toast.showProgressOverlay(title: "Top", position: .top)
toast.showProgressOverlay(title: "Centre", position: .center)      // default
toast.showProgressOverlay(title: "Bottom", position: .bottom)
toast.showProgressOverlay(title: "Anywhere", position: .custom(x: 200, y: 400))
```

### Looks

```swift
toast.showProgressOverlay(title: "Glass", configuration: .glass)
```

Presets: `.default`, `.glass`, `.light`, `.minimal`, `.large`, `.clear`, `.nonBlocking`, `.celebration`.

```swift
toast.showProgressOverlay(
    title: "Custom",
    configuration: ProgressOverlayConfiguration(
        backgroundColor: .black,
        backgroundOpacity: 0.9,
        cornerRadius: 20,
        minWidth: 160,
        minHeight: 160,
        isBlocking: true,      // blocks taps on the app underneath
        backdropOpacity: 0.35
    )
)
```

`isBlocking` genuinely blocks: nothing behind the overlay can be tapped while it is up.

### Your own content

```swift
toast.showProgressOverlay(configuration: .clear) {
    VStack(spacing: 12) {
        MyAnimatedLogo()
        Text("Crunching your stats…")
    }
}
```

### Checking state

```swift
if toast.isProgressOverlayShowing { … }
```

---

## Async loading

`withLoading` runs the work behind the overlay and always takes it away again — on success, on a thrown error, and on cancellation. This is the recommended way to show loading:

```swift
// No progress to report
let profile = try await toast.withLoading("Loading profile") {
    try await api.profile()
}

// Reporting progress, cancellable, with an error toast on failure
let run = try await toast.withLoading(
    "Uploading run",
    determinate: true,
    cancellable: true,
    errorTitle: "Upload failed"
) { report in
    try await api.upload(run) { report($0) }   // 0...1
}
```

Cancel cancels the task running your closure, so `Task.isCancelled` and `try Task.checkCancellation()` behave as usual.

---

## Dialogs

### Ask a question and await the answer

No bindings, no callbacks — the same shape as `withLoading`:

```swift
if await toast.confirm(title: "Delete activity?",
                       message: "This can't be undone.",
                       confirm: "Delete",
                       destructive: true) {
    await store.delete(activity)
}

await toast.alert(title: "Sync finished", message: "12 runs are up to date.")
```

Tapping outside answers false. `toast.dismissDialog()` closes it from code.

### The view modifier

For dialogs with your own content. iOS only.

### A custom dialog

```swift
@State private var showDialog = false

Button("Show") { showDialog = true }
    .dialog(isPresented: $showDialog) {
        VStack(spacing: 20) {
            Text("Custom Dialog").font(.title)
            Text("Any SwiftUI content goes here.")
            Button("Close") { showDialog = false }
        }
        .padding()
    }
```

### Pre-built content

```swift
.dialog(isPresented: $showAlert) {
    AlertDialog(
        title: "Discard run?",
        message: "This run hasn't been saved yet.",
        primaryButton: DialogButton(title: "Discard", style: .destructive) { discard() },
        secondaryButton: DialogButton(title: "Keep", style: .cancel) { showAlert = false }
    )
}

.dialog(isPresented: $showConfirm) {
    ConfirmationDialog(
        title: "Delete activity?",
        message: "This can't be undone.",
        destructiveAction: "Delete",
        cancelAction: "Cancel",
        onConfirm: { delete() },
        onCancel: { showConfirm = false }
    )
}
```

`DialogButtonStyle` is `.primary`, `.destructive` or `.cancel`.

### Configuration

```swift
.dialog(
    config: DialogConfiguration(
        backgroundColor: .black.opacity(0.6),
        cornerRadius: 24,
        shadowRadius: 20,
        maxWidth: 500,
        horizontalPadding: 24,
        dismissOnBackgroundTap: true,
        animationDuration: 0.35
    ),
    isPresented: $showDialog
) {
    DialogContent()
}
```

Presets: `.default`, `.compact`, `.wide`.

---

## Rive animations

Add the `ToastUIRive` product, put your `.riv` files in the app bundle, and describe one:

```swift
import ToastUIRive

let savedTick = RiveAnimationSource(
    asset: "toast_success",              // toast_success.riv
    stateMachine: "State Machine 1",     // default
    fallbackSymbol: "checkmark.circle.fill"
)
```

### As a toast icon

```swift
toast.presentRive(title: "Run saved", animation: savedTick, type: .success)

toast.presentRive(
    title: "Achievement unlocked",
    message: "10 runs this month",
    animation: savedTick,
    type: .success,
    duration: 4,
    iconSize: 32
)
```

### As the loading animation

Give the source a `progressInput` — a number input (0–100) in your state machine — and the animation follows real progress:

```swift
let uploading = RiveAnimationSource(
    asset: "loading_ring",
    progressInput: "progress",
    fallbackSymbol: "arrow.up.circle"
)

toast.showRiveProgressOverlay(
    animation: uploading,
    title: "Uploading run",
    progress: 0,
    onCancel: { upload.cancel() }
)

for await fraction in upload.progress {
    toast.updateProgressOverlay(progress: fraction)
}

toast.dismissProgressOverlay()
```

Leave `progress` nil for a looping animation with no percentage.

### As a celebration

```swift
toast.showRiveCelebration(
    animation: RiveAnimationSource(asset: "celebrate_streak", fallbackSymbol: "flame.fill"),
    title: "7-day streak",
    message: "Keep it going tomorrow.",
    actionTitle: "Nice!"
) {
    router.push(.streakDetails)     // optional, runs after the user taps
}
```

### Text inside the animation

Rive text runs mean a celebration can show the number inside the artwork instead of
as a label under it:

```swift
let streak = RiveAnimationSource(
    asset: "celebrate_streak",
    textRuns: ["streakCount": "7", "unit": "days"],
    fallbackSymbol: "flame.fill"
)
```

A name that doesn't exist in the file logs a line and is skipped.

### Preloading

Reading a `.riv` from disk the first time can hitch. Warm them up when the screen appears:

```swift
RiveAnimationCache.shared.preload([savedTick, uploading, streak])
RiveAnimationCache.shared.purge()    // e.g. on a memory warning
```

### Anywhere else in your app

`RiveAnimationView` is public, so it isn't limited to toasts:

```swift
RiveAnimationView(streak, size: 160)
RiveAnimationView(uploading, size: 80, progress: 0.4)
```

### What it handles for you

- **Files load once** and are cached; view models built from them are cheap.
- **A missing or renamed `.riv` never crashes.** Rive's own `RiveViewModel(fileName:)` force-tries internally; ToastUIRive loads through the throwing API and falls back to `fallbackSymbol`, with one log line.
- **Reduce Motion** skips Rive and draws the symbol instead.
- **Animations stop on disappear**, so Rive's display link doesn't keep running in the background.

> **Gotcha:** `RiveRuntime` exports its own `Color`. In a file importing both it and SwiftUI, write `SwiftUI.Color` — this module exposes `RiveToastColor` for exactly that.

---

## Examples app

The showcase screens live in their own product, so they never ship inside your app:

```swift
import ToastUIExamples

ToastUIExamplesView()
```

Add `ToastUIExamples` to a demo target only.

---

## Testing

`ToastManager` is a plain `@MainActor` class, so behaviour is testable without any views:

```swift
import Testing
@testable import ToastUI

@MainActor
@Test func aGroupedToastReplacesTheOneOnScreen() {
    let manager = ToastManager()

    manager.present(ToastMessage(title: "GPS lost", type: .warning, groupID: "gps"))
    manager.present(ToastMessage(title: "GPS weak", type: .warning, groupID: "gps"))

    #expect(manager.toasts.count == 1)
    #expect(manager.toasts[0].title == "GPS weak")
}
```

Observe haptics instead of firing them:

```swift
var played: [ToastType] = []
manager.haptics = { played.append($0) }
manager.hapticsEnabled = true
```

Run the package's own tests with ⌘U, or:

```bash
xcodebuild test -scheme ToastUI-Package -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

---

## API reference

### ToastManager

| Member | What it does |
| --- | --- |
| `success/error/warning/info/glass(title:message:…)` | show a toast of that type |
| `progress(title:)` | a toast with a spinner; showing it again updates the text |
| `present(_ toast: ToastMessage)` | show a toast you built yourself (actions, grouping, sticky) |
| `present(title:…) { icon }` | show a toast with a custom icon view |
| `dismiss()` / `dismiss(id:)` / `dismissAll()` | remove toasts |
| `maximumToasts` | cap per alignment (default 5) |
| `hapticsEnabled` / `haptics` | opt in to feedback, or supply your own |
| `showProgressOverlay(…)` | loading panel, indeterminate or determinate |
| `showProgressOverlay(…) { content }` | loading panel with your own content |
| `updateProgressOverlay(progress:title:message:)` | update it in place |
| `dismissProgressOverlay()` / `isProgressOverlayShowing` | hide it / check it |
| `withLoading(_:…) { report in }` | run async work behind the panel |

### ToastMessage

`title`, `message`, `type`, `duration`, `alignment`, `customIcon`, `backgroundColor`, `configuration`, `showCloseButton`, `enableCopy`, `groupID`, `isSticky`, `onTap`, `action`, `playsHaptic`.

### ToastUIRive

| Member | What it does |
| --- | --- |
| `RiveAnimationSource(asset:stateMachine:artboard:trigger:progressInput:fallbackSymbol:bundle:)` | describes an animation |
| `presentRive(title:animation:…)` | toast with an animated icon |
| `showRiveProgressOverlay(animation:…)` | loading panel with an animation |
| `showRiveCelebration(animation:title:…)` | full-screen celebration |
| `RiveAnimationView(_:size:tint:progress:)` | the animation as a plain view |
| `RiveAnimationCache.shared.preload(_:)` / `.purge()` | warm up / release files |

---

## Migrating

### To 3.4.0

- **Platforms:** iOS 17 / macOS 14 / watchOS 10 (was iOS 16 / macOS 13.1).
- **macOS and watchOS now actually show toasts.** `setupToastUI()` previously did nothing outside iOS.
- **Haptics are opt-in:** set `ToastManager.shared.hapticsEnabled = true` if you want them.
- **Examples moved** to the `ToastUIExamples` product; add it to your demo target if you used `ToastUIExamplesView()`.
- **`ToastMessage.updateTitle(_:)` is internal** (it was public by accident).
- `.glass` now uses real Liquid Glass on iOS 26 and later, rather than a material.

---

## Contributing

Contributions are welcome — please open an issue or a pull request.

---

## License

ToastUI is available under the MIT license. See the LICENSE file for more info.

---

## Credits

Created by [Pardip Bhatti](https://github.com/debuging-life)

---

**Made with ❤️ for the SwiftUI community**
