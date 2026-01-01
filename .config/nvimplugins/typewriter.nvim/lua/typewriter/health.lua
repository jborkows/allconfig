local M = {}

local health = vim.health or require("health")
local start = health.start or health.report_start
local ok = health.ok or health.report_ok
local warn = health.warn or health.report_warn
local error = health.error or health.report_error
local info = health.info or health.report_info

--- Get the plugin's root directory
local function get_plugin_path()
	local source = debug.getinfo(1, "S").source:sub(2)
	return vim.fn.fnamemodify(source, ":h:h:h")
end

--- Check if a file exists
---@param path string
---@return boolean
local function file_exists(path)
	return vim.fn.filereadable(path) == 1
end

function M.check()
	start("typewriter.nvim")

	-- Check for audio players
	start("Audio Players")

	local players = {
		{ name = "play (SoX)", cmd = "play", desc = "Best cross-platform option" },
		{ name = "afplay", cmd = "afplay", desc = "macOS native" },
		{ name = "paplay", cmd = "paplay", desc = "PulseAudio (Linux)" },
		{ name = "aplay", cmd = "aplay", desc = "ALSA (Linux)" },
		{ name = "mpv", cmd = "mpv", desc = "Universal media player" },
		{ name = "ffplay", cmd = "ffplay", desc = "FFmpeg player" },
	}

	local found_player = false
	for _, player in ipairs(players) do
		if vim.fn.executable(player.cmd) == 1 then
			ok(string.format("%s: available (%s)", player.name, player.desc))
			found_player = true
		else
			info(string.format("%s: not found", player.name))
		end
	end

	if not found_player then
		error("No audio player found!", {
			"Install one of the following:",
			"  - SoX: sudo apt install sox libsox-fmt-all (Linux) or brew install sox (macOS)",
			"  - PulseAudio: sudo apt install pulseaudio-utils (Linux)",
			"  - mpv: sudo apt install mpv (Linux) or brew install mpv (macOS)",
		})
	end

	-- Check sound files
	start("Sound Files")

	local plugin_root = get_plugin_path()
	local sound_dir = plugin_root .. "/sounds"

	local sounds = {
		{ name = "click1.wav", path = sound_dir .. "/click1.wav" },
		{ name = "click2.wav", path = sound_dir .. "/click2.wav" },
		{ name = "click3.wav", path = sound_dir .. "/click3.wav" },
		{ name = "carriage1.wav", path = sound_dir .. "/carriage1.wav" },
		{ name = "ding1.wav", path = sound_dir .. "/ding1.wav" },
	}

	local all_sounds_ok = true
	for _, sound in ipairs(sounds) do
		if file_exists(sound.path) then
			ok(string.format("%s: found", sound.name))
		else
			error(string.format("%s: not found at %s", sound.name, sound.path))
			all_sounds_ok = false
		end
	end

	if not all_sounds_ok then
		warn("Some sound files are missing. The plugin may not work correctly.")
	end

	-- Check plugin status
	start("Plugin Status")

	local typewriter_ok, typewriter = pcall(require, "typewriter")
	if typewriter_ok then
		ok("Plugin loaded successfully")

		if typewriter.is_enabled and typewriter.is_enabled() then
			ok("Typewriter sounds: enabled")
		else
			info("Typewriter sounds: disabled (use :TypewriterEnable to enable)")
		end

		if typewriter.get_config then
			local cfg = typewriter.get_config()
			info(string.format("Ding at column: %d", cfg.ding_at_column or 0))
			info(string.format("Character cooldown: %dms", cfg.cooldown.character))
			info(string.format("Enter cooldown: %dms", cfg.cooldown.enter))
		end
	else
		error("Failed to load plugin: " .. tostring(typewriter))
	end
end

return M
