# ToastUI Release Notes

## 3.4.0

### Added
- **Toast actions**: a button inside the toast (`ToastAction`) for Undo / Retry / View,
  and `onTap` for the whole toast.
- **Swipe to dismiss**, in the direction the toast came from.
- **Grouping** (`groupID`): repeat events replace the toast on screen instead of stacking.
- **Sticky toasts** (`isSticky`) that wait for the user.
- **Haptics** for success, error and warning; `hapticsEnabled` and a `haptics` override.
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
