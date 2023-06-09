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
-- Disable syntax highlighting (nvim-treesitter is used)
vim.opt.syntax = 'off'

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

-- Plugins
require 'paq' {
	'savq/paq-nvim',
	-- Color theme
	'navarasu/onedark.nvim',
	-- Statusline
	'nvim-lualine/lualine.nvim',
	-- File manager
	'nvim-tree/nvim-web-devicons',
	'nvim-tree/nvim-tree.lua',
	-- Syntax highlighting
	{ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },
	-- Fuzzy finder
	{ 'ibhagwan/fzf-lua',                branch = 'main' },
	-- Completion/snippets
	{ 'neoclide/coc.nvim',               branch = 'release' },
	-- Git integration
	'lewis6991/gitsigns.nvim',
	'tpope/vim-fugitive'
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
-- Creating splits
nmap('<M-H>', '<Cmd>abo vnew<CR>')
nmap('<M-J>', '<Cmd>bel new<CR>')
nmap('<M-K>', '<Cmd>abo new<CR>')
nmap('<M-L>', '<Cmd>bel vnew<CR>')

-- Terminal handling
nmap('<C-x>', '<Cmd>15new +terminal<CR>')
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
-- Close window
nmap('<M-w>', '<Cmd>q<CR>')
-- Delete buffer
nmap('<M-W>', '<Cmd>%bd<CR>')

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
-- Close tabs
nmap('<M-c>', '<Cmd>tabclose<CR>')

-- Begin plugin configs

-- Don't load onedark in ttys
if not (os.getenv('TERM') == 'linux') then
	-- Onedark theme config
	require 'onedark'.setup {
		style = 'deep'
	}
	require 'onedark'.load()
end

-- Statusline
vim.opt.showmode = false -- Mode info is contained in statusline
require 'lualine'.setup {
	options = {
		theme = 'onedark',
		section_separators = '',
		component_separators = '',
		globalstatus = true
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'filename' },
		lualine_c = { 'branch', 'diff' },
		lualine_x = { 'g:coc_status', 'filetype' },
		lualine_y = { 'location' },
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

-- nvim-tree
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
	require 'nvim-tree.api'.tree.open()
end
vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })

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
	nmap('cw', api.fs.rename, opts('Rename'))
	nmap('<M-,>', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
	nmap('<M-.>', api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
	nmap('s', api.node.open.horizontal, opts('Open: Horizontal Split'))
	nmap('v', api.node.open.vertical, opts('Open: Vertical Split'))
	nmap('t', api.node.open.tab, opts('Open: New Tab'))
end

require 'nvim-tree'.setup {
	hijack_netrw = false,
	update_focused_file = {
		enable = true
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
			git_placement = "after",
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
		custom = { '.git' }
	},
	on_attach = nvim_tree_on_attach
}

nmap('<C-n>', '<Cmd>NvimTreeToggle<CR>')

-- Treesitter config
require 'nvim-treesitter.configs'.setup {
	ensure_installed = {
		'bash', 'bibtex',
		'c', 'comment', 'cpp', 'css',
		'go', 'gomod',
		'html', 'http',
		'java', 'javascript', 'jsdoc', 'json',
		'latex', 'lua',
		'make',
		'python',
		'regex', 'rust',
		'scss', 'sql',
		'toml', 'typescript',
		'vim',
		'yaml' },
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "python" }
	}
}

-- FZF
vim.g.mapleader = " "
nmap('<leader>/', '<Cmd>FzfLua files<CR>')
nmap('<leader>?', '<Cmd>FzfLua grep_project<CR>')

-- coc.nvim
nmap('<M-n>', '<Cmd>CocDisable<CR>')
nmap('<M-N>', '<Cmd>CocEnable<CR>')
function _G.check_back_space()
	local col = vim.fn.col('.') - 1
	return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use Tab for trigger completion with characters ahead and navigate
-- NOTE: There's always a completion item selected by default, you may want to enable
-- no select by setting `"suggest.noselect": true` in your configuration file
-- NOTE: Use command ':verbose imap <tab>' to make sure Tab is not mapped by
-- other plugins before putting this into your config
local coc_map_opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
map("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
	coc_map_opts)
map("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], coc_map_opts)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
map("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], coc_map_opts)

-- Use K to show documentation in preview window
function _G.show_docs()
	local cw = vim.fn.expand('<cword>')
	if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
		vim.api.nvim_command('h ' .. cw)
	elseif vim.api.nvim_eval('coc#rpc#ready()') then
		vim.fn.CocActionAsync('doHover')
	else
		vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
	end
end

nmap("K", '<CMD>lua _G.show_docs()<CR>', { silent = true })

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap("<M-,>", "<Plug>(coc-diagnostic-prev)", { silent = true })
nmap("<M-.>", "<Plug>(coc-diagnostic-next)", { silent = true })

-- GoTo code navigation
nmap("gd", "<Plug>(coc-definition)", { silent = true })
nmap("gy", "<Plug>(coc-type-definition)", { silent = true })
nmap("gi", "<Plug>(coc-implementation)", { silent = true })
nmap("gr", "<Plug>(coc-references)", { silent = true })

-- Symbol renaming
nmap('<F2>', '<Plug>(coc-rename)', { silent = true })



-- Some LSP servers have issues with backup files
vim.opt.backup = false
vim.opt.writebackup = false

-- Always show the sign column to avoid text shifts
vim.opt.signcolumn = 'yes'

-- Organize go imports on save
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
	pattern = { '*.go' },
	callback = function() vim.fn.CocAction('runCommand', 'editor.action.organizeImport') end
})

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
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
	pattern = 'mopidy/*.conf',
	command = 'set filetype=dosini'
})
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
	pattern = 'mpv/mpv.conf',
	command = 'set filetype=dosini'
})
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
	pattern = 'my_timers/*.conf',
	command = 'set filetype=sql'
})
