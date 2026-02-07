local M = {}

-- Default configuration constants
M.defaults = {
	enabled = false,
	sounds = {
		clicks = nil, -- Will be set to default sounds
		carriage = nil,
		ding = nil,
	},
	cooldown = {
		character = 200, -- ms between click sounds
		enter = 500, -- ms between carriage sounds
	},
	ding_at_column = 72, -- Play ding when approaching end of line (0 to disable)
	margin_width = 80, -- The "margin" where typing should stop (like real typewriter)
	player = "auto", -- "auto", "play", "afplay", "paplay", "aplay", or custom command
	volume = 1.0, -- Volume (0.0 to 1.0) - only works with some players
}

-- State
local state = {
	enabled = false,
	cr_keymap_set = false,
	original_cr_mapping = nil,
}

-- Active configuration (starts as a copy of defaults)
local config = vim.deepcopy(M.defaults)

-- Timing state
local timing = {
	last_click_time = 0,
	last_enter_time = 0,
	last_ding_column = 0, -- Track last column where ding played to avoid repeats
}

-- Sound paths
local sound_paths = {}

-- Detected audio player
local audio_player = nil

--- Get the plugin's root directory
local function get_plugin_path()
	local info = debug.getinfo(1, "S")
	local source = info.source:sub(2)
	-- Navigate from lua/typewriter/init.lua to plugin root
	return vim.fn.fnamemodify(source, ":h:h:h")
end

--- Detect available audio player
local function detect_audio_player()
	if config.player ~= "auto" then
		return config.player
	end

	local players = {
		{ cmd = "play", args = "%s 2>/dev/null" }, -- SoX (Linux/macOS)
		{ cmd = "afplay", args = "%s 2>/dev/null" }, -- macOS native
		{ cmd = "paplay", args = "%s 2>/dev/null" }, -- PulseAudio (Linux)
		{ cmd = "aplay", args = "%s 2>/dev/null" }, -- ALSA (Linux)
		{ cmd = "mpv", args = "--no-video --really-quiet %s 2>/dev/null" }, -- mpv
		{ cmd = "ffplay", args = "-nodisp -autoexit -loglevel quiet %s 2>/dev/null" }, -- FFmpeg
	}

	for _, player in ipairs(players) do
		if vim.fn.executable(player.cmd) == 1 then
			return player
		end
	end

	return nil
end

--- Build the command to play a sound
---@param sound_file string
---@return string|nil
local function build_play_command(sound_file)
	if not audio_player then
		return nil
	end

	if type(audio_player) == "string" then
		-- Custom player command
		return audio_player .. " " .. vim.fn.shellescape(sound_file) .. " 2>/dev/null"
	end

	-- Use detected player
	return audio_player.cmd .. " " .. string.format(audio_player.args, vim.fn.shellescape(sound_file))
end

--- Initialize sound paths
local function init_sounds()
	local plugin_root = get_plugin_path()
	local sound_dir = plugin_root .. "/sounds"

	sound_paths.clicks = config.sounds.clicks or {
		sound_dir .. "/click1.wav",
		sound_dir .. "/click2.wav",
		sound_dir .. "/click3.wav",
	}
	sound_paths.carriage = config.sounds.carriage or sound_dir .. "/carriage1.wav"
	sound_paths.ding = config.sounds.ding or sound_dir .. "/ding1.wav"
end

--- Get current time in milliseconds
---@return number
local function now()
	-- Use vim.uv (newer) or fall back to vim.loop (deprecated but available)
	local uv = vim.uv or vim.loop
	return uv.now()
end

--- Play a sound file asynchronously
---@param sound_file string
local function play_sound(sound_file)
	local cmd = build_play_command(sound_file)
	if not cmd then
		return
	end

	vim.fn.jobstart(cmd, {
		on_exit = function() end,
	})
end

--- Play a click sound with cooldown
local click_index = 1
local function play_click()
	local current_time = now()
	if current_time - timing.last_click_time < config.cooldown.character then
		return
	end

	timing.last_click_time = current_time
	play_sound(sound_paths.clicks[click_index])
	click_index = click_index % #sound_paths.clicks + 1
end

--- Play the carriage return sound with cooldown
local function play_carriage()
	local current_time = now()
	if current_time - timing.last_enter_time < config.cooldown.enter then
		return
	end

	timing.last_enter_time = current_time
	play_sound(sound_paths.carriage)
end

--- Play the ding sound (typewriter bell)
--- Real typewriters ding when you're approaching the right margin
---@param column number Current cursor column
local function maybe_play_ding(column)
	if config.ding_at_column <= 0 then
		return
	end

	-- Play ding when cursor reaches the warning column
	-- Only play once per "approach" - reset when going back left
	if column >= config.ding_at_column and timing.last_ding_column < config.ding_at_column then
		play_sound(sound_paths.ding)
	end

	timing.last_ding_column = column
end

--- Get the saved CR mapping for the current buffer/global
local function get_original_cr_mapping()
	local mappings = vim.api.nvim_get_keymap("i")
	for _, map in ipairs(mappings) do
		if map.lhs == "<CR>" then
			return map
		end
	end
	return nil
end

