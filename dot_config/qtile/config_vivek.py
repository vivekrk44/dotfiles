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

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile import hook

from qtile_extras import widget
from qtile_extras.widget.decorations import BorderDecoration
from qtile_extras.widget.decorations import PowerLineDecoration
from qtile_extras.widget import UPowerWidget

import colors
colors = colors.DoomOne

from utils import random_wallpaper

import os
import subprocess

'''
Hardcodes below 
'''
rofi             = "/home/vivek/.config/rofi/launchers/type-6/launcher.sh"
rofi_power       = "/home/vivek/.config/rofi/applets/bin/powermenu.sh"
rofi_battery     = "/home/vivek/.config/rofi/applets/bin/battery.sh"
rofi_volume      = "/home/vivek/.config/rofi/applets/bin/volume.sh"
rofi_wifi        = "/home/vivek/.config/rofi/applets/bin/wifi.sh"
rofi_btooth      = "/home/vivek/.config/rofi/applets/bin/bluetooth"
rofi_windows     = "/home/vivek/.config/rofi/types/type-5/window.sh"
rofi_screenshots = "/home/vivek/.config/rofi/applets/bin/screenshot.sh"

qtile_asroot = "/home/vivek/.config/qtile/scripts/qtile_asroot"

power_cpu_scaling   = "/home/vivek/.config/qtile/scripts/power/cpu_power_scaling.sh"
sound_output_switch = "/home/vivek/.config/qtile/scripts/sound/output_switcher.sh"

@hook.subscribe.startup_once
def autostart():
    subprocess.call([os.path.expanduser('~/.config/qtile/autostart.sh')])

mod = "mod4"
terminal = guess_terminal()

## Wallpapers and color scheme using pywal
# current_wallpaper = random_wallpaper("/home/vivek/.config/qtile/wallpapers")
current_wallpaper = "/home/vivek/.config/qtile/wallpapers/11.png"
use_pywal = True
if use_pywal:
    colors = []
    cache = '/home/vivek/.cache/wal/colors'
    with open(cache, 'r') as file:
        for i in range(8):
            colors.append(file.readline().strip())
    colors.append('#ffffff')
    lazy.reload()

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    # Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
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
    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "w",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    # Key([mod], "d", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    # Custom keybindings Vivek

    # Change foucs between monitors
    Key([mod], "Left", lazy.prev_screen(), desc="Move focus to next monitor"),
    Key([mod], "Right", lazy.next_screen(), desc="Move focus to prev monitor"),
    # Change volume
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")),
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),
    Key(["shift"], "F5", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")),
    Key(["shift"], "F6", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")),
    Key(["shift"], "F3", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),
    # Change output speaker to next source (headphones, speakers, etc)
    Key([], "XF86AudioNext", lazy.spawn("pactl set-sink-port @DEFAULT_SINK@ next")),
    # Change output speaker to prev source (headphones, speakers, etc)
    Key([], "XF86AudioPrev", lazy.spawn("pactl set-sink-port @DEFAULT_SINK@ prev")),
    # Brightness control 
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +1")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 1-")),
    # Rofi keys
    Key([mod], 'd', lazy.spawn(rofi)),
    Key([mod], 's', lazy.spawn(rofi_power)),
    Key([mod], 'a', lazy.spawn(rofi_windows)),
    Key([mod], 'b', lazy.spawn(rofi_battery)),
    Key([mod], 'v', lazy.spawn(rofi_volume)),

    Key([mod], 'space', lazy.spawn('rofi -show run')),
    Key([mod, "shift"], 'space', lazy.spawn('rofi -show run')),
    # Lockscreen betterlock
    Key(['control'], "l", lazy.spawn("betterlockscreen -l")),
    # Screenshots
    Key([], 'Print', lazy.spawn(rofi_screenshots)),
    Key(
        [mod, "shift"], "a", 
        lazy.spawn(os.path.expanduser(sound_output_switch)),
        desc="Cycle audio output devices"
    ),
    Key(
        [mod, "shift"], "p", 
        lazy.spawn(os.path.expanduser(qtile_asroot) + " " + os.path.expanduser(power_cpu_scaling)),
        desc="Cycle CPU frequency profiles"
    ),
]

