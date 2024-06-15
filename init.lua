-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- Basic window opts
vim.opt.title = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.opt.updatetime = 100

vim.opt.equalalways = false
vim.opt.hidden = true
vim.opt.splitbelow = true
vim.opt.syntax = 'on'

vim.g.mapleader = " "

-- Helper fns
local function map(mode, lhs, rhs, opts)
	local default_opts = { noremap = true, silent = true }
	opts = opts or default_opts
	vim.keymap.set(mode, lhs, rhs, opts)
end
local function nmap(lhs, rhs, opts)
	map('n', lhs, rhs, opts)
end
local function command(name, cmd)
	vim.api.nvim_create_user_command(name, cmd, {})
end
local function cabbrev(lhs, rhs)
	-- This API isn't ready yet, so we use vim.cmd for now
	--vim.keymap.set('ca', name, cmd, { noremap = true, silent = true })
	vim.cmd(table.concat({'cnoreabbrev', lhs, rhs}, ' '))
end


-- Plugins
require 'paq' {
	'savq/paq-nvim',
	-- Color theme
	'navarasu/onedark.nvim',
	'folke/tokyonight.nvim',
	-- Statusline
	'nvim-lualine/lualine.nvim',
	-- File manager
	'nvim-tree/nvim-web-devicons',
	'nvim-tree/nvim-tree.lua',
	'ptzz/lf.vim',
	'voldikss/vim-floaterm',
	-- Git integration
	'folke/trouble.nvim',
	-- Syntax highlighting
	{ 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
	'VebbNix/lf-vim',
	-- Fuzzy finder
	{ 'ibhagwan/fzf-lua',                branch = 'main' },
	-- LSP integration
	'neovim/nvim-lspconfig',
	-- Completion
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-cmdline',
	'hrsh7th/nvim-cmp',
	'windwp/nvim-autopairs',
	-- Snippets
	'saadparwaiz1/cmp_luasnip',
	'rafamadriz/friendly-snippets',
	{ 'L3MON4D3/LuaSnip', build = 'make install_jsregexp'},
	-- LSP lualine component
	'nvim-lua/lsp-status.nvim',
	-- LSP Symbols
	'simrat39/symbols-outline.nvim',
	-- Git integration
	'lewis6991/gitsigns.nvim',
	'tpope/vim-fugitive',
	-- Enhanced LaTeX support
	'lervag/vimtex',
	'iurimateus/luasnip-latex-snippets.nvim',
	'kdheepak/cmp-latex-symbols',
	-- Misc.
	'eandrju/cellular-automaton.nvim'
}

-- Manage init.lua
command('Vimrc', 'source ~/.config/nvim/init.lua')
command('EditVimrc', 'edit ~/.config/nvim/init.lua')

-- Clear highlight when escape is pressed
nmap('<esc>', '<Cmd>noh<CR><esc>')

-- Buffer navigation
nmap('<M-h>', '<C-w>h')
nmap('<M-j>', '<C-w>j')
nmap('<M-k>', '<C-w>k')
nmap('<M-l>', '<C-w>l')
nmap('<M-r>', '<C-w>r')
cabbrev('vrs', 'vert resize')
nmap('<M-f>', '<C-f>')
nmap('<M-b>', '<C-b>')
-- Creating splits
nmap('<M-H>', '<Cmd>abo vnew<CR>')
nmap('<M-J>', '<Cmd>bel new<CR>')
nmap('<M-K>', '<Cmd>abo new<CR>')
nmap('<M-L>', '<Cmd>bel vnew<CR>')

-- Tab navigation
nmap('<M-[>', '<Cmd>tabprevious<CR>')
nmap('<M-]>', '<Cmd>tabnext<CR>')
nmap('<M-1>', '<Cmd>1tabnext<CR>')
nmap('<M-2>', '<Cmd>2tabnext<CR>')
nmap('<M-3>', '<Cmd>3tabnext<CR>')
nmap('<M-4>', '<Cmd>4tabnext<CR>')
nmap('<M-5>', '<Cmd>5tabnext<CR>')
nmap('<M-6>', '<Cmd>6tabnext<CR>')
nmap('<M-7>', '<Cmd>7tabnext<CR>')
nmap('<M-8>', '<Cmd>8tabnext<CR>')
nmap('<M-9>', '<Cmd>9tabnext<CR>')
-- Move tabs
nmap('<M-{>', '<Cmd>-tabmove<CR>')
nmap('<M-}>', '<Cmd>+tabmove<CR>')
-- Creating tabs
nmap('<C-t>', function()
	local pos = vim.api.nvim_win_get_cursor(0)
	vim.cmd('tabnew %')
	vim.api.nvim_win_set_cursor(0, pos)
end)
-- Close tabs
nmap('<M-c>', '<Cmd>tabclose<CR>')

-- Saving and Exiting
nmap('<C-s>', '<Cmd>w<CR>')
nmap('<C-z>', '<Cmd>q<CR>')
nmap('<M-w>', '<Cmd>q<CR>')

-- Terminal handling
local term_vsize = 15
local term_vsize_large = 30
local newterm_template = '<Cmd>%dnew +terminal<CR>'
nmap('<C-x>', string.format(newterm_template, term_vsize))
nmap('<C-c>', '<Cmd>term<CR>')
-- If a terminal's height ever gets changed by moving around other windows,
-- it can easily be reset with C-x/C-X when in terminal mode
local resizeterm_template = '<C-\\><C-n><Cmd>resize %d<CR>'
map('t', '<C-x>', string.format(resizeterm_template, term_vsize))
-- Can't do the same for <C-c>  B) for obvious reasons
vim.api.nvim_create_autocmd({ 'TermOpen' }, {
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
		vim.opt.winfixheight = true
		vim.cmd('startinsert')
	end
})
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
	pattern = { 'term://*' },
	command = 'startinsert'
})