--- Handle Enter key press
local function handle_enter()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n", true)
	if state.enabled then
		play_carriage()
		-- Reset ding tracking on new line
		timing.last_ding_column = 0
	end
end

--- Set up the CR keymap
local function setup_cr_keymap()
	if state.cr_keymap_set then
		return
	end

	-- Save original mapping if exists
	state.original_cr_mapping = get_original_cr_mapping()

	vim.keymap.set("i", "<CR>", handle_enter, {
		silent = true,
		noremap = true,
		desc = "Typewriter: Enter with carriage sound",
	})
	state.cr_keymap_set = true
end

--- Remove the CR keymap and restore original
local function teardown_cr_keymap()
	if not state.cr_keymap_set then
		return
	end

	-- Delete our mapping
	pcall(vim.keymap.del, "i", "<CR>")

	-- Restore original if it existed
	if state.original_cr_mapping then
		local map = state.original_cr_mapping
		vim.keymap.set("i", "<CR>", map.callback or map.rhs, {
			silent = map.silent == 1,
			noremap = map.noremap == 1,
			expr = map.expr == 1,
			desc = map.desc,
		})
	end

	state.cr_keymap_set = false
	state.original_cr_mapping = nil
end

-- Autocommand group
local augroup = vim.api.nvim_create_augroup("typewriter.nvim", { clear = true })

--- Set up autocommands for typing sounds
local function setup_autocmds()
	vim.api.nvim_clear_autocmds({ group = augroup })

	vim.api.nvim_create_autocmd("InsertCharPre", {
		group = augroup,
		pattern = "*",
		callback = function()
			if not state.enabled then
				return
			end

			-- Get current column before the character is inserted
			local col = vim.fn.col(".")

			play_click()
			maybe_play_ding(col)
		end,
		desc = "Typewriter: Play click and ding sounds",
	})
end

--- Check if typewriter is enabled for current buffer
---@param bufnr number|nil Buffer number (nil for current)
---@return boolean
local function is_enabled_for_buffer(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	-- Check buffer-local override first
	local ok, buf_enabled = pcall(vim.api.nvim_buf_get_var, bufnr, "typewriter_enabled")
	if ok then
		return buf_enabled
	end

	-- Fall back to global state
	return state.enabled
end

--- Enable typewriter sounds
---@param opts table|nil Options { buffer = true for buffer-local }
function M.enable(opts)
	opts = opts or {}

	if opts.buffer then
		vim.api.nvim_buf_set_var(0, "typewriter_enabled", true)
		vim.notify("Typewriter sounds enabled (buffer-local)", vim.log.levels.INFO)
	else
		state.enabled = true
		setup_cr_keymap()
		vim.notify("Typewriter sounds enabled", vim.log.levels.INFO)
	end
end

--- Disable typewriter sounds
---@param opts table|nil Options { buffer = true for buffer-local }
function M.disable(opts)
	opts = opts or {}

	if opts.buffer then
		vim.api.nvim_buf_set_var(0, "typewriter_enabled", false)
		vim.notify("Typewriter sounds disabled (buffer-local)", vim.log.levels.INFO)
	else
		state.enabled = false
		teardown_cr_keymap()
		vim.notify("Typewriter sounds disabled", vim.log.levels.INFO)
	end
end

--- Toggle typewriter sounds
---@param opts table|nil Options { buffer = true for buffer-local }
function M.toggle(opts)
	opts = opts or {}

	if opts.buffer then
		local current = is_enabled_for_buffer()
		vim.api.nvim_buf_set_var(0, "typewriter_enabled", not current)
		vim.notify(
			"Typewriter sounds " .. (not current and "enabled" or "disabled") .. " (buffer-local)",
			vim.log.levels.INFO
		)
	else
		if state.enabled then
			M.disable()
		else
			M.enable()
		end
	end
end

--- Check if typewriter is currently enabled
---@return boolean
function M.is_enabled()
	return is_enabled_for_buffer()
end

--- Get current configuration
---@return table
function M.get_config()
	return vim.deepcopy(config)
end

--- Setup the plugin
---@param opts table|nil Configuration options
function M.setup(opts)
	opts = opts or {}

	config = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts)

	-- Detect audio player
	audio_player = detect_audio_player()

	if not audio_player then
		vim.notify(
			"typewriter.nvim: No audio player found. Install sox (play), afplay, paplay, aplay, mpv, or ffplay.",
			vim.log.levels.WARN
		)
	end

	-- Initialize sound paths
	init_sounds()

	-- Set up autocmds
	setup_autocmds()

	-- Create user commands
	vim.api.nvim_create_user_command("TypewriterToggle", function()
		M.toggle()
	end, { desc = "Toggle typewriter sounds" })

	vim.api.nvim_create_user_command("TypewriterEnable", function()
		M.enable()
	end, { desc = "Enable typewriter sounds" })

	vim.api.nvim_create_user_command("TypewriterDisable", function()
		M.disable()
	end, { desc = "Disable typewriter sounds" })

	vim.api.nvim_create_user_command("TypewriterBufferToggle", function()
		M.toggle({ buffer = true })
	end, { desc = "Toggle typewriter sounds for current buffer" })

	-- Auto-enable if configured
	if config.enabled then
		M.enable()
	end
end

return M
