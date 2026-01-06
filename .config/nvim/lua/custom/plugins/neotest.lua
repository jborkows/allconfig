return {
  {
    'nvim-neotest/neotest',
    init = function()
      local neotest_ns = vim.api.nvim_create_namespace 'neotest'
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
            return message
          end,
        },
      }, neotest_ns)

      local root_dir = vim.fs.root(0, { '.git', 'go.mod', 'mix.exs' }) or vim.fn.getcwd()

      require('neotest').setup {
        adapters = {
          require 'neotest-go' {
            recursive_run = true,
          },
        },
      }

      local function run_all()
        print 'Running tests...'
        require('neotest').run.run { root_dir, extra_args = { '-race', '--coverprofile=coverage.out' } }
      end
      vim.api.nvim_create_user_command('RunTests', run_all, {})
      local function inFile()
        require('neotest').run.run(vim.fn.expand '%')
      end
      vim.api.nvim_create_user_command('RunFileTests', inFile, {})
      local function show()
        require('neotest').output.open { enter = true }
      end
      vim.api.nvim_create_user_command('ShowTestOutputt', show, {})

      local function runSingle()
        require('neotest').run.run()
      end
      vim.api.nvim_create_user_command('TestSingle', runSingle, {})
    end,
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-go',
    },
  },
}
