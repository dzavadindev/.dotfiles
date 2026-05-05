# Main things to still tackle

## Fixes

- The fullscreen hiding of the bar smears the elements inside it. Would have been nice to achieve a sort of "per workspace" bar effect, where together with the Hyprland workspace slide animation the bar slided in and out. Kinda like switching screens

- Quantization on the colors can be better. Should modify the color heuristic to pick colors differently. Primary - dark (bit lighter and darker variants too), Secondary - vibrant, Accent - another vibrant

- When switching tabs in the mixer, the panel is visibly detached from the screen edge for a moment. Annoying. Probably good idea to somehow change the logic of the EdgeSlideSurface to anchor to the right from the get go. Even on startup, the panel is rendered on the left, and is moved across the screen to the right with behaviour animations. Should render behind its respective edge and be anchored towards it, so that panel/surface resizing doesn't cause this 'tearing' effect

## Milestones

- System tray integration

- Bluetooth menu

- Power menu

- Lockscreen (Learn shaders to do something cool with it?)

- Wifi menu
