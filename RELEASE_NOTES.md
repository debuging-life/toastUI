# ToastUI Release Notes

## 3.5.0

### Added
- **Tap a stack to expand it.** Several toasts at once fan out into a scrollable list
  with Collapse and Clear all, instead of having to be waited out one by one. Timers
  pause while the list is open.
- **Pausing**: toasts don't count down while a finger is on one, while a stack is
  expanded, or while the app is backgrounded; `setAutoDismissPaused(_:)` exposes it.
  Durations stretch when VoiceOver is running.
- **`ToastTheme`**: shape, colours per type, default alignment and duration, animation,
  set once through `setupToastUI(theme:)`.
- **Countdown on Undo-style toasts**: a thin bar drains so the window to act is visible.
- **Async dialogs**: `await toast.confirm(…) -> Bool` and `await toast.alert(…)`.
- **`onEvent`** analytics hook: shown, dismissed (with reason), action tapped, stack
  expanded, loading shown/cancelled/dismissed.
- **Localisation**: every user-facing string moved into the package's own string catalog.
- **Rive text runs**: `RiveAnimationSource(textRuns:)` writes values inside the artboard.

### Fixed
- **Multi-window**: the toast window is created per scene, instead of once for whichever
  scene connected first — iPad and Stage Manager showed toasts in the wrong window.

## 3.4.0

### Added
- **Toast actions**: a button inside the toast (`ToastAction`) for Undo / Retry / View,
  and `onTap` for the whole toast.
- **Swipe to dismiss**, in the direction the toast came from.
- **Grouping** (`groupID`): repeat events replace the toast on screen instead of stacking.
- **Sticky toasts** (`isSticky`) that wait for the user.
- **Haptics**, opt-in: `ToastManager.hapticsEnabled` is off until the app turns it on,
  `ToastMessage.playsHaptic` overrides it per toast, and `haptics` swaps in your own.
- **`withLoading`**: runs async work behind the loading overlay, forwards progress, and
  always removes the overlay — on success, on error, and on cancellation.
- **watchOS 10** support, and `RiveAnimationCache.preload(_:)` so the first celebration
  doesn't hitch.
- GitHub Actions CI running the tests on iOS and building for macOS and watchOS.

### Changed
- When the stack is full, the least important toast is evicted rather than the oldest.
- `ToastManager.present(_:)` is public, for toasts built from a `ToastMessage`.

## 3.3.0

### Added
- **`ToastUIRive` product**: Rive-powered toast icons (`presentRive`), loading overlays
  (`showRiveProgressOverlay`) and celebrations (`showRiveCelebration`). Optional: the core
  `ToastUI` product stays dependency-free.
- **Determinate loading**: `showProgressOverlay(progress:)` draws a percentage ring, and
  `updateProgressOverlay(progress:title:message:)` updates the panel in place without
  re-animating it.
- **Cancellable loading**: `onCancel` adds a Cancel button for uploads and long syncs.
- `maximumToasts` caps the stack instead of letting it grow without limit.

### Fixed
- **Dead touch zones**: toast frames were never removed from the pass-through window's
  hit-test table, so the area where a toast used to be kept swallowing taps.
- **Blocking overlays didn't block**: the toast window passed touches through even while a
  blocking progress overlay was up.
- **Data race risk**: `ToastManager` was `@unchecked Sendable` with mutable published state;
  it is now `@MainActor`.
- A `duration` of `.infinity` no longer reaches `DispatchTime` maths.

### Changed
- Minimum platforms are now **iOS 17 / macOS 14**.
- **macOS and watchOS now actually show toasts**: they render as an overlay, since only
  iOS gets the pass-through window.
- Toasts and the loading panel are drawn by one body each (`ToastSurface`) instead of
  three near-identical ones, and `.glass` uses real Liquid Glass on iOS 26 / macOS 26.
- The examples moved to their own `ToastUIExamples` product.
- `ToastMessage.updateTitle(_:)` is internal (it was public by accident).

**Made with ❤️ for the SwiftUI community**
