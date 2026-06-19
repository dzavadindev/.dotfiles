------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1080@144",
	position = "0x0",
	scale = 1,
})

-- Mirror any new monitors plugged in.
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1,
	mirror = "eDP-1",
})

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "kitty"
local fileExplorer = "dolphin"
local notes =
	"/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=obsidian.sh --file-forwarding md.obsidian.Obsidian @@u %U @@"
local browser = "/home/dan/zen-browser/zen"
local mainMod = "SUPER"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("easyeffects -w --service-mode")
	hl.exec_cmd("systemctl --user import-environment QT_QPA_PLATFORMTHEME")
	hl.exec_cmd("systemctl --user start hyprland-session.target")
	hl.exec_cmd("dionysus init &")
	hl.exec_cmd("qs -d")
	hl.exec_cmd("hypridle & otd-daemon &")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("safeeyes")
	hl.exec_cmd("$XDG_CONFIG_HOME/hypr/scripts/safeeyes_fullscreen_restore.sh")

	hl.exec_cmd("[workspace 1 silent] " .. browser)
	hl.exec_cmd("[workspace 2 silent] discord")
	hl.exec_cmd("[workspace 3 silent] " .. notes)
end)

hl.on("config.reloaded", function()
	hl.exec_cmd("pkill qs; qs -d")
end)

hl.on("hyprland.shutdown", function()
	os.execute("pkill dionysus awww-daemon; systemctl --user stop hyprland-session.target && sleep 0.1")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GDK_BACKEND", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qtengine")
hl.env("PATH", "$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin")

-----------------------
----- PERMISSIONS -----
-----------------------

hl.permission("/usr/(bin|local/bin)/flameshot", "screencopy", "allow")
hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	debug = {
		disable_logs = false,
	},

	general = {
		gaps_in = 3,
		gaps_out = 3,
		border_size = 1,
		col = {
			active_border = { colors = { "rgba(e0e1ddFF)", "rgba(e0e1ddFF)" }, angle = 45 },
			inactive_border = "rgba(00000000)",
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "master",
	},

	master = {
		new_status = "slave",
	},

	cursor = {
		no_warps = true,
	},

	decoration = {
		rounding = 5,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},

		blur = {
			enabled = true,
			size = 4,
			passes = 3,
			vibrancy = 0.15,
		},
	},

	misc = {
		force_default_wallpaper = 1,
		disable_hyprland_logo = false,
		font_family = "FiraCode Nerd Font",
		focus_on_activate = true,
	},

	input = {
		kb_layout = "us, ua",
		kb_options = "ctrl:nocaps, grp:toggle",
		repeat_delay = 400,
		follow_mouse = 1,
		sensitivity = 0,

		touchpad = {
			disable_while_typing = true,
			natural_scroll = false,
		},
	},
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.05, 0.25 }, { 0.40, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.35, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 2, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.5, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.5, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.5, bezier = "almostLinear", style = "slide" })

---------------------
---- KEYBINDINGS ----
---------------------

hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(fileExplorer))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("discord"))

hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("dionysus toggle"))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("qs ipc call overlay togglePanel wallpaper_carousel"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("qs ipc call overlay togglePanel power_menu"))

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + O", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + I", hl.dsp.layout("togglesplit"))

hl.bind(mainMod .. " + Z", hl.dsp.window.fullscreen_state({ internal = 1, client = 1, action = "toggle" }))
hl.bind(mainMod .. " + Return", hl.dsp.window.fullscreen_state({ internal = 2, client = 2, action = "toggle" }))

hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("swaylock"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/screenshot.sh"))

hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + CTRL + h", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + l", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + k", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + j", hl.dsp.window.swap({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.resize({ x = 25, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.resize({ x = -25, y = 0, relative = true }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.resize({ x = 0, y = -25, relative = true }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.resize({ x = 0, y = 25, relative = true }))

for i = 1, 5 do
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "shimeji",
	match = {
		class = "com-group_finity-mascot-Main",
	},
	float = true,
	no_blur = true,
	no_focus = true,
	no_shadow = true,
})

hl.window_rule({
	name = "fullscreen-no-border",
	match = { fullscreen = true },
	border_size = 0,
})

hl.window_rule({
	name = "xwaylandvideobridge",
	match = {
		class = "xwaylandvideobridge",
	},
	opacity = 0.0,
	max_size = "1 1",
	no_initial_focus = true,
	no_blur = true,
	no_focus = true,
	no_anim = true,
})

hl.window_rule({
	name = "picture-in-picture1",
	match = {
		title = "Picture-in-Picture",
		class = "zen",
	},
	float = true,
	pin = true,
	size = "436 245",
	move = "1476 791",
})

hl.window_rule({
	name = "picture-in-picture2",
	match = {
		initial_title = "Discord Popout",
	},
	float = true,
	pin = true,
})

hl.window_rule({
	name = "kdenlive-sources",
	match = {
		title = "Kdenlive",
		float = true,
	},
	move = "466 215",
	size = "990 600",
})

hl.window_rule({
	name = "steam-notifications",
	match = {
		title = "^notificationtoast\\_.*\\_desktop$",
		class = "steam",
	},
	pin = true,
})

hl.window_rule({
	name = "tmodloader",
	match = {
		title = "^Terraria.*$",
		class = "dotnet",
	},
	fullscreen = true,
})

hl.window_rule({
	name = "hyprland-share-picker",
	match = {
		title = "kdenlive-sources",
	},
	move = "679 287",
	size = "359 459",
})

hl.window_rule({
	name = "godot",
	match = {
		class = "Godot",
	},
	focus_on_activate = true,
})

hl.window_rule({
	name = "godot-game",
	match = {
		title = "^.*DEBUG.*$",
	},
	float = true,
	size = "1600 900",
})

hl.window_rule({
	name = "meld",
	match = {
		title = "org.gnome.Meld",
	},
	maximize = true,
})

hl.window_rule({
	match = { class = "com.gabm.satty" },
	workspace = "special:screenshot silent",
	float = true,
	center = true,
})