-- Automatically switch to normal mode to move out of terminals
map('t', '<M-h>', '<C-\\><C-n><C-w>h')
map('t', '<M-j>', '<C-\\><C-n><C-w>j')
map('t', '<M-k>', '<C-\\><C-n><C-w>k')
map('t', '<M-l>', '<C-\\><C-n><C-w>l')
-- Close terminal (TODO: show confirmation prompt when a process is running)
map('t', '<C-n>', '<C-\\><C-n>')
-- Delete buffer
nmap('<M-W>', '<Cmd>%bd<CR>')


-- Editing mappings
nmap('cw', 'ciw')

-- Begin plugin configs

-- lspconfig
local lspconfig = require 'lspconfig'
local lsp_status = require 'lsp-status'
lsp_status.register_progress()
lsp_status.config {
	status_symbol = ''
}

-- Credit to https://github.com/leonasdev,
-- this function is based on his work @ https://github.com/neovim/nvim-lspconfig/issues/115#issuecomment-1801096383
local function gopls_organize_imports(buf, preflight)
	local offset_encoding = vim.lsp.util._get_offset_encoding(buf)
	local params = vim.lsp.util.make_range_params(nil, offset_encoding)
	params.context = { only = { 'source.organizeImports' } }

	-- Async preflight request to create import cache
	if preflight then
		vim.lsp.buf_request(buf, 'textDocument/codeAction', params, function() end)
		return
	end

	-- Request done on save, 1s timeout
	local results = vim.lsp.buf_request_sync(buf, 'textDocument/codeAction', params, 1000)
	for _, r in pairs(results or {}) do
		for _, body in pairs(r.result or {}) do
			if body.edit then
				vim.lsp.util.apply_workspace_edit(body.edit, offset_encoding)
			else
				vim.lsp.buf.execute_command(body.command)
			end
		end
	end
end


