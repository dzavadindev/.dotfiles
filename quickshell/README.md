# Quickshell Overview

This directory contains a custom Quickshell desktop shell setup.

## Jargon

- `OverlayHost`: Fullscreen transparent host window that composes overlay widgets, input mask regions, and transient close behavior.
- `OverlayManager`: Singleton state manager for managed overlays. Exactly one managed panel can be active at a time.
- `Surface`: Animation/interaction wrapper for panel content. Example: `EdgeSlideSurface` handles right-edge slide in/out.
- `Panel`: Managed overlay content opened via `OverlayManager` (for example `AudioMixerPanel`, `NotificationCenterPanel`).
- `Ambient popup`: Overlay content not managed by `OverlayManager` active-panel state. Example: `NotificationPopupSurface`.

## Structure

- `shell.qml`: Shell entrypoint; mounts top-level modules.
- `modules/Bar/`: Bottom bar and bar widgets (clock, volume, notifications, tray, etc.).
- `modules/Overlay/`: Overlay compositor module.
  - `OverlayHost.qml`: Fullscreen overlay host and mask composition.
  - `ambient/NotificationPopupSurface.qml`: Notification popup lane.
  - `panels/AudioMixer/AudioMixerPanel.qml`: Audio mixer managed panel content.
  - `panels/Notifications/NotificationCenterPanel.qml`: Notification center managed panel content.
- `components/`: Shared reusable UI primitives/wrappers (`EdgeSlideSurface`, icons, list helpers, window wrappers).
- `services/`: App state and system integrations (`OverlayManager`, `NotificationService`, `Pipewire`, `Hyprland`, etc.).
- `config/`: Shared design/config constants (`Appearance`, `Config`).

## Behavior Model

- Bar widgets dispatch panel toggles through `OverlayManager`.
- `OverlayHost` binds panel visibility to `OverlayManager` state.
- Managed panels are transient and single-active.
- Ambient notification popups can coexist with managed panels and do not change active panel state.
