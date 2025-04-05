local wezterm = require "wezterm"

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end
config.default_domain = 'WSL:Arch'

-- For example, changing the color scheme:
config.color_scheme = "Tokyo Night"
config.colors = {
    foreground = "#2bb31e"
}
config.font =
    wezterm.font("Hack Nerd Font")
config.font_size = 12

config.window_decorations = "RESIZE"

-- backtick as leader key
config.leader = { key = "`", mods = "", timeout_milliseconds = 2000 }
config.keys = {{
      mods = "CTRL|SHIFT",
      key = "T",
      action = wezterm.action.SpawnCommandInNewTab({
        -- This will open a new tab with bash -l
        args = {"bash", "-l"},
        cwd = "/home/evandagur",  -- Set the working directory
      }),
    },
    { key = 'f', mods = 'LEADER', action = wezterm.action.ToggleFullScreen },
    {
        mods = "LEADER",
        key = "x",
        action = wezterm.action.CloseCurrentPane { confirm = true } --close pane
    },
    {
        mods = "LEADER",
        key = "a",
        action = wezterm.action.ActivateTabRelative(-1) -- go back a tab
    },
    {
        mods = "LEADER",
        key = "d",
        action = wezterm.action.ActivateTabRelative(1) -- go forward a tab
    },
     {
    mods = "LEADER",
    key = "\\",
    action = wezterm.action.SplitHorizontal({
      domain = "CurrentPaneDomain",
      args = {"bash", "-l", "-c", "cd /home/evandagur && exec bash"}  -- Change to directory and run bash
    }),
  },

  -- Keybinding for vertical split
  {
    mods = "LEADER",
    key = "-",
    action = wezterm.action.SplitVertical({
      domain = "CurrentPaneDomain",
      args = {"bash", "-l", "-c", "cd /home/evandagur && exec bash"}  -- Change to directory and run bash
    }),
  },
    {
        mods = "LEADER",
        key = "h",
        action = wezterm.action.ActivatePaneDirection "Left"
    },
    {
        mods = "LEADER",
        key = "j",
        action = wezterm.action.ActivatePaneDirection "Down"
    },
    {
        mods = "LEADER",
        key = "k",
        action = wezterm.action.ActivatePaneDirection "Up"
    },
    {
        mods = "LEADER",
        key = "l",
        action = wezterm.action.ActivatePaneDirection "Right"
    },
    {
        mods = "LEADER",
        key = "LeftArrow",
        action = wezterm.action.AdjustPaneSize { "Left", 5 }
    },
    {
        mods = "LEADER",
        key = "RightArrow",
        action = wezterm.action.AdjustPaneSize { "Right", 5 }
    },
    {
        mods = "LEADER",
        key = "DownArrow",
        action = wezterm.action.AdjustPaneSize { "Down", 5 }
    },
    {
        mods = "LEADER",
        key = "UpArrow",
        action = wezterm.action.AdjustPaneSize { "Up", 5 }
    },
    {
        mods = "LEADER",
        key = "c",  -- Use LEADER + u to change the directory
        action = wezterm.action.SendString("cd /home/evandagur\n")
    },
    {
        mods = "LEADER",
        key = "L",
        action = wezterm.action.ShowLauncher,
    },
    {
        key = "V",
        mods = "CTRL|SHIFT",
        action = wezterm.action.PasteFrom("Clipboard"),
      }
}

for i = 0, 9 do
    -- leader + number to activate that tab
    table.insert(config.keys, {
        key = tostring(i),
        mods = "LEADER",
        action = wezterm.action.ActivateTab(i),
    })
end

-- tab bar
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true


-- tmux status
wezterm.on("update-right-status", function(window, _)
    local SOLID_LEFT_ARROW = ""
    local ARROW_FOREGROUND = { Foreground = { Color = "#c6a0f6" } }
    local prefix = ""

    if window:leader_is_active() then
        prefix = " " .. utf8.char(0x003C) .. utf8.char(0x002F) .. utf8.char(0x003E)  -- </> in Unicod
        ARROW_FOREGROUND = { Foreground = { Color = "#0da636" } }
        SOLID_LEFT_ARROW = utf8.char(0xe0b2)
    end

    if window:active_tab():tab_id() ~= 0 then
        ARROW_FOREGROUND = { Foreground = { Color = "#1e2030" } }
    end -- arrow color based on if tab is first pane


    window:set_left_status(wezterm.format {
        { Background = { Color = "#000000" } },
        { Text = prefix },
        ARROW_FOREGROUND,
        { Text = SOLID_LEFT_ARROW },

    })
    -- dir

end)
config.foreground_text_hsb = {
    hue = 1.0,
    saturation = 1.2,
    brightness = 2, --bright background, I need to read the text

}
config.background = {
    {
        source = { File = {path = 'C:\\Users\\prakh\\Downloads\\images\\wallpapers\\purple.png', speed = 0.2}},
 opacity = 1,
 width = "100%",
 hsb = {brightness = 0.5},
    }
}


config.default_cwd = "wsl:/home/evandagur"
config.default_prog = {"/usr/sbin/nvim"} --launch neovim on boot
-- nvim launch menu
config.launch_menu = {
    {
      label = "Bash",  -- Label for Bash in the launch menu
      args = {"bash", "-l"},  -- Command to launch Bash with login shell
      cwd = "/home/evandagur",  -- Set the starting directory (optional)
    },
    {
      label = "NeoVim",  -- Label for Vim in the launch menu
      args = {"nvim"},  -- Command to launch Vim
      cwd = "/home/evandagur",  -- Set the starting directory (optional)
    },
}

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():perform_action(wezterm.action.ToggleFullScreen, pane)
end)

config.initial_cols = 120
config.initial_rows = 33
-- and finally, return the configuration to wezterm
return config