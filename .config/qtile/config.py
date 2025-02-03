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
from libqtile import qtile
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
from libqtile.command.client import CommandClient

mod = "mod4"
preferred_term = "alacritty"
if shutil.which(preferred_term):
    terminal = preferred_term
else:
    terminal = guess_terminal()
home = os.path.expanduser("~")

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
        [mod, "shift"],
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
    Key([mod, "control", "shift"], "r", lazy.restart(), desc="Restart qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key(
        [mod, "shift"],
        "r",
        lazy.spawn("rofi -show run"),
        desc="run a launcher menu",
    ),
    Key(
        [mod, "shift"],
        "w",
        lazy.spawn("rofi -show window"),
        desc="run a window switcher",
    ),
    Key(
        [mod],
        "r",
        lazy.spawn("rofi -show drun"),
        desc="rofi",
    ),
    Key(
        [mod, "shift"],
        "p",
        lazy.spawn(f"{home}/.config/rofi/scripts/powermenu.sh"),
        desc="rofi",
    ),
    # settings scratchpad
    KeyChord(
        [mod],
        "s",
        [
            Key([], "a", lazy.group["scratchpad"].dropdown_toggle("audio")),
            Key([], "m", lazy.group["scratchpad"].dropdown_toggle("monitor")),
            Key(["shift"], "m", lazy.spawn("autorandr --change")),
            Key([], "b", lazy.group["scratchpad"].dropdown_toggle("bluetooth")),
            Key([], "p", lazy.group["scratchpad"].dropdown_toggle("printer")),
            Key([], "n", lazy.group["scratchpad"].dropdown_toggle("network")),
            Key([], "t", lazy.group["scratchpad"].dropdown_toggle("dots_todo")),
            Key(
                [],
                "r",
                lazy.spawn(f"{home}/.config/qtile/random_background.sh"),
            ),
        ],
        desc="settings",
    ),
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
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +2%"),
        desc="<D-M><D-M><D-M><D-s>",
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -2%"),
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
        lazy.group["scratchpad"].dropdown_toggle("calculator"),
        desc="calculator",
    ),
    Key(
        [mod],
        "q",
        lazy.group["scratchpad"].dropdown_toggle("quick_text"),
        desc="quick text editor",
    ),
    Key(
        [mod],
        "p",
        lazy.group["scratchpad"].dropdown_toggle("passwords"),
        desc="password manager",
    ),
    Key(
        [mod],
        "m",
        lazy.group["scratchpad"].dropdown_toggle("system_monitor"),
        desc="System monitor",
    ),
    Key(
        [mod],
        "g",  # g van geluid lol, m and s were taken
        lazy.group["scratchpad"].dropdown_toggle("music"),
        desc="System monitor",
    ),
    # common programs
    Key(
        [mod],
        "b",
        lazy.spawn("flatpak run io.github.zen_browser.zen"),
        desc="launch browser",
    ),
    # Key([mod], "b", lazy.spawn("firefox"), desc="launch browser"),
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

dropdown_defaults = dict(height=0.7, width=0.7, y=0.15, x=0.15, opacity=1)

scratchpad = ScratchPad(
    "scratchpad",
    [
        DropDown("monitor", "arandr", on_focus_lost_hide=False, **dropdown_defaults),
        DropDown(
            "bluetooth",
            "blueman-manager",
            on_focus_lost_hide=False,
            **dropdown_defaults,
        ),
        DropDown("printer", "system-config-printer", **dropdown_defaults),
        DropDown("audio", "pavucontrol", **dropdown_defaults),
        DropDown("network", "alacritty --command nmtui", **dropdown_defaults),
        DropDown(
            "appearance", "lxappearance", on_focus_lost_hide=False, **dropdown_defaults
        ),
        DropDown(
            "dots_todo",
            f"alacritty --command nvim {home}/dots-todo.md",
            **dropdown_defaults,
        ),
        DropDown(
            "calculator", "qalculate-gtk", on_focus_lost_hide=False, **dropdown_defaults
        ),
        DropDown(
            "quick_text",
            "gnome-text-editor",
            height=0.9,
            width=0.5,
            y=0.05,
            x=0.25,
            opacity=1,
        ),
        DropDown(
            "passwords", "keepassxc", height=0.9, width=0.95, y=0.05, x=0.025, opacity=1
        ),
        DropDown(
            "system_monitor",
            "alacritty --command btop",
            height=0.9,
            width=0.95,
            y=0.05,
            x=0.025,
            opacity=1,
        ),
        DropDown(
            "music",
            "flatpak run com.spotify.Client",
            height=0.96,
            width=0.98,
            y=0.02,
            x=0.01,
            opacity=1,
            match=Match(wm_class="spotify"),
        ),
    ],
)

# use zero as key for scratchpad group
keys.extend(
    [
        Key(
            [mod],
            "0",
            lazy.group["scratchpad"].toscreen(),
            desc="Switch to group {}".format("scratchpad"),
        ),
        Key(
            [mod, "shift"],
            "0",
            lazy.window.togroup("scratchpad"),
            desc="move focused window to group {}".format("scratchpad"),
        ),
    ]
)
groups.append(scratchpad)

