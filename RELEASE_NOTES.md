# ToastUI Release Notes

## 5.0.0

Toasts you can read, loading you can trust, and optional Rive animations.

### Breaking changes
- **Minimum platforms are now iOS 17 / macOS 14 / watchOS 10** (were iOS 16 / macOS 13.1).
- **Haptics are opt-in.** Set `ToastManager.shared.hapticsEnabled = true` if you want them.
- **The examples moved** to a separate `ToastUIExamples` product. Add it to your demo
  target if you used `ToastUIExamplesView()`.
- **`ToastMessage.updateTitle(_:)` is internal** (it was public by accident).

### Added

**Reading a pile of toasts**
- Tap a stack and it fans out into a scrollable list with **Collapse** and **Clear all**,
  instead of waiting each one out. Timers pause while it's open; tapping anywhere else
  collapses it.
- Toasts stop counting down while a finger is on one, while a stack is expanded, and
  while the app is backgrounded. `setAutoDismissPaused(_:)` exposes the same control.
- Durations stretch automatically when VoiceOver is running.

**Toasts that do something**
- `ToastAction` puts an Undo / Retry / View button inside a toast, with a thin bar that
  drains so the window to act is visible.
- `onTap` handles taps on the toast body — open the run that just synced.
- Swipe to dismiss, in the direction the toast came from.
- `groupID` makes repeat events replace each other instead of stacking.
- `isSticky` keeps a toast until something dismisses it.
- `maximumToasts` caps the stack, and when it is full the least important toast makes
  way, so an error is never pushed off screen by a run of info toasts.

**Loading**
- `withLoading` runs async work behind the overlay and always removes it — on success,
  on a thrown error, and on cancellation.
- Determinate progress: `showProgressOverlay(progress:)` draws a percentage ring, and
  `updateProgressOverlay(…)` updates the panel in place without re-animating it.
- `onCancel` adds a Cancel button that cancels the task.

**Dialogs**
- `await toast.confirm(…) -> Bool` and `await toast.alert(…)`: no bindings, no callbacks.

**Rive (new `ToastUIRive` product, optional)**
- Animated toast icons (`presentRive`), loading animations driven by real progress
  through a state-machine input (`showRiveProgressOverlay`), and full-screen
  celebrations (`showRiveCelebration`).
- Text runs write values inside the artboard, so "7-day streak" can live in the
  animation rather than a label beneath it.
- `RiveAnimationCache.preload(_:)` avoids a first-play hitch; a missing or renamed
  `.riv` falls back to an SF Symbol instead of crashing; Reduce Motion skips Rive; and
  animations stop on disappear so the display link doesn't keep running.
- The core `ToastUI` product still has **zero dependencies**.

**Theming, analytics, accessibility**
- `ToastTheme` sets shape, per-type colours, default alignment and duration, and the
  animation, once through `setupToastUI(theme:)`.
- `onEvent` reports shown, dismissed (with reason), action tapped, stack expanded, and
  the loading events.
- Toasts are announced to VoiceOver, the type is spoken so colour is not the only
  signal, buttons are labelled, and the loading ring reports its percentage.
- Every user-facing string moved into the package's own string catalog.

### Fixed
- **Dead touch zones**: toast frames were never removed from the pass-through window's
  hit-test table, so the area where a toast used to be kept swallowing taps.
- **Blocking overlays didn't block**: touches passed straight through a "blocking"
  loading overlay.
- **macOS and watchOS showed nothing**: `setupToastUI()` only did anything on iOS. They
  now render through the same host as an overlay.
- **Multi-window**: the toast window is created per scene, instead of once for whichever
  scene connected first — iPad and Stage Manager put toasts in the wrong window.
- **Expanded stacks kept their toasts overlapped** instead of listing them, and Collapse
  and Clear all were not tappable in the iOS window.
- **Data race risk**: `ToastManager` was `@unchecked Sendable` with mutable published
  state; it is now `@MainActor`.
- A `duration` of `.infinity` no longer reaches `DispatchTime` maths.
- Reduce Motion replaces springs and slides with a plain fade.

### Changed
- `.glass` uses real Liquid Glass on iOS 26 / macOS 26 / watchOS 26, rather than a
  material standing in for it.
- Toasts and the loading panel are each drawn by one body (`ToastSurface`) instead of
  three near-identical ones.
- `ToastManager.present(_:)` is public, for toasts built from a `ToastMessage`.
- `Package.resolved` is no longer tracked; a library resolves nothing for its consumers.

### Testing
- 29 tests covering presentation, grouping, priority eviction, sticky behaviour,
  pausing, haptics, the loading helper, dialog continuations and the event stream.
- GitHub Actions CI runs them on iOS and builds for macOS and watchOS.

**Made with ❤️ for the SwiftUI community**
