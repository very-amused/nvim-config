" Reload vimrc
command Vimrc source ~/.config/nvim/init.vim
command EditVimrc edit ~/.config/nvim/init.vim

" Plugins
call plug#begin(stdpath('data') . '/plugged')

" Color theme
Plug 'navarasu/onedark.nvim'
" Statusline
Plug 'nvim-lualine/lualine.nvim'
" File manager
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 's1n7ax/nvim-window-picker'
Plug 'nvim-neo-tree/neo-tree.nvim'
" Syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Terminal
"Plug 'akinsho/toggleterm.nvim'
" Completion/snippets
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Git integration
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'

call plug#end()

lua << END

-- Disable syntax highlighting (nvim-treesitter is used)
vim.opt.syntax = 'off'

-- Map helper fn
local function map(mode, lhs, rhs, opts)
	local default_opts = { noremap = true, silent = true }
	opts = opts or default_opts
	vim.keymap.set(mode, lhs, rhs, opts)
end
local function nmap(lhs, rhs, opts)
	map('n', lhs, rhs, opts)
end

-- Clear highlight when escape is pressed
nmap('<esc>', '<Cmd>noh<CR><esc>')

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- Basic window opts
vim.opt.title = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.opt.updatetime = 100

vim.opt.equalalways = false
vim.opt.hidden = true

-- Buffer navigation
vim.opt.splitbelow = true
nmap('<M-h>', '<C-w>h')
nmap('<M-j>', '<C-w>j')
nmap('<M-k>', '<C-w>k')
nmap('<M-l>', '<C-w>l')
-- Creating splits
nmap('<M-H>', '<Cmd>abo vnew<CR>')
nmap('<M-J>', '<Cmd>bel new<CR>')
nmap('<M-K>', '<Cmd>abo new<CR>')
nmap('<M-L>', '<Cmd>bel vnew<CR>')

-- Terminal
nmap('<C-x>', '<Cmd>15new +terminal<CR>')
--map('t', '<esc>', '<C-\\><C-n>') -- Escape switches to normal mode in terminals
map('t', '<M-h>', '<C-\\><C-n><C-w>h')
map('t', '<M-j>', '<C-\\><C-n><C-w>j')
map('t', '<M-k>', '<C-\\><C-n><C-w>k')
map('t', '<M-l>', '<C-\\><C-n><C-w>l')
-- Close window
nmap('<M-w>', '<Cmd>q<CR>')
-- Delete buffer
nmap('<M-W>', '<Cmd>bdelete<CR>')

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

-- FZF
nmap('<C-_>', '<Cmd>Files<CR>')
nmap('<C-.>', '<Cmd>Rg<CR>')

-- Window picker
require'window-picker'.setup {
	hint = 'floating-big-letter',
}

-- Neotree
require'neo-tree'.setup {
	window = {
		width = 30,
		mappings = {
			-- Search
			["/"] = "none",
			["?"] = "none",
			["#"] = "show_help",
			["<esc>"] = function(state)
				vim.cmd("noh")
			end,
			-- Copy/paste
			["d"] = "none",
			["D"] = "none",
			["dd"] = "cut_to_clipboard",
			["dD"] = "delete",
			["y"] = "none",
			["yy"] = "copy_to_clipboard",
			-- Splits/tabs
			["s"] = "vsplit_with_window_picker",
			["S"] = "split_with_window_picker",
			-- Source selector
			["n"] = "prev_source",
			["m"] = "next_source",
			-- Directory expansion
			["Z"] = "expand_all_nodes"
		}
	},
	filesystem = {
		filtered_items ={
			hide_gitignored = false,
			hide_dotfiles = false,
			hide_by_name = {
				".git",
				".github",
				"node_modules"
			}
		}
	},
	source_selector = {
		winbar = true,
		sources = {
			{ source = "filesystem", display_name = "Files"},
			{ source = "git_status", display_name = "Git"},
			{ source = "buffers", display_name = "Buffers"}
		}
	},
	event_handlers = {
		{
			event = "neo_tree_buffer_enter",
			handler = function(arg)
				vim.cmd[[setlocal relativenumber ]]
			end
		}
	}
}
nmap('<C-n>', '<Cmd>Neotree toggle action=show<CR>')

-- Gitsigns
require'gitsigns'.setup()

-- Autocomplete
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
local coc_map_opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
map("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', coc_map_opts)
map("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], coc_map_opts)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
map("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], coc_map_opts)

-- Use K to show documentation in preview window
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
nmap("K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap("<M-,>", "<Plug>(coc-diagnostic-prev)", {silent = true})
nmap("<M-.>", "<Plug>(coc-diagnostic-next)", {silent = true})

-- GoTo code navigation
nmap("gd", "<Plug>(coc-definition)", {silent = true})
nmap("gy", "<Plug>(coc-type-definition)", {silent = true})
nmap("gi", "<Plug>(coc-implementation)", {silent = true})
nmap("gr", "<Plug>(coc-references)", {silent = true})

-- Symbol renaming
nmap('<F2>', '<Plug>(coc-rename)', {silent = true})
END


lua << END
-- Don't load onedark in ttys
if not (os.getenv('TERM') == 'linux') then
	-- Onedark theme config
	require'onedark'.setup {
		style = 'deep'
	}
	require'onedark'.load()
end

-- Treesitter config
require'nvim-treesitter.configs'.setup {
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
		'yaml'},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = {"python"}
	}
}

-- Neotree config

-- coc.nvim config
-- Some LSP servers have issues with backup files
vim.opt.backup = false
vim.opt.writebackup = false

-- Always show the sign column to avoid text shifts
vim.opt.signcolumn = 'yes'


END

" nvim-tree save autocmds
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

" Terminal autocmds
autocmd TermOpen * setlocal nonu | setlocal norelativenumber | startinsert
autocmd BufEnter term://* startinsert

" Statusline
lua << END
vim.opt.showmode = false -- Mode info is contained in statusline
require'lualine'.setup {
	options = {
		theme = 'onedark',
		section_separators = '',
		component_separators = '',
		globalstatus = true
	},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'filename'},
		lualine_c = {'branch', 'diff'},
		lualine_x = {'g:coc_status', 'filetype'},
		lualine_y = {'location'},
		lualine_z = {'progress'}
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
		'neo-tree',
		'toggleterm'
	}
}
END

" Config file highlighting types
autocmd BufEnter mopidy/*.conf set filetype=dosini
autocmd BufEnter mpv/mpv.conf set filetype=dosini
autocmd BufEnter my_timers/*.conf set filetype=sql
