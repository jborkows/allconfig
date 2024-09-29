local M = {}
local typewriter_enabled = false

local function get_plugin_path()
	local info = debug.getinfo(1, "S")
	return info.source:sub(2):match("(.*[/\\])")
end
local sound_dir = get_plugin_path() .. "../../sounds"

local playing_clicks = {}

local file_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")

local clicks = {
	sound_dir .. "/click1.wav",
	sound_dir .. "/click2.wav",
	sound_dir .. "/click3.wav",
}
local carriage = sound_dir .. "/carriage1.wav"
local ding = sound_dir .. "/ding1.wav"

local in_progress = false
local play_sound = function(sound)
	in_progress = true
	vim.fn.jobstart("play " .. sound .. " >/dev/null 2>&1", {
		on_exit = function(_, code, _)
			in_progress = false
		end,
	})
end

local last_job_time = 0 -- Track the last job time
local cooldown = 200
local counter = 1
local play_character = function()
	local current_time = vim.loop.now() -- Get the current time in milliseconds
	local time_since_last_job = current_time - last_job_time

	if time_since_last_job < cooldown then
		return
	end
	last_job_time = current_time
	vim.fn.jobstart("play " .. clicks[counter % table.maxn(clicks) + 1] .. " >/dev/null 2>&1", {
		on_exit = function() end,
	})
end

local group = vim.api.nvim_create_augroup("typewriter.nvim", { clear = true })

local catchEnter = function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "n", true)
	if typewriter_enabled then
		play_sound(carriage)
	end
end
vim.keymap.set("i", "<CR>", catchEnter, { silent = true, noremap = true })

local counter = 1
local throtle = 10
vim.api.nvim_create_autocmd("InsertCharPre", {
	group = group,
	pattern = "*",
	callback = function(args)
		if not typewriter_enabled then
			return
		end

		play_character()
	end,
})

vim.api.nvim_create_user_command("TypewriterToggle", function()
	typewriter_enabled = not typewriter_enabled
	if typewriter_enabled then
		vim.notify("Typewriter sounds enabled")
	else
		vim.notify("Typewriter sounds disabled")
	end
end, {})
M.setup = function() end
return M
