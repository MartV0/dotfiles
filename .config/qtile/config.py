# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import shutil
import subprocess
import colors
from libqtile import bar, layout, widget, hook
from libqtile.config import (
    Click,
    Drag,
    DropDown,
    Group,
    Key,
    Match,
    Screen,
    ScratchPad,
    KeyChord,
)
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

mod = "mod4"
preferred_term = "alacritty"
if shutil.which(preferred_term):
    terminal = preferred_term
else:
    terminal = guess_terminal()

color_theme = colors.catppuccin

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    Key([mod], "period", lazy.next_screen(), desc="Move focus to next monitor"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key(
        [mod, "control"],
        "h",
        lazy.layout.grow_left().when(layout=["bsp", "columns"]),
        lazy.layout.grow().when(layout=["monadtall", "monadwide", "monadthreecol"]),
    ),
    Key(
        [mod, "control"],
        "l",
        lazy.layout.grow_right().when(layout=["bsp", "columns"]),
        lazy.layout.shrink().when(layout=["monadtall", "monadwide", "monadthreecol"]),
    ),
    Key(
        [mod, "control"],
        "j",
        lazy.layout.grow_down().when(layout=["bsp", "columns"]),
        lazy.layout.shrink().when(layout=["monadtall", "monadwide", "monadthreecol"]),
    ),
    Key(
        [mod, "control"],
        "k",
        lazy.layout.grow_up().when(layout=["bsp", "columns"]),
        lazy.layout.grow().when(layout=["monadtall", "monadwide", "monadthreecol"]),
    ),
    Key(
        [mod],
        "n",
        lazy.layout.normalize(),
        lazy.layout.reset(),
        desc="Reset all window sizes",
    ),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod],
        "t",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control", "shift"], "r", lazy.restart(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key(
        [mod, "shift"],
        "r",
        lazy.spawn("rofi -show run -theme Arc-Dark"),
        desc="run a launcher menu",
    ),
    Key(
        [mod, "shift"],
        "w",
        lazy.spawn("rofi -show window -theme Arc-Dark"),
        desc="run a window switcher",
    ),
    Key([mod], "r", lazy.spawn("rofi -show drun -theme Arc-Dark"), desc="rofi"),
    # settings scratchpad
    KeyChord(
        [mod],
        "s",
        [
            Key([], "a", lazy.group["settings"].dropdown_toggle("audio")),
            Key([], "m", lazy.group["settings"].dropdown_toggle("monitor")),
            Key([], "b", lazy.group["settings"].dropdown_toggle("bluetooth")),
            Key([], "p", lazy.group["settings"].dropdown_toggle("printer")),
            Key([], "t", lazy.group["settings"].dropdown_toggle("appearance")),
            Key([], "n", lazy.group["settings"].dropdown_toggle("network")),
        ],
        desc="settings",
    ),
    # brightness keys: misschien widget hiervoor?
    Key(
        [],
        "XF86MonBrightnessUp",
        lazy.spawn("brightnessctl s 10+"),
        desc="Increase Brightness",
    ),
    Key(
        [],
        "XF86MonBrightnessDown",
        lazy.spawn("brightnessctl s 10-"),
        desc="Decrease Brightness",
    ),
    # screenshot shortcuts
    Key(
        [], "Print", lazy.spawn("flameshot gui --clipboard"), desc="Increase Brightness"
    ),
    Key(["shift"], "Print", lazy.spawn("flameshot screen"), desc="Increase Brightness"),
    # quick acces scratchpad
    Key(
        [mod],
        "c",
        lazy.group["quick_acces"].dropdown_toggle("calculator"),
        desc="calculator",
    ),
    Key(
        [mod],
        "q",
        lazy.group["quick_acces"].dropdown_toggle("quick_text"),
        desc="quick text editor",
    ),
    Key(
        [mod],
        "p",
        lazy.group["quick_acces"].dropdown_toggle("passwords"),
        desc="quick text editor",
    ),
    # common programs
    Key([mod], "b", lazy.spawn("firefox"), desc="launch browser"),
    Key([mod], "f", lazy.spawn("thunar"), desc="launch file browser"),
    Key([mod], "e", lazy.spawn("emacsclient -c -a 'emacs'"), desc="launch emacs"),
]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            # Key(
            # [mod, "shift"],
            # i.name,
            # lazy.window.togroup(i.name, switch_group=True),
            # desc="Switch to & move focused window to group {}".format(i.name),
            # ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name),
                desc="move focused window to group {}".format(i.name),
            ),
        ]
    )

dropdown_defaults = dict(height=0.7, width=0.7, y=0.15, x=0.15, opacity=0.95)

settings_scratchpad = ScratchPad(
    "settings",
    [
        DropDown("monitor", "arandr", **dropdown_defaults),
        DropDown("bluetooth", "blueman-manager", **dropdown_defaults),
        DropDown("printer", "system-config-printer", **dropdown_defaults),
        DropDown("audio", "pavucontrol", **dropdown_defaults),
        DropDown("network", "alacritty --command nmtui", **dropdown_defaults),
        DropDown("appearance", "lxappearance", **dropdown_defaults),
    ],
)

