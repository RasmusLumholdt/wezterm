local wezterm = require("wezterm")

local config = wezterm.config_builder()

--config.default_prog = { "powershell.exe" }
config.initial_cols = 120
config.initial_rows = 28
config.font_size = 10
config.max_fps = 200
config.animation_fps = 144

config.window_decorations = "RESIZE"

config.window_frame = {
    border_left_width = "0.4cell",
    border_right_width = "0.4cell",
    border_bottom_height = "0.15cell",
    border_top_height = "0.15cell",
    border_left_color = "#23372B",
    border_right_color = "#23372B",
    border_bottom_color = "#23372B",
    border_top_color = "#23372B",
}

--[[
============================
Shortcuts
============================
]]
--
-- shortcut_configuration
--

local function is_vim(pane)
    local process_info = pane:get_foreground_process_info()
    local process_name = process_info and process_info.name

    return process_name == "nvim" or process_name == "vim"
end

local direction_keys = {
    Left = "h",
    Down = "j",
    Up = "k",
    Right = "l",
    -- reverse lookup
    h = "Left",
    j = "Down",
    k = "Up",
    l = "Right",
}

local function split_nav(resize_or_move, key)
    return {
        key = key,
        mods = resize_or_move == "resize" and "META" or "CTRL",
        action = wezterm.action_callback(function(win, pane)
            if is_vim(pane) then
                -- pass the keys through to vim/nvim
                win:perform_action({
                    SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
                }, pane)
            else
                if resize_or_move == "resize" then
                    win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
                else
                    win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
                end
            end
        end),
    }
end

config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 2000 }
config.keys = {
    {
        mods = "LEADER",
        key = "c",
        action = wezterm.action.SpawnTab("CurrentPaneDomain"),
    },
    {
        mods = "LEADER",
        key = "x",
        action = wezterm.action.CloseCurrentPane({ confirm = true }),
    },
    {
        mods = "LEADER",
        key = "b",
        action = wezterm.action.ActivateTabRelative(-1),
    },
    {
        mods = "LEADER",
        key = "n",
        action = wezterm.action.ActivateTabRelative(1),
    },
    {
        mods = "LEADER",
        key = "'",
        action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
        mods = "LEADER",
        key = "-",
        action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
    },

    split_nav("move", "h"),
    split_nav("move", "j"),
    split_nav("move", "k"),
    split_nav("move", "l"),
    -- resize panes
    split_nav("resize", "h"),
    split_nav("resize", "j"),
    split_nav("resize", "k"),
    split_nav("resize", "l"),
    -- {
    --     mods = "LEADER",
    --     key = "h",
    --     action = wezterm.action.ActivatePaneDirection("Left"),
    -- },
    -- {
    --     mods = "LEADER",
    --     key = "j",
    --     action = wezterm.action.ActivatePaneDirection("Down"),
    -- },
    -- {
    --     mods = "LEADER",
    --     key = "k",
    --     action = wezterm.action.ActivatePaneDirection("Up"),
    -- },
    -- {
    --     mods = "LEADER",
    --     key = "l",
    --     action = wezterm.action.ActivatePaneDirection("Right"),
    -- },
    -- {
    --     mods = "LEADER",
    --     key = "LeftArrow",
    --     action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
    -- },
    -- {
    --     mods = "LEADER",
    --     key = "RightArrow",
    --     action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
    -- },
    -- {
    --     mods = "LEADER",
    --     key = "DownArrow",
    --     action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
    -- },
    -- {
    --     mods = "LEADER",
    --     key = "UpArrow",
    --     action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
    -- },
}

for i = 0, 9 do
    -- leader + number to activate that tab
    table.insert(config.keys, {
        key = tostring(i),
        mods = "LEADER",
        action = wezterm.action.ActivateTab(i - 1),
    })
end

-- tab bar
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true