local lspconfig_langs = {
	{
		name = 'gopls',
		opts = {
			on_attach = function(client, buf)
				-- Support lsp_status
				lsp_status.on_attach(client)
				-- Preflight source.organizeImports request to create import cache
				gopls_organize_imports(buf, true)
			end
		}
	},
	{ name = 'bashls', status = false },
	{
		name = 'rust_analyzer',
		opts = {
			on_attach = function(client, buf)
				-- Support lsp_status
				lsp_status.on_attach(client)
				-- Enable inlay hints
				vim.lsp.inlay_hint.enable(true)
			end
		}
	},
	{
		name = 'clangd',
		opts = {
			cmd = { 'clangd', '--clang-tidy' }
		}
	},
	'pylsp',
	'tsserver',
	'eslint',
	{
		name = 'html',
		status = true,
		-- Enable snippet support with LuaSnip
		before_setup = function(opts)
			if opts.capabilities == nil then
				opts.capabilities = vim.lsp.protocol.make_client_capabilities()
			end

			local td = opts.capabilities.textDocument
			if td.completionItem == nil then
				td.completionItem = {}
			end
			td.completionItem.snippetSupport = true
		end
	},
	{
		name = 'emmet_language_server',
		opts = {
			filetypes = { 'html', 'css', 'less', 'sass', 'scss', 'svelte' }
		}
	},
	'texlab'
}

for _, lang in ipairs(lspconfig_langs) do
	if type(lang) == 'string' then
		lspconfig[lang].setup {
			on_attach = lsp_status.on_attach,
			capabilities = lsp_status.capabilities
		}
	else
		local opts = (lang.opts ~= nil) and lang.opts or {}
		if lang.status then
			opts.on_attach = (opts.on_attach ~= nil) and opts.on_attach or lsp_status.on_attach
			opts.capabilities = lsp_status.capabilities
		end
		if lang.before_setup then
			lang.before_setup(opts)
		end
		lspconfig[lang.name].setup(opts)
	end
end

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		local opts = { buffer = ev.buf, silent = true }
		-- Hover
		nmap('K', vim.lsp.buf.hover, opts)

		-- Code navigation
		nmap('gd', vim.lsp.buf.definition, opts)
		nmap('gD', vim.lsp.buf.declaration, opts)
		nmap('gy', vim.lsp.buf.type_definition, opts)
		nmap('gi', vim.lsp.buf.implementation, opts)
		nmap('gr', vim.lsp.buf.references, opts)

		-- Symbol renaming
		nmap('<leader>r', vim.lsp.buf.rename, opts)

		-- Diagnostic navigation
		nmap('<M-,>', vim.diagnostic.goto_prev, opts)
		nmap('<M-.>', vim.diagnostic.goto_next, opts)

		-- Code outline
		nmap('<leader>go', '<Cmd>SymbolsOutline<CR>')

		-- Apply formatting
		nmap('<leader>f', function()
			vim.lsp.buf.format { async = true }
		end)
		-- Apply quickfix
		local function quickfix()
			vim.lsp.buf.code_action {
				filter = function(a) return a.isPreferred end,
				apply = true
			}
		end
		nmap('<leader>qf', quickfix, opts)
	end
})

-- Enable autoformatting for certain langs
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
	pattern = { '*.go' },
	callback = function(args)
		vim.lsp.buf.format { async = false }
		gopls_organize_imports(args.buf)
	end
})
-- Handle trailing whitespace
vim.cmd 'match TrailingWhitespace /\\S\\zs\\s\\+$/'
vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
	callback = function()
		vim.cmd('highlight TrailingWhitespace ctermbg=red guibg=red')
		vim.cmd('highlight CursorLineNR ctermbg=red')
	end
})

-- cmp and autopairs Autocompletion
local cmp = require 'cmp'
local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
local autopairs = require 'nvim-autopairs'
local luasnip = require 'luasnip'
require'luasnip-latex-snippets'.setup{}
require'luasnip.loaders.from_vscode'.lazy_load()
autopairs.setup {}
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
cmp.setup {
	sources = cmp.config.sources {
		{ name = 'nvim_lsp' },
		{ name = 'path' },
		{ name = 'luasnip', option = { show_autosnippets = true } },
		{ name = 'latex_symbols', option = { strategy = 2 } }
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end
	},
	mapping = cmp.mapping.preset.insert {
		['<Tab>'] = cmp.mapping.select_next_item(),
		['<S-Tab>'] = cmp.mapping.select_prev_item(),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm { select = false }
	}
}