default_layout_settings = dict(
    border_focus=color_theme["accent"],
    border_normal=color_theme["colors"][1],
    margin=7,
    border_width=2,
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
    font="CaskaydiaCove Nerd Font",
    # font="BlexMono Nerd Font Medium",
    # font="Ubuntu Nerd Font Propo",
    fontsize=13,
    padding=6,
    # background=color_theme["colors"][0] + color_theme["transparency"],
    background=color_theme["colors"][0],
    foreground=color_theme["colors"][5],
)
extension_defaults = widget_defaults.copy()


sep = widget.Sep(
    foreground=color_theme["colors"][4], padding=6, size_percent=10, linewidth=2
)

# Only create backlit screen widget if backlight detected
backlight_widgets = []
for backlit_screen in os.listdir("/sys/class/backlight/"):
    backlight_widgets.append(
        widget.Backlight(
            change_command="brightnessctl -d '" + backlit_screen + "' s {0}%",
            backlight_name=backlit_screen,
            fmt="{} 󰃚",
            step=5,
            foreground=color_theme["colors"][5],
        ),
    )  # 🌞 ☀️🔆
    backlight_widgets.append(sep)

def create_groupbox():
    return widget.GroupBox(
        inactive=color_theme["colors"][4],
        active=color_theme["colors"][5],
        this_current_screen_border=color_theme["accent"],
        this_screen_border=color_theme["colors"][5],
        other_current_screen_border=color_theme["colors"][4],
        other_screen_border=color_theme["colors"][4],
        highlight_method="line",
        highlight_color=[color_theme["colors"][1], color_theme["colors"][3]],
        disable_drag=True,
        padding=3,
        borderwidth=2,
        margin_y=3,
        margin_x=0,
    )

def create_window_name():
    return widget.WindowName(
        max_chars=135, fmt="{:^160}", foreground=color_theme["colors"][5]
    )

widgets = (
    [
        widget.CurrentLayoutIcon(
            foreground=color_theme["colors"][11], scale=0.9, padding=3
        ),
        create_groupbox(),
        create_window_name(),
        widget.WidgetBox(
            widgets=[
                widget.CPUGraph(
                    graph_color=color_theme["colors"][8],
                    fill_color=color_theme["colors"][8],
                    border_color=color_theme["colors"][0],
                ),
                widget.NetGraph(
                    graph_color=color_theme["colors"][10],
                    fill_color=color_theme["colors"][10],
                    border_color=color_theme["colors"][0],
                ),
                widget.MemoryGraph(
                    graph_color=color_theme["colors"][11],
                    fill_color=color_theme["colors"][11],
                    border_color=color_theme["colors"][0],
                ),
                widget.Net(
                    format="{down:0>3.0f}{down_suffix: >2} ↓↑ {up:0>3.0f}{up_suffix: >2}",
                    foreground=color_theme["colors"][5],
                ),
            ],
            text_closed="",
            text_open="",
            foreground=color_theme["colors"][4],
            close_button_location="right",
            margin=0,
        ),
        widget.Systray(padding=3, icon_size=15),
        widget.Spacer(3),
        sep,
    ]
    + backlight_widgets
    + [
        widget.Volume(fmt="{} 󰕾", foreground=color_theme["colors"][5]),
        sep,
        widget.Battery(
            charge_char="󱐋",
            discharge_char="󰂌",
            empty_char="☠",
            format="{percent:2.0%} {char}",
            show_short_text=False,
            update_interval=5,
            full_char="󱊣",
            unknown_char="󰂃",
            not_charging_char="󰁹",
            foreground=color_theme["colors"][5],
        ),
        sep,
        widget.CheckUpdates(
            custom_command="pkcon get-updates --plain | grep Enhancement",
            display_format=f" {{updates}}  <span foreground=\"#{color_theme['colors'][4]}\">·</span>",
            update_interval=300,
            # foreground=color_theme["colors"][13],
            colour_have_updates=color_theme["colors"][5],
            padding=0,
        ),
        widget.Clock(format="%d %b %Y %H:%M", foreground=color_theme["colors"][5]),
    ]
)

def copy_widgets(no_systray: bool):
    widgets_copy = widgets.copy()
    # group box needs to be recreated to differantiate between desktops
    widgets_copy[1] = create_groupbox()
    widgets_copy[2] = create_window_name()
    if no_systray:
        systray_index = list(map(lambda w: type(w) is widget.Systray, widgets)).index(True)
        del widgets_copy[systray_index: systray_index+3]
    return widgets_copy

widgets_without_systray = copy_widgets(True)

bar_defaults = dict(
    size=22,
    background=color_theme["colors"][0],
    # background="#00000000",
    border_width=[0, 0, 2, 0],
    border_color=[
        color_theme["accent"],
        color_theme["accent"],
        color_theme["accent"],
        color_theme["accent"],
    ],
)

screens = [
    Screen(
        top=bar.Bar(widgets, **bar_defaults),
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        # x11_drag_polling_rate = 60,
    ),
    Screen(
        top=bar.Bar(widgets_without_systray, **bar_defaults),
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
    border_focus=color_theme["accent"],
    border_width=2,
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
    subprocess.call([home + "/.config/qtile/autostart.sh"])

@hook.subscribe.screens_reconfigured
def screen_reconf():
    qtile.reload_config()

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