local function tab_title(tab_info)
    local title = tab_info.tab_title
    -- if the tab title is explicitly set, take that
    if title and #title > 0 then
        return title
    end
    -- Otherwise, use the title from the active pane
    -- in that tab
    return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local title = " " .. tab.tab_index .. ": " .. tab_title(tab) .. " "
    local left_edge_text = ""
    local right_edge_text = ""

    if tab_style == "rounded" then
        title = tab.tab_index .. ": " .. tab_title(tab)
        title = wezterm.truncate_right(title, max_width - 2)
        left_edge_text = wezterm.nerdfonts.ple_left_half_circle_thick
        right_edge_text = wezterm.nerdfonts.ple_right_half_circle_thick
    end

    -- ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    -- title = wezterm.truncate_right(title, max_width - 2)

    if tab.is_active then
        return {
            { Background = { Color = colors.tab_bar_active_tab_bg } },
            { Foreground = { Color = colors.tab_bar_active_tab_fg } },
            { Text = left_edge_text },
            { Background = { Color = colors.tab_bar_active_tab_fg } },
            { Foreground = { Color = colors.tab_bar_text } },
            { Text = title },
            { Background = { Color = colors.tab_bar_active_tab_bg } },
            { Foreground = { Color = colors.tab_bar_active_tab_fg } },
            { Text = right_edge_text },
        }
    end
end)

wezterm.on("update-status", function(window, _)
    -- leader inactive
    local solid_left_arrow = ""
    local arrow_foreground = { Foreground = { Color = colors.arrow_foreground_leader } }
    local arrow_background = { Background = { Color = colors.arrow_background_leader } }
    local prefix = ""

    -- leaader is active
    if window:leader_is_active() then
        prefix = " " .. leader_prefix

        if tab_style == "rounded" then
            solid_left_arrow = wezterm.nerdfonts.ple_right_half_circle_thick
        else
            solid_left_arrow = wezterm.nerdfonts.pl_left_hard_divider
        end

        local tabs = window:mux_window():tabs_with_info()

        if tab_style ~= "rounded" then
            for _, tab_info in ipairs(tabs) do
                if tab_info.is_active and tab_info.index == 0 then
                    arrow_background = { Foreground = { Color = colors.tab_bar_active_tab_fg } }
                    solid_left_arrow = wezterm.nerdfonts.pl_right_hard_divider
                    break
                end
            end
        end
    end

    window:set_left_status(wezterm.format({
        { Background = { Color = colors.arrow_foreground_leader } },
        { Text = prefix },
        arrow_foreground,
        arrow_background,
        { Text = solid_left_arrow },
    }))
end)

-- Define Osaka Jade color scheme
config.color_schemes = {
    ["Osaka Jade"] = {
        foreground = "#F7E8B2",
        background = "#111c18",
        cursor_bg = "#E67D64",
        cursor_border = "#E67D64",
        cursor_fg = "#111c18",
        selection_bg = "#364538",
        selection_fg = "#DEB266",

        ansi = {
            "#23372B", -- black
            "#FF5345", -- red
            "#549E6A", -- green
            "#E1B55E", -- yellow
            "#75BBB3", -- blue (muted cyan tone)
            "#D2689C", -- magenta
            "#2DD5B7", -- cyan
            "#F6F5DD", -- white
        },
        brights = {
            "#53685B", -- bright black
            "#DB9F9C", -- bright red
            "#63B07A", -- bright green
            "#E5C736", -- bright yellow
            "#ACD4CF", -- bright blue
            "#75BBB3", -- bright magenta substitute
            "#8CD3CB", -- bright cyan
            "#9EEBB3", -- bright white
        },

        compose_cursor = "#81B8A8",
        scrollbar_thumb = "#364538",
        split = "#81B8A8",
    },
}

-- Apply the Osaka Jade scheme
config.color_scheme = "Osaka Jade"

-- Optional subtle gradient background to echo the VS theme
config.window_background_gradient = {
    colors = { "#111c18", "#23372B" },
    orientation = { Linear = { angle = -45.0 } },
}

config.text_background_opacity = 1
config.window_background_opacity = 0.97

return config
