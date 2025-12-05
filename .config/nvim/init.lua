-- Basic Vim settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.laststatus = 3
vim.opt.pumheight = 10
vim.opt.scrolloff = 10
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

-- Leader key
vim.g.mapleader = " "

-- File type specific tab widths
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup("__indentation__", { clear = true })
autocmd("FileType", {
  group = "__indentation__",
  callback = function(opts)
    local override_tabwidth = { cpp = 4, go = 4, c = 4 }
    local filetype = vim.bo[opts.buf].filetype
    if override_tabwidth[filetype] then
      vim.opt_local.tabstop = override_tabwidth[filetype]
      vim.opt_local.shiftwidth = override_tabwidth[filetype]
    end
  end,
})

-- Neovide settings
vim.o.guifont = "CommitMono Nerd Font:h14"
vim.g.neovide_floating_shadow = false
vim.g.neovide_position_animation_length = 0
vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_cursor_trail_size = 0

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  -- Import modular plugin configs
  { import = "themes" },
  { import = "neckpain" }, 
	{ import = "dashboard"},
  
  -- File explorer - Oil.nvim (buffer-based)
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
    },
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    keys = {
      { "<leader>o", ":Oil<CR>", desc = "Open Oil file explorer" },
    },
  },

  -- Fuzzy finder - fzf-lua (fast and stable)
  {
    "ibhagwan/fzf-lua",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      require("fzf-lua").setup({
        winopts = {
          height = 0.85,
          width = 0.80,
          preview = { default = "bat" },
        },
      })
    end,
    keys = {
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Find buffers" },
      { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
      { "<leader>fr", "<cmd>FzfLua lsp_references<cr>", desc = "LSP references" },
    },
  },

  -- LSP and tooling
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {},
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            completion = { callSnippet = "Replace" },
          },
        },
      })
      
          
		   -- Clangd
       lspconfig.clangd.setup({
         cmd = {"clangd", "--background-index", "--clang-tidy"},
       })

       -- rust
       lspconfig.rust_analyzer.setup({
         settings = {
           ["rust-analyzer"] = {
             cargo = { allFeatures = true},
             checkOnSave = { command = "clippy"},
           },
         },
       })
			 
      -- LSP keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>h", ":ClangdSwitchSourceHeader<CR>", opts)
        end,
      })
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        completion = { autocomplete = false },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        formatting = {
          format = require("lspkind").cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          c = { "clang_format" },
          cpp = { "clang_format" },
          rust = { "rustfmt" },
          lua = { "stylua" },
          html = {'prettier'},
          css = {'prettier'},
          typescript = {'prettier'},
          javascript = {'prettier'},
        },
        formatters = {
          clang_format = { command = "/home/ztzy/.nix-profile/bin/clang-format" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
    keys = {
      { "<leader>cf", function() require("conform").format({ lsp_fallback = true }) end, desc = "Format code" },
    },
  },

  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "cpp", "rust", "lua", "vim", "vimdoc" },
        highlight = { enable = true },
        auto_install = true,
      })
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    config = true,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "echasnovski/mini.icons" },
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        component_separators = "",
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
    },
    keys = {
      { "]h", function() require("gitsigns").nav_hunk("next") end, desc = "Next hunk" },
      { "[h", function() require("gitsigns").nav_hunk("prev") end, desc = "Prev hunk" },
      { "<leader>hr", function() require("gitsigns").reset_hunk() end, desc = "Reset hunk" },
      { "<leader>hp", function() require("gitsigns").preview_hunk() end, desc = "Preview hunk" },
    },
  },

  -- Terminal
  {
    "voldikss/vim-floaterm",
    keys = {
      { "<leader>t", ":FloatermToggle<CR>", desc = "Toggle terminal" },
    },
  },

  -- Commenting
  {
    "numToStr/Comment.nvim",
    opts = {},
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- LazyGit integration
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
})

-- Additional keymaps
vim.keymap.set("n", "J", "10j", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>l", ":Lazy home<CR>", { noremap = true })

-- Diagnostics config
vim.diagnostic.config({
  virtual_text = false,
  update_in_insert = true,
})

local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