-- symbol outline
require 'symbols-outline'.setup {
	width = 10,
	show_guides = false,
	show_symbol_details = false,
	wrap = true
}


-- Don't load onedark in ttys
if not (os.getenv('TERM') == 'linux') then
	-- Tokyonight theme config
	require'tokyonight'.setup {
		style = 'night',
		transparent = false
	}
	-- Onedark theme config
	require'onedark'.setup {
		style = 'deep',
		transparent = false
	}
	vim.cmd[[colorscheme onedark]]
end

-- Some LSP servers have issues with backup files
vim.opt.backup = false
vim.opt.writebackup = false

-- Always show the sign column to avoid text shifts
vim.opt.signcolumn = 'yes'

-- Lualine
vim.opt.showmode = false -- Mode info is contained in statusline
require 'lualine'.setup {
	options = {
		theme = 'auto',
		section_separators = '',
		component_separators = '',
		globalstatus = true
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'filename' },
		lualine_c = { 'branch', 'diff' },
		lualine_x = { 'require"lsp-status".status()' },
		lualine_y = { 'filetype', 'location' },
		lualine_z = { 'progress' }
	},
	tabline = {
		lualine_a = {
			{
				'tabs',
				mode = 2,
				use_mode_colors = true
			}
		}
	},
	extensions = {
		'fugitive',
		'fzf',
		'man',
		'nvim-tree'
	}
}

-- lf.vim
vim.g['lf_map_keys'] = 0
nmap('<leader>l', '<Cmd>Lf<CR>')

-- nvim-tree
local nvim_tree_api = require'nvim-tree.api'
local function open_nvim_tree(data)
	-- buffer is a directory
	local directory = vim.fn.isdirectory(data.file) == 1

	if not directory then
		return
	end

	-- Create a new, empty buffer
	vim.cmd.enew()
	-- Wipe directory buffer
	vim.cmd.bw(data.buf)
	-- cd to directory
	vim.cmd.cd(data.file)
	-- open nvim-tree
	nvim_tree_api.tree.open()

	-- Unfocus tree window
	vim.cmd[[wincmd p]]
	-- If README.md exists, open it
	-- TODO: support for other README formats
	if vim.fn.filereadable('README.md') then
		vim.cmd[[
		e README.md
		filetype detect
		]]
	end
end
vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })

nmap('<C-n>', '<Cmd>NvimTreeToggle<CR>')

local function close_nvim_tree(data)
	if not nvim_tree_autohide then
		return
	end
	-- buffer is a directory
	local directory = vim.fn.isdirectory(data.file) == 1

	if nvim_tree_autohide and directory
		or not nvim_tree_api.tree.is_visible()
		or nvim_tree_api.tree.is_tree_buf() then
		return
	end

	nvim_tree_api.tree.close_in_this_tab()
end
vim.api.nvim_create_autocmd({ 'BufEnter' }, { callback = close_nvim_tree })


