local typewriter = require("typewriter")
local assert = require("luassert.assert")

math.randomseed(os.time())
local function random_int(min, max)
	return math.random(min, max)
end

local function assert_other_values_are_defaults(config, defaults)
	assert.equals(defaults.cooldown.character, config.cooldown.character)
	assert.equals(defaults.margin_width, config.margin_width)
end

local function clear_buffer_state()
	local bufnr = vim.api.nvim_get_current_buf()
	pcall(vim.api.nvim_buf_del_var, bufnr, "typewriter_enabled")
end

describe("typewriter", function()
	before_each(function()
		clear_buffer_state()
		typewriter.setup()
		typewriter.disable()
	end)

	describe("setup", function()
		it("should initialize with default config", function()
			local config = typewriter.get_config()
			local defaults = typewriter.defaults
			assert.equals(defaults.enabled, config.enabled)
			assert.equals(defaults.cooldown.character, config.cooldown.character)
			assert.equals(defaults.cooldown.enter, config.cooldown.enter)
			assert.equals(defaults.ding_at_column, config.ding_at_column)
			assert.equals(defaults.margin_width, config.margin_width)
			assert.equals(defaults.player, config.player)
			assert.equals(defaults.volume, config.volume)
		end)

		it("should merge enabled=true from user config", function()
			local defaults = typewriter.defaults
			typewriter.setup({ enabled = true })
			local config = typewriter.get_config()
			assert.equals(true, config.enabled)
			assert_other_values_are_defaults(config, defaults)
		end)

		it("should merge enabled=false from user config", function()
			local defaults = typewriter.defaults
			typewriter.setup({ enabled = false })
			local config = typewriter.get_config()
			assert.equals(false, config.enabled)
			assert_other_values_are_defaults(config, defaults)
		end)

		it("should overwrite default values with user config", function()
			local defaults = typewriter.defaults
			local expected_character = defaults.cooldown.character + random_int(1, 10)
			local expected_enter = defaults.cooldown.enter + random_int(1, 10)
			local expected_ding = defaults.ding_at_column + random_int(1, 10)
			local expected_margin = defaults.margin_width + random_int(1, 10)
			typewriter.setup({
				cooldown = {
					character = expected_character,
					enter = expected_enter,
				},
				ding_at_column = expected_ding,
				margin_width = expected_margin,
			})
			local config = typewriter.get_config()
			assert.are_not.equals(defaults.cooldown.character, config.cooldown.character)
			assert.are_not.equals(defaults.cooldown.enter, config.cooldown.enter)
			assert.are_not.equals(defaults.ding_at_column, config.ding_at_column)
			assert.are_not.equals(defaults.margin_width, config.margin_width)
			assert.equals(expected_character, config.cooldown.character)
			assert.equals(expected_enter, config.cooldown.enter)
			assert.equals(expected_ding, config.ding_at_column)
			assert.equals(expected_margin, config.margin_width)
		end)

		it("should create user commands", function()
			local commands = vim.api.nvim_get_commands({})
			assert.is_not_nil(commands.TypewriterToggle)
			assert.is_not_nil(commands.TypewriterEnable)
			assert.is_not_nil(commands.TypewriterDisable)
			assert.is_not_nil(commands.TypewriterBufferToggle)
		end)
	end)

	describe("enable", function()
		it("should enable typewriter globally", function()
			assert.equals(false, typewriter.is_enabled())
			typewriter.enable()
			assert.equals(true, typewriter.is_enabled())
		end)

		it("should enable typewriter for buffer when buffer option is true", function()
			local bufnr = vim.api.nvim_get_current_buf()
			assert.equals(false, typewriter.is_enabled())
			typewriter.enable({ buffer = true })
			assert.equals(true, typewriter.is_enabled())
			local ok, enabled = pcall(vim.api.nvim_buf_get_var, bufnr, "typewriter_enabled")
			assert.equals(true, ok)
			assert.equals(true, enabled)
		end)
	end)

	describe("disable", function()
		it("should disable typewriter globally", function()
			typewriter.enable()
			assert.equals(true, typewriter.is_enabled())
			typewriter.disable()
			assert.equals(false, typewriter.is_enabled())
		end)

		it("should disable typewriter for buffer when buffer option is true", function()
			local bufnr = vim.api.nvim_get_current_buf()
			typewriter.enable({ buffer = true })
			assert.equals(true, typewriter.is_enabled())
			typewriter.disable({ buffer = true })
			assert.equals(false, typewriter.is_enabled())
			local ok, enabled = pcall(vim.api.nvim_buf_get_var, bufnr, "typewriter_enabled")
			assert.equals(true, ok)
			assert.equals(false, enabled)
		end)
	end)

	describe("toggle", function()
		it("should toggle typewriter from disabled to enabled", function()
			assert.equals(false, typewriter.is_enabled())
			typewriter.toggle()
			assert.equals(true, typewriter.is_enabled())
		end)

		it("should toggle typewriter from enabled to disabled", function()
			typewriter.enable()
			assert.equals(true, typewriter.is_enabled())
			typewriter.toggle()
			assert.equals(false, typewriter.is_enabled())
		end)

		it("should toggle buffer-local typewriter", function()
			assert.equals(false, typewriter.is_enabled())
			typewriter.toggle({ buffer = true })
			assert.equals(true, typewriter.is_enabled())
			typewriter.toggle({ buffer = true })
			assert.equals(false, typewriter.is_enabled())
		end)
	end)

	describe("is_enabled", function()
		it("should return false by default", function()
			assert.equals(false, typewriter.is_enabled())
		end)

		it("should return true after enable", function()
			typewriter.enable()
			assert.equals(true, typewriter.is_enabled())
		end)

		it("should respect buffer-local settings over global", function()
			typewriter.enable()
			assert.equals(true, typewriter.is_enabled())
			typewriter.disable({ buffer = true })
			assert.equals(false, typewriter.is_enabled())
		end)
	end)

	describe("get_config", function()
		it("should return a copy of config, not the original", function()
			typewriter.setup({ enabled = true })
			local config1 = typewriter.get_config()
			local config2 = typewriter.get_config()
			assert.is_not.equal(config1, config2)
			config1.enabled = false
			local config3 = typewriter.get_config()
			assert.equals(true, config3.enabled)
		end)
	end)
end)