group_names = ["1",    "2",  "3",   "4",   "5",   "6",   "7",   "8",   "9",]
group_label = ["www", "dev", "vrt", "mis", "mis", "mis", "mis", "vol", "fox"] 
groups = [Group(name=group_names[i], layout="columns", label=group_label[i]) for i, v in enumerate(group_names)]
# groups = [Group(i) for i in "123456789"]

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
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # # mod2 + shift + letter of group = move focused window to group
            Key(
                [mod, "control"],
                i.name,
                lazy.window.togroup(i.name),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    layout.Floating(border_width=4, margin=16, border_focus="e1acff", border_normal="1D22330"), 
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="sans",
    fontsize=8,
    padding=3,
)
extension_defaults = widget_defaults.copy()

rounded_powerlineRight = {
    "decorations": [
        PowerLineDecoration(
            path="rounded_right",
            size=11,
        )
    ]
}
rounded_powerlineLeft = {
    "decorations": [
        PowerLineDecoration(
            path="rounded_left",
            size=11,
        )
    ]
}

def init_widgets_list():
    widgets_list = [
        widget.Prompt(
                 font = "Ubuntu Mono",
                 fontsize=10,
                 foreground = colors[0]
        ),
        widget.GroupBox(
                 fontsize = 9,
                 margin_y = 3,
                 margin_x = 4,
                 padding_y = 2,
                 padding_x = 3,
                 borderwidth = 3,
                 active = colors[8],
                 inactive = colors[0],
                 rounded = False,
                 highlight_color = colors[2],
                 highlight_method = "line",
                 this_current_screen_border = colors[7],
                 this_screen_border = colors [4],
                 other_current_screen_border = colors[7],
                 other_screen_border = colors[4],
                 ),
        # widget.TextBox(
        #          text = '|',
        #          font = "Ubuntu Mono",
        #          foreground = colors[1],
        #          padding = 2,
        #          fontsize = 14
        #          ),
        # # widget.CurrentLayoutIcon(
        #          # custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],
        #          foreground = colors[1],
        #          padding = 0,
        #          scale = 0.7
        #          ),
        # # widget.CurrentLayout(
        #          foreground = colors[1],
        #          padding = 5
        #          ),
        # widget.TextBox(
        #          text = '|',
        #          font = "Ubuntu Monos",
        #          foreground = colors[1],
        #          padding = 2,
        #          fontsize = 14
        #          ),
        widget.Spacer(
            length=12,
            # **rounded_powerlineRight
        ),
        widget.WindowName(
                 foreground = colors[0],
                 max_chars = 90,
                 # background = colors[0],
                 # **rounded_powerlineLeft
                 ),
        # widget.Spacer(length = 4, background=colors[6], **rounded_powerlineLeft),
        widget.Spacer(length = 4, **rounded_powerlineRight),
        widget.GenPollText(
                        func=lambda: subprocess.check_output(["/home/vivek/.config/qtile/scripts/hardware/power_profile.sh"]).decode("utf-8").split("\n")[0],
                        update_interval=10,
                        foreground=colors[0],
                        background=colors[7],
                        mouse_callbacks= {"Button1": lazy.spawn(rofi_wifi),
                                          "Button3": lazy.spawn(rofi_btooth)}
                        # decorations=[
                        #     BorderDecoration(
                        #         colour = colors[7],
                        #         border_width = [0, 0, 2, 0],
                        #     )
                        # ],
        ),
        widget.Spacer(length = 4, background=colors[7], **rounded_powerlineLeft),
        widget.Spacer(length = 4, **rounded_powerlineRight),
        widget.GenPollText(
                        func=lambda: subprocess.check_output(["/home/vivek/.config/qtile/scripts/network/get_ip.sh"]).decode("utf-8").split("\n")[0],
                        update_interval=10,
                        foreground=colors[0],
                        background=colors[7],
                        mouse_callbacks= {"Button1": lazy.spawn(rofi_wifi),
                                          "Button3": lazy.spawn(rofi_btooth)}
                        # decorations=[
                        #     BorderDecoration(
                        #         colour = colors[7],
                        #         border_width = [0, 0, 2, 0],
                        #     )
                        # ],
        ),
        widget.Spacer(length = 4, background=colors[7], **rounded_powerlineLeft),
        widget.Spacer(length = 4, **rounded_powerlineRight),
        UPowerWidget(foreground=colors[0], background=colors[3], 
                     notify_below=0.9,
                     notification_timeout=0,
                     mouse_callbacks = {"Button3": lazy.spawn(rofi_battery)}
                     # decorations = [BorderDecoration(
                     #     colour = colors[3],
                     #     border_width = [0, 0, 2, 0],
                     # )
                 # ],
                      ),

        widget.Spacer(length = 4, background=colors[3], **rounded_powerlineLeft),
        # widget.Spacer(length = 4, **rounded_powerlineRight),
        # widget.CPU(
        #     format = '▓ : {freq_current}GHz {load_percent}%',
        #          foreground = colors[0],
        #          background = colors[4],
        #          # decorations=[
        #          #     BorderDecoration(
        #          #         colour = colors[4],
        #          #         border_width = [0, 0, 2, 0],
        #          #     )
        #          # ],
        #          ),
        # widget.Spacer(length = 4, background=colors[4], **rounded_powerlineLeft),
        widget.Spacer(length = 4, **rounded_powerlineRight),
        widget.Memory(
                 foreground = colors[0],
                 background = colors[4],
                 mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('alacritty' + ' -e htop')},
                 format = '{MemUsed: .0f}{mm}',
                 fmt = '🖥: {}',
                 # decorations=[
                 #     BorderDecoration(
                 #         colour = colors[5],
                 #         border_width = [0, 0, 2, 0],
                 #     )
                 # ],
                 ),
        widget.Spacer(length = 4, background=colors[4], **rounded_powerlineLeft),
        # widget.Spacer(length = 4, **rounded_powerlineRight),
        # widget.DF(
        #          update_interval = 60,
        #          foreground = colors[0],
        #          background = colors[6],
        #          mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('alacritty' + ' -e df')},
        #          partition = '/',
        #          #format = '[{p}] {uf}{m} ({r:.0f}%)',
        #          format = '{uf}{m} free',
        #          fmt = '🖴  : {}',
        #          visible_on_warn = False,
        #          # decorations=[
        #          #     BorderDecoration(
        #          #         colour = colors[6],
        #          #         border_width = [0, 0, 2, 0],
        #          #     )
        #          # ],
        #          ),
        # widget.Spacer(length = 4, background=colors[6], **rounded_powerlineLeft),
        widget.Spacer(length = 4, **rounded_powerlineRight),
        widget.Volume(
                 foreground = colors[0],
                 background = colors[7],
                 fmt = '🕫  Vol: {}',
                 mouse_callbacks= {"Button3": lazy.spawn('pavucontrol')}
                 # decorations=[
                 #     BorderDecoration(
                 #         colour = colors[7],
                 #         border_width = [0, 0, 2, 0],
                 #     )
                 # ],
                 ),
        widget.Spacer(length = 4, background=colors[7], **rounded_powerlineLeft),
        widget.Spacer(length = 4, **rounded_powerlineRight),
        widget.Clock(
                 foreground = colors[0],
                 background = colors[8],
                 format = "⏱  %a, %b %d - %H:%M",
                 mouse_callbacks= {"Button1": lazy.spawn(rofi_power)}
                 # decorations=[
                 #     BorderDecoration(
                 #         colour = colors[8],
                 #         border_width = [0, 0, 2, 0],
                 #     )
                 # ],
                 ),
        widget.Spacer(length = 4, background=colors[8], **rounded_powerlineLeft),
        widget.Spacer(length = 4),
        widget.Systray(padding = 3),
        widget.Spacer(length = 8),

        ]
    return widgets_list


screens = [
        Screen(top=bar.Bar(widgets=init_widgets_list(), size=26, background='#0000000A'),
               # wallpaper = current_wallpaper,
               # wallpaper_mode = 'fill'
              ),
        Screen(# top=bar.Bar(widgets=init_widgets_list()[:-3], size=26, background='#0000000A')
               # wallpaper = current_wallpaper,
               # wallpaper_mode = 'fill'
              )
        ]

# var_gap_top = 45
# var_gap_bottom = 5
# var_gap_left = 5
# var_gap_right = 5
# screens = [
#     Screen(
#         right=bar.Gap(var_gap_right),
#         left=bar.Gap(var_gap_left),
#         bottom=bar.Gap(var_gap_bottom),
#         top=bar.Gap(var_gap_top)
#         ),
#         Screen(
#         right=bar.Gap(var_gap_right),
#         left=bar.Gap(var_gap_left),
#         bottom=bar.Gap(var_gap_bottom),
#         top=bar.Gap(var_gap_top)
#         )
# ]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

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
# autostart()
