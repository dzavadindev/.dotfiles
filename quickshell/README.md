# Quickshell Overview

This is my shell :D


## Structure

- `modules/Bar/`: Bottom bar and bar widgets (clock, volume, notifications, tray, etc.).
- `modules/Overlay/`: Overlay compositor module.
  - `OverlayHost.qml`: Fullscreen overlay host and mask composition.
  - `ambient/`: Non-OverlayManager-managed content widgets.
  - `panels/`: OverlayManager managed content widgets.
- `components/`: Shared reusable UI primitives.
  - `surfaces/`: Surface contracts and implementations.
  - Other shared widgets: icons, list helpers, window wrappers.
- `services/`: App state and system integrations (`OverlayManager`, `WMService`, `AudioService`, `TimeService`, `PowerService`, `NotificationService`).
- `config/`: Shared design/config constants.

## Implementation Details

Here more about certain implementation details, both for me and whoever decides to study this shell, if they want.

## The `Overlay Compositor` Architecture

### Pattern

I have decided on a sort of "compositor" pattern for my overlays. An overlay is any shell widget that is not on the screen the whole time, like popups, context menus and such.

The OverlayManager is a singleton state manager for all managed overlays. Exactly one managed panel can be active at a time. The host is a fullscreen transparent window that composes overlay widgets, input mask regions, and transient close behavior.

As such, any overlay (Panel) inside of the shell would live inside of the OverlayHost, and its visibility will be managed by the OverlayManager, while the Surface defines how and where the widget will appear on the screen.

### Jargon

- `Surface`: Animation/interaction wrapper for panel content. Surface behavior contracts live in `PanelSurface` and concrete animations (like `EdgeSlideSurface`) build on it.
- `Panel` (also frequently referred to as `Widget`): Managed overlay content opened via `OverlayManager` (for example `AudioMixerPanel`, `NotificationCenterPanel`).
- `Ambient Popup`: Overlay content not managed by `OverlayManager` active-panel state. Example: `NotificationPopupSurface`.

### The closeOnAnyKeypress Handler

closeOnAnyKeypress is a surface-level policy flag that tells the overlay host whether pressing a key should dismiss the currently active managed panel. It works because the architecture state (OverlayManager) is separate from behavior (Surface contract) and input routing (OverlayHost).

What it does:
- Each managed surface (like EdgeSlideSurface) exposes:
  - closeOnAnyKeypress (bool)
  - shouldCloseOnKeypress(event) policy hook
- OverlayHost finds the currently active surface (activeSurface).
- A focused FocusScope listens for key presses.
- If activeSurface.closeOnAnyKeypress is true and the hook allows it, host calls OverlayManager.closeAll().

Key concepts at play:
- Contract component (PanelSurface): defines shared API every managed surface follows.
- Composition: concrete surfaces (EdgeSlideSurface) inherit that contract.
- Input focus routing:
  - WlrLayershell.keyboardFocus gives overlay keyboard access when open.
  - FocusScope receives Keys.onPressed reliably.

Common call path looks as follows
Open panel -> OverlayManager.activePanelId set -> OverlayHost.activeSurface resolves -> key pressed in FocusScope -> host checks closeOnAnyKeypress + shouldCloseOnKeypress -> OverlayManager.closeAll() -> panel closes + mask drops.
