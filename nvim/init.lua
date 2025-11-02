-- Set basic options
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.tabstop = 4 -- Tab width
vim.opt.shiftwidth = 2 -- Indent width
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.smartindent = true -- Auto indent new lines
vim.opt.wrap = true -- Don't wrap lines
vim.opt.swapfile = false -- Don't create swap files
vim.opt.backup = false -- Don't create backup files
vim.opt.hlsearch = true -- Don't highlight searches
vim.opt.incsearch = true -- Show search matches as you type
vim.opt.termguicolors = true -- True color support
vim.opt.scrolloff = 8 -- Keep 8 lines above/below cursor
vim.opt.signcolumn = "yes" -- Always show sign column
vim.opt.clipboard = "unnamedplus"

-- Set leader key
vim.g.mapleader = " " -- Space as leader key

-- Basic keymaps
vim.keymap.set("n", "<leader>w", ":w<CR>") -- Save with space+w
vim.keymap.set("n", "<leader>q", ":q<CR>") -- Quit with space+q
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>") -- Clear search highlights
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- Keep cursor in middle when jumping
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- Keep cursor in middle when jumping

-- Lazy.nvim setup (aligned with https://github.com/folke/lazy.nvim requirements)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Plugin management with Lazy.nvim
require("lazy").setup({
	-- Essential plugins
	"nvim-lua/plenary.nvim", -- Required by many plugins
	"brenoprata10/nvim-highlight-colors",
	-- Fuzzy finder and file navigation
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({})
			vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
			vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
			vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
			vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")
		end,
	},
	"nvim-telescope/telescope-file-browser.nvim",

	-- File tree
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup()
			vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
		end,
	},

	-- Syntax highlighting and parsing
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"vim",
					"javascript",
					"typescript",
					"python",
					"go",
					"svelte",
					"html",
					"css",
					"json",
				},
				highlight = {
					enable = true,
				},
			})
		end,
	},
	"nvim-treesitter/nvim-treesitter-context",

	-- LSP and autocompletion
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Setup language servers for Svelte, Go, Python, React (TypeScript/JavaScript), and TypeScript
			vim.lsp.config.pyright = { capabilities = capabilities } -- Python
			vim.lsp.config.gopls = { capabilities = capabilities } -- Go
			vim.lsp.config.ts_ls = { capabilities = capabilities } -- TypeScript/JavaScript (React)
			vim.lsp.config.svelte = { capabilities = capabilities } -- Svelte
			vim.lsp.config.html = { capabilities = capabilities } -- HTML (for React/Svelte)
			vim.lsp.config.cssls = { capabilities = capabilities } -- CSS (for React/Svelte)

			-- Enable the language servers
			vim.lsp.enable("pyright")
			vim.lsp.enable("gopls")
			vim.lsp.enable("ts_ls")
			vim.lsp.enable("svelte")
			vim.lsp.enable("html")
			vim.lsp.enable("cssls")

			-- Completion setup
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},

	-- Git integration
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
	"tpope/vim-fugitive",

	-- Quality of life improvements
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}
			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#BF616A" })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#EBCB8B" })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#88C0D0" })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D08770" })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#A3BE8C" })
				vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#B48EAD" })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#8FBCBB" })
			end)
			require("ibl").setup({
				indent = { char = "▏" },
				scope = {
					enabled = true,
					show_start = true,
					show_end = false,
					highlight = highlight,
				},
			})
		end,
	},
	{
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({})
		end,
	},

	-- Status line and visual improvements
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "kyazdani42/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "nord",
					icons_enabled = true,
					component_separators = { left = "|", right = "|" },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},
	{
		"akinsho/bufferline.nvim",
		config = function()
			require("bufferline").setup({
				options = {
					diagnostics = "nvim_lsp",
					offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "center" } },
				},
			})
		end,
	},

	-- Theme (Nord)
	{
		"shaunsingh/nord.nvim",
		config = function()
			vim.g.nord_contrast = true
			vim.g.nord_borders = false
			vim.g.nord_disable_background = true
			vim.g.nord_italic = false
			vim.g.nord_uniform_diff_background = true
			require("nord").set()
		end,
	},

	-- Formatting
	{
		"mhartington/formatter.nvim",
		config = function()
			require("formatter").setup({
				filetype = {
					lua = {
						function()
							return {
								exe = "stylua",
								args = {
									"--search-parent-directories",
									"--stdin-filepath",
									vim.api.nvim_buf_get_name(0),
									"--",
									"-",
								},
								stdin = true,
							}
						end,
					},
					javascript = {
						function()
							return {
								exe = "prettier",
								args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
								stdin = true,
							}
						end,
					},
					typescript = {
						function()
							return {
								exe = "prettier",
								args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
								stdin = true,
							}
						end,
					},
					svelte = {
						function()
							return {
								exe = "prettier",
								args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
								stdin = true,
							}
						end,
					},
					python = {
						function()
							return {
								exe = "black",
								args = { "-" },
								stdin = true,
							}
						end,
					},
					go = {
						function()
							return {
								exe = "gofmt",
								args = { "-w" },
								stdin = false,
							}
						end,
					},
				},
			})
		end,
	},
	{ "jose-elias-alvarez/null-ls.nvim" },
})
-- Ensure termguicolors is enabled if not already
vim.opt.termguicolors = true

require("nvim-highlight-colors").setup({})

-- Make background transparent (100% transparency)
vim.api.nvim_set_hl(0, "Normal", { bg = "none", ctermbg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none", ctermbg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none", ctermbg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none", ctermbg = "none" })
vim.api.nvim_set_hl(0, "MsgArea", { bg = "none", ctermbg = "none" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none", ctermbg = "none" })
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none", ctermbg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none", ctermbg = "none" })
vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none", ctermbg = "none" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "none", ctermbg = "none" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none", ctermbg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none", ctermbg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none", ctermbg = "none" })
vim.api.nvim_set_hl(0, "VertSplit", { bg = "none", ctermbg = "none" })

-- Window management keymaps
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split Vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split Horizontally" })
vim.keymap.set("n", "<leader>sx", "<C-w>q", { desc = "Close Current Window" })
vim.keymap.set("n", "<leader>so", "<C-w>o", { desc = "Close Other Windows" })

-- Focus navigation keymaps
vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Focus Left Window" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Focus Down Window" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Focus Up Window" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Focus Right Window" })

-- Resize window keymaps
vim.keymap.set("n", "<leader>w+", ":resize +5<CR>", { desc = "Increase Height" })
vim.keymap.set("n", "<leader>w-", ":resize -5<CR>", { desc = "Decrease Height" })
vim.keymap.set("n", "<leader>w>", ":vertical resize +5<CR>", { desc = "Increase Width" })
vim.keymap.set("n", "<leader>w<", ":vertical resize -5<CR>", { desc = "Decrease Width" })
vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "Equalize Window Sizes" })

-- Format on save
vim.api.nvim_exec(
	[[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost * FormatWrite
augroup END
]],
	true
)

-- LSP Format on save
vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])