local function nvim_tree_on_attach(bufnr) -- on_attach fn, based on example in :h nvim-tree
	local api = require 'nvim-tree.api'
	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- custom mappings
	nmap('yy', api.fs.copy.node, opts('Copy'))
	nmap('yn', api.fs.copy.filename, opts('Copy Name'))
	nmap('yp', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
	nmap('pp', api.fs.paste, opts('Paste'))
	nmap('dd', api.fs.cut, opts('Cut'))
	nmap('dD', api.fs.remove, opts('Delete'))
	nmap('cw', api.fs.rename_sub, opts('Rename'))
	nmap('cW', api.fs.rename, opts('Rename with Filename'))
	nmap('<M-,>', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
	nmap('<M-.>', api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
	nmap('s', api.node.open.horizontal, opts('Open: Horizontal Split'))
	nmap('v', api.node.open.vertical, opts('Open: Vertical Split'))
	nmap('t', api.node.open.tab, opts('Open: New Tab'))
	-- New terminal command assumes tree is open to the left
	nmap('<C-x>', string.format('<C-w><C-l><Cmd>%dnew +terminal<CR>', term_vsize), opts('Open New Terminal'))
end

require 'nvim-tree'.setup {
	hijack_netrw = false,
	sync_root_with_cwd = false,
	select_prompts = true,
	update_focused_file = {
		enable = true
	},
	actions = {
		use_system_clipboard = true,
		change_dir = {
			enable = true,
			global = true
		}
	},
	tab = {
		sync = {
			open = true,
			close = true
		}
	},
	view = {
		width = 30,
		relativenumber = true
	},
	ui = {
		confirm = {
			remove = false
		}
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		show_on_open_dirs = false
	},
	git = {
		show_on_open_dirs = false,
		ignore = false
	},
	renderer = {
		icons = {
			git_placement = "before",
			padding = " ",
			glyphs = {
				git = {
					unstaged = 'M',
					untracked = 'U',
					deleted = 'D'
				}
			}
		}
	},
	filters = {
		custom = { '^\\.git$' }
	},
	on_attach = nvim_tree_on_attach
}


-- Treesitter config
require 'nvim-treesitter.configs'.setup {
	ensure_installed = {
		'bash', 'bibtex',
		'c', 'comment', 'cpp', 'css',
		'go', 'gomod',
		'html', 'http',
		'java', 'javascript', 'jsdoc', 'json', 'jsonc',
		'lua',
		'make', 'markdown', 'markdown_inline',
		'python',
		'regex', 'rust',
		'scss', 'sql', 'svelte',
		'toml', 'typescript',
		'vim',
		'yaml' },
	highlight = {
		enable = true,
		disable = { 'latex' }
		--additional_vim_regex_highlighting = { "python" }
	}
}

-- FZF
nmap('<leader>/', '<Cmd>FzfLua files<CR>')
nmap('<leader>?', '<Cmd>FzfLua grep_project<CR>')


-- Gitsigns
local function gitsigns_on_attach(bufnr)
	local gs = package.loaded.gitsigns

	local function opts(desc)
		return { desc = "gitsigns: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- Navigate between hunks
	nmap('<M-;>', gs.prev_hunk, opts('Prev Hunk'))
	nmap("<M-'>", gs.next_hunk, opts('Next Hunk'))

	-- Actions
	nmap('<leader>gs', gs.stage_hunk, opts('Stage Hunk'))
	nmap('<leader>gr', gs.reset_hunk, opts('Reset Hunk'))
	map('v', '<leader>gs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, opts('Stage Hunk'))
	map('v', '<leader>gr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, opts('Reset Hunk'))
	nmap('<leader>gu', gs.undo_stage_hunk, opts('Undo Stage Hunk'))
	nmap('<leader>gS', gs.stage_buffer, opts('Stage Buffer'))
	nmap('<leader>gp', gs.preview_hunk, opts('Preview Hunk'))
	nmap('<leader>gd', gs.diffthis, opts('Show Diff'))
	nmap('<leader>gD', function() gs.diffthis('~') end, opts('Show Diff'))
	nmap('<leader>td', gs.toggle_deleted, opts('Toggle Deleted'))
end

require 'gitsigns'.setup {
	on_attach = gitsigns_on_attach
}

-- Custom file highlighting types
filetype_overrides = {
	['*/mopidy/*.conf'] = 'confini',
	['*/my_timers/*.conf'] = 'sql'
}
for _, pattern in ipairs(filetype_overrides) do
	local filetype = filetype_overrides[pattern]
	vim.api.nvim_create_autocmd({ 'BufEnter' }, {
		pattern,
		command = table.concat({'set filetype=', filetype}, ''),
		group = 'filetype_overrides'
	})
end

-- Vimtex

vim.g.vimtex_view_method = 'zathura'

-- cellular-automaton
nmap('<leader>m', '<Cmd>CellularAutomaton make_it_rain<CR>')