quick_scratchpad = ScratchPad(
    "quick_acces",
    [
        DropDown("calculator", "qalculate-gtk", **dropdown_defaults),
        DropDown(
            "quick_text", "gnome-text-editor", height=0.9, width=0.5, y=0.05, x=0.25
        ),
        DropDown("passwords", "keepassxc", height=0.9, width=0.95, y=0.05, x=0.025),
    ],
)

groups.append(settings_scratchpad)
groups.append(quick_scratchpad)

# TODO flameshot keybindings?
# TODO albert ipv rofi?
# TODO logout manager

default_layout_settings = dict(
    border_focus=color_theme["accent"],
    border_normal=color_theme["colors"][0],
    margin=7,
    border_width=3,
    margin_on_single=False,
    border_on_single=False,
    single_border_width=0,
    single_margin=0,
)

layouts = [
    layout.MonadTall(**default_layout_settings),
    layout.Max(),
    layout.Columns(num_columns=3, **default_layout_settings),
]

widget_defaults = dict(
    # font="Fira Code SemiBold",
    font="Jetbrains Mono SemiBold",  # ibm plex,source code pro,Caskaydia Cove,
    fontsize=11,
    padding=5,
    background=color_theme["colors"][0] + color_theme["transparency"],
    foreground=color_theme["colors"][0],
)
extension_defaults = widget_defaults.copy()


def create_widget_list(systray: bool):
    optional_widgets = []

    if systray:
        # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
        optional_widgets.append(widget.Systray())
        optional_widgets.append(widget.Spacer(4))

    # Only create backlit screen widget if backlight detected
    for backlit_screen in os.listdir("/sys/class/backlight/"):
        optional_widgets.append(
            widget.Backlight(
                change_command="brightnessctl -d '" + backlit_screen + "' s {0}%",
                backlight_name=backlit_screen,
                fmt="{} 🔆",
                step=5,
                background=color_theme["colors"][10],
            ),
        )  # 🌞 ☀️

    return (
        [
            widget.CurrentLayoutIcon(
                background=color_theme["colors"][11], scale=0.9, padding=5
            ),
            widget.GroupBox(
                inactive=color_theme["colors"][0],
                active=color_theme["colors"][0],
                this_current_screen_border=color_theme["colors"][11],
                this_screen_border=color_theme["colors"][15],
                other_current_screen_border=color_theme["colors"][10],
                other_screen_border=color_theme["colors"][7],
                highlight_method="block",
                highlight_color=color_theme["colors"][4],
                disable_drag=True,
                background=color_theme["colors"][13],
                padding=2,
            ),
            widget.Prompt(),
            widget.Spacer(length=150),
            widget.WindowName(
                max_chars=150, fmt="{:^150}", foreground=color_theme["colors"][5]
            ),
            widget.Chord(
                chords_colors={
                    "launch": ("#ff0000", "#ffffff"),
                },
                name_transform=lambda name: name.upper(),
            ),
            widget.WidgetBox(
                widgets=[
                    widget.CPUGraph(
                        graph_color=color_theme["colors"][8],
                        fill_color=color_theme["colors"][8],
                    ),
                    widget.NetGraph(
                        graph_color=color_theme["colors"][10],
                        fill_color=color_theme["colors"][10],
                    ),
                    widget.MemoryGraph(
                        graph_color=color_theme["colors"][11],
                        fill_color=color_theme["colors"][11],
                    ),
                    widget.Net(
                        format="{down:0>3.0f}{down_suffix: >2} ↓↑ {up:0>3.0f}{up_suffix: >2}",
                        foreground=color_theme["colors"][5],
                    ),
                ],
                text_closed="",
                text_open="",
                foreground=color_theme["colors"][11],
                close_button_location="right",
            ),
        ]
        + optional_widgets
        + [
            widget.Volume(fmt="{} 🔊", background=color_theme["colors"][12]),
            widget.Battery(
                charge_char="⚡",
                discharge_char="🔋",  # 🔋
                empty_char="☠",
                format="{percent:2.0%} {char}",
                show_short_text=False,
                update_interval=5,
                full_char="🔋",
                unknown_char="🔋",
                background=color_theme["colors"][11],
            ),
            widget.CheckUpdates(
                custom_command="pkcon get-updates --plain | grep Enhancement",
                display_format="{updates} ⬆️",
                update_interval=300,
                background=color_theme["colors"][13],
            ),
            widget.Clock(format="%d %b %Y %H:%M", background=color_theme["colors"][14]),
            widget.QuickExit(
                default_text=" ⏻ ",
                countdown_format="[{}]",
                background=color_theme["colors"][8],
                fontsize=15,
            ),
        ]
    )


# TODO: automatisch tweede scherm detecteren?, subscribe.screens_reconfigured()
screens = [
    Screen(
        top=bar.Bar(
            create_widget_list(True),
            size=24,
            background="#00000000",
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
    Screen(
        top=bar.Bar(
            create_widget_list(False),
            size=24,
            background="#00000000",
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = False
bring_front_click = False
floats_kept_above = True
cursor_warp = True
floating_layout = layout.Floating(
    border_focus="#89b4fa",
    border_width=3,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser("~")
    subprocess.call([home + "/.config/qtile/autostart.sh"])


# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
