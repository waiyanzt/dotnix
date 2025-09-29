return {
  -- Rose Pine
  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {},
  },

  -- Zenbones
  -- {
  --   "mcchrish/zenbones.nvim",
  --   dependencies = { "rktjmp/lush.nvim" },
  --   priority=1000,
  --   config = function()
  --     vim.g.zenbones_darken_comments = 50
  --     vim.g.zenbones_dark_mode = true -- Dark version
  --     vim.cmd.colorscheme("kanagawabones")
  --   end,
  -- },

  -- Eva-01
  -- {
  --   "hachy/eva01.vim",
  --   opts = {},
  --     -- or
  --     -- vim.cmd.colorscheme "eva01-LCL"
  
	-- Gruvbox

	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("gruvbox")
		end,
	},
  -- Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha", -- mocha is the dark variant
    },
  },
}
