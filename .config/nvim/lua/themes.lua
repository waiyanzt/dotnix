
return {
--   -- Rose Pine
--   {
--     "rose-pine/neovim",
--     name = "rose-pine",
--     priority = 1000,
--     config = function()
--       vim.cmd("colorscheme rose-pine-moon")
--     end
--       },
--
  -- Zenbones (Commented out as in your original)
  -- {
  --   "mcchrish/zenbones.nvim",
  --   dependencies = { "rktjmp/lush.nvim" },
  --   priority=1000,
  --   config = function()
  --     vim.g.zenbones_darken_comments = 50
  --     vim.g.zenbones_dark_mode = true
  --     vim.cmd.colorscheme("kanagawabones")
  --   end,
  -- },

  -- Gruvbox (Disabled auto-load so it doesn't conflict)
  -- {
      -- "ellisonleao/gruvbox.nvim",
      -- priority = 1000, -- Lowered priority/commented out
      -- config = function()
      --     vim.cmd.colorscheme("gruvbox")
      -- end,
  -- },

  -- Catppuccin
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   opts = {
  --     flavour = "mocha",
  --   },
  -- },

  -- -- BlackMetal
  -- {
  --   "metalelf0/black-metal-theme-neovim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("black-metal").setup({
  --       theme = "darkthrone",
  --     })
  --     require("black-metal").load()
  --   end,
  -- },
  -- {
  --   "hachy/eva01.vim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme "eva01"
  --     -- or
  --     -- vim.cmd.colorscheme "eva01-LCL"
  --   end,
  -- }
   { "savq/melange-nvim" }
}
