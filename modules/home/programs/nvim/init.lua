vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Ensure a writable runtime dir (fixes RPC server socket warnings)
do
	local run_dir = vim.fn.stdpath("run")
	local function can_write(dir)
		if dir == nil or dir == "" or vim.fn.filewritable(dir) ~= 2 then
			return false
		end
		local test = dir .. "/nvim_write_test_" .. tostring(vim.fn.getpid())
		local ok = pcall(vim.fn.writefile, { "1" }, test, "b")
		if ok then
			pcall(vim.fn.delete, test)
		end
		return ok
	end

	if not can_write(run_dir) then
		local fallback = "/tmp/nvim-" .. tostring(vim.fn.getuid())
		vim.fn.mkdir(fallback, "p", "0700")
		vim.env.XDG_RUNTIME_DIR = fallback
	end
end

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"

opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.wrap = false
opt.undofile = true
opt.updatetime = 200
opt.timeoutlen = 400

opt.completeopt = { "menu", "menuone", "noselect" }
opt.showtabline = 2
opt.laststatus = 3

vim.diagnostic.config({
	underline = true,
	virtual_text = true,
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
})

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
	end,
})

local function safe_require(name)
	local ok, mod = pcall(require, name)
	if ok then
		return mod
	end
	return nil
end

local function setup(name, opts)
	local mod = safe_require(name)
	if mod and mod.setup then
		mod.setup(opts or {})
	end
end

-- Colorscheme
pcall(vim.cmd, "colorscheme tokyonight")

-- which-key
setup("which-key", {
	icons = {
		breadcrumb = ">",
		separator = ">",
		group = "+",
	},
})

-- lualine
setup("lualine", {
	options = {
		theme = "tokyonight",
		section_separators = "",
		component_separators = "",
	},
})

-- gitsigns
setup("gitsigns", {
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "-" },
		changedelete = { text = "~" },
	},
})

-- comment
setup("Comment", {})

-- surround
setup("nvim-surround", {})

-- autopairs
local npairs = safe_require("nvim-autopairs")
if npairs then
	npairs.setup({})
end

-- indent-blankline
setup("ibl", { indent = { char = "|" } })

-- oil file explorer
setup("oil", {
	default_file_explorer = true,
	view_options = { show_hidden = true },
})
vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })

-- notify
local notify = safe_require("notify")
if notify then
	notify.setup({})
	vim.notify = notify
end

-- dressing (better UI prompts/select)
setup("dressing", {})

-- bufferline (tabs)
setup("bufferline", {
	options = {
		diagnostics = "nvim_lsp",
		show_buffer_close_icons = false,
		show_close_icon = false,
		separator_style = "slant",
		offsets = {
			{
				filetype = "neo-tree",
				text = "Explorer",
				highlight = "Directory",
				text_align = "left",
			},
		},
	},
})

-- colorizer
setup("colorizer", {})

-- illuminate
local illuminate = safe_require("illuminate")
if illuminate then
	illuminate.configure({ delay = 200 })
end

-- navic + barbecue (breadcrumbs)
local navic = safe_require("nvim-navic")
if navic then
	navic.setup({ highlight = true, separator = " > " })
end
setup("barbecue", {
	show_modified = true,
	create_autocmd = true,
	theme = "tokyonight",
})

-- neo-tree file explorer
setup("neo-tree", {
	close_if_last_window = true,
	popup_border_style = "rounded",
	enable_git_status = true,
	enable_diagnostics = true,
	filesystem = {
		follow_current_file = { enabled = true, leave_dirs_open = false },
		hijack_netrw_behavior = "open_default",
		use_libuv_file_watcher = true,
		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			hide_gitignored = false,
		},
	},
})
vim.keymap.set("n", "<leader>fe", "<cmd>Neotree toggle<cr>", { desc = "Explorer" })

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() == 0 then
			pcall(vim.cmd, "Neotree show")
		end
	end,
})

-- project management
setup("project_nvim", {
	detection_methods = { "lsp", "pattern" },
	patterns = {
		".git",
		"package.json",
		"pyproject.toml",
		"go.mod",
		"Cargo.toml",
		"build.zig",
		"Makefile",
		"flake.nix",
	},
})

-- trouble diagnostics
setup("trouble", { use_diagnostic_signs = true })

-- todo comments
setup("todo-comments", {})

-- search and replace
setup("spectre", {})

-- formatter (LSP fallback)
local conform = safe_require("conform")
if conform then
	conform.setup({
		format_on_save = function()
			return { lsp_fallback = true, timeout_ms = 2000 }
		end,
	})
end

-- outline
setup("aerial", {
	backends = { "lsp", "treesitter", "markdown" },
	layout = { min_width = 28 },
})

-- terminal
setup("toggleterm", {
	size = 14,
	direction = "float",
	shade_terminals = true,
})

-- Jupytext helper
vim.api.nvim_create_user_command("JupytextSync", function()
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		return
	end
	if vim.fn.executable("jupytext") ~= 1 then
		vim.notify("jupytext not found in PATH", vim.log.levels.WARN)
		return
	end
	vim.fn.jobstart({ "jupytext", "--sync", file })
end, {})

-- treesitter
local ts = safe_require("nvim-treesitter.configs")
if ts then
	ts.setup({
		highlight = { enable = true },
		indent = { enable = true },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<c-space>",
				node_incremental = "<c-space>",
				scope_incremental = false,
				node_decremental = "<bs>",
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
		},
	})
end

-- telescope
local telescope = safe_require("telescope")
if telescope then
	telescope.setup({
		defaults = {
			mappings = {
				i = {
					["<c-j>"] = "move_selection_next",
					["<c-k>"] = "move_selection_previous",
				},
			},
		},
	})

	pcall(telescope.load_extension, "fzf")
	pcall(telescope.load_extension, "ui-select")
	pcall(telescope.load_extension, "projects")
end

-- completion
local cmp = safe_require("cmp")
local luasnip = safe_require("luasnip")
if cmp and luasnip then
	local loader = safe_require("luasnip.loaders.from_vscode")
	if loader then
		loader.lazy_load()
	end

	local lspkind = safe_require("lspkind")
	local formatting = nil
	if lspkind then
		formatting = {
			format = lspkind.cmp_format({
				mode = "symbol_text",
				maxwidth = 50,
				ellipsis_char = "...",
			}),
		}
	else
		formatting = {
			fields = { "kind", "abbr", "menu" },
		}
	end

	cmp.setup({
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<c-b>"] = cmp.mapping.scroll_docs(-4),
			["<c-f>"] = cmp.mapping.scroll_docs(4),
			["<c-space>"] = cmp.mapping.complete(),
			["<c-e>"] = cmp.mapping.abort(),
			["<cr>"] = cmp.mapping.confirm({ select = true }),
			["<tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<s-tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "buffer" },
			{ name = "path" },
		}),
		formatting = formatting,
	})

	cmp.setup.cmdline("/", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = { { name = "buffer" } },
	})

	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
			{ name = "cmdline" },
		}),
	})
end

local cmp_autopairs = safe_require("nvim-autopairs.completion.cmp")
if cmp and cmp_autopairs then
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

-- LSP (Neovim 0.11+ config API)
if vim.lsp and vim.lsp.config and vim.lsp.enable then
	setup("neodev", {})

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	local cmp_lsp = safe_require("cmp_nvim_lsp")
	if cmp_lsp then
		capabilities = cmp_lsp.default_capabilities(capabilities)
	end

	local function on_attach(client, bufnr)
		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
		end

		map("n", "gd", vim.lsp.buf.definition, "LSP definition")
		map("n", "gD", vim.lsp.buf.declaration, "LSP declaration")
		map("n", "gi", vim.lsp.buf.implementation, "LSP implementation")
		map("n", "gr", vim.lsp.buf.references, "LSP references")
		map("n", "K", vim.lsp.buf.hover, "LSP hover")
		map("n", "<leader>rn", vim.lsp.buf.rename, "LSP rename")
		map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
		map("n", "<leader>fd", function()
			vim.lsp.buf.format({ async = true })
		end, "LSP format")
		map("n", "<leader>e", vim.diagnostic.open_float, "Diagnostics")
		map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
		map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")

		if navic and client.server_capabilities.documentSymbolProvider then
			navic.attach(client, bufnr)
		end

		if vim.lsp.inlay_hint and client.server_capabilities.inlayHintProvider then
			pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
		end
	end

	-- Base config for all servers
	vim.lsp.config("*", {
		on_attach = on_attach,
		capabilities = capabilities,
	})

	-- Server-specific overrides
	vim.lsp.config("lua_ls", {
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
			},
		},
	})

	local servers = {
		"bashls",
		"pyright",
		"ts_ls",
		"gopls",
		"rust_analyzer",
		"zls",
		"clangd",
		"jdtls",
		"omnisharp",
		"phpactor",
		"solargraph",
		"lua_ls",
		"nil_ls",
		"jsonls",
		"yamlls",
		"taplo",
		"dockerls",
	}

	vim.lsp.enable(servers)
end

-- fidget (LSP status)
setup("fidget", {})

-- DAP (debugging)
local dap = safe_require("dap")
if dap then
	local function exepath(cmd)
		local p = vim.fn.exepath(cmd)
		if p == nil then
			return ""
		end
		return p
	end

	-- LLDB for C/C++/Rust
	local lldb = exepath("lldb-vscode")
	if lldb == "" then
		lldb = exepath("lldb-dap")
	end
	if lldb ~= "" then
		dap.adapters.lldb = {
			type = "executable",
			command = lldb,
			name = "lldb",
		}
		dap.configurations.cpp = {
			{
				name = "Launch",
				type = "lldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
			},
		}
		dap.configurations.c = dap.configurations.cpp
		dap.configurations.rust = dap.configurations.cpp
	end

	-- C# (netcoredbg)
	local netcoredbg = exepath("netcoredbg")
	if netcoredbg ~= "" then
		dap.adapters.coreclr = {
			type = "executable",
			command = netcoredbg,
			args = { "--interpreter=vscode" },
		}
		dap.configurations.cs = {
			{
				type = "coreclr",
				name = "Launch",
				request = "launch",
				program = function()
					return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
				end,
			},
		}
	end

	-- JS/TS (vscode-js-debug)
	local js_debug = exepath("js-debug-adapter")
	if js_debug ~= "" then
		dap.adapters["pwa-node"] = {
			type = "server",
			host = "127.0.0.1",
			port = "${port}",
			executable = {
				command = js_debug,
				args = { "${port}" },
			},
		}

		local js_launch = {
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
			sourceMaps = true,
			protocol = "inspector",
		}
		dap.configurations.javascript = { js_launch }
		dap.configurations.typescript = { js_launch }
		dap.configurations.javascriptreact = { js_launch }
		dap.configurations.typescriptreact = { js_launch }
	end
end

setup("nvim-dap-virtual-text", {})

local dapui = safe_require("dapui")
if dapui then
	dapui.setup()
	if dap then
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end
	end
end

local dap_python = safe_require("dap-python")
if dap_python then
	local py = vim.fn.exepath("python3")
	if py ~= "" then
		dap_python.setup(py)
	end
end

local dap_go = safe_require("dap-go")
if dap_go then
	dap_go.setup()
end

-- Keymaps
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help" })
vim.keymap.set("n", "<leader>fp", "<cmd>Telescope projects<cr>", { desc = "Projects" })

vim.keymap.set("n", "<leader>ww", "<cmd>write<cr>", { desc = "Save" })
vim.keymap.set("n", "<leader>qq", "<cmd>quit<cr>", { desc = "Quit" })

vim.keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next tab" })
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev tab" })
vim.keymap.set("n", "<leader>bb", "<cmd>BufferLinePick<cr>", { desc = "Pick tab" })

local function trouble(cmd)
	return function()
		local ok = pcall(vim.cmd, "Trouble " .. cmd)
		if not ok then
			pcall(vim.cmd, "TroubleToggle " .. cmd)
		end
	end
end

vim.keymap.set("n", "<leader>xx", trouble("diagnostics"), { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>xw", trouble("workspace_diagnostics"), { desc = "Workspace diagnostics" })
vim.keymap.set("n", "<leader>xd", trouble("document_diagnostics"), { desc = "Document diagnostics" })
vim.keymap.set("n", "<leader>xl", trouble("loclist"), { desc = "Location list" })
vim.keymap.set("n", "<leader>xq", trouble("quickfix"), { desc = "Quickfix list" })

vim.keymap.set("n", "<leader>sr", "<cmd>Spectre<cr>", { desc = "Search and replace" })
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Terminal" })
vim.keymap.set("n", "<leader>to", "<cmd>TodoTelescope<cr>", { desc = "Todo list" })
vim.keymap.set("n", "<leader>oo", "<cmd>AerialToggle<cr>", { desc = "Outline" })
vim.keymap.set("n", "<leader>nj", "<cmd>JupytextSync<cr>", { desc = "Jupytext sync" })
vim.keymap.set("n", "<leader>cf", function()
	local c = safe_require("conform")
	if c then
		c.format({ lsp_fallback = true, timeout_ms = 2000 })
	else
		vim.lsp.buf.format({ async = true })
	end
end, { desc = "Format" })

-- DAP keymaps
vim.keymap.set("n", "<F5>", function()
	local d = safe_require("dap")
	if d then
		d.continue()
	end
end, { desc = "DAP continue" })
vim.keymap.set("n", "<F10>", function()
	local d = safe_require("dap")
	if d then
		d.step_over()
	end
end, { desc = "DAP step over" })
vim.keymap.set("n", "<F11>", function()
	local d = safe_require("dap")
	if d then
		d.step_into()
	end
end, { desc = "DAP step into" })
vim.keymap.set("n", "<F12>", function()
	local d = safe_require("dap")
	if d then
		d.step_out()
	end
end, { desc = "DAP step out" })
vim.keymap.set("n", "<leader>db", function()
	local d = safe_require("dap")
	if d then
		d.toggle_breakpoint()
	end
end, { desc = "DAP toggle breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
	local d = safe_require("dap")
	if d then
		d.set_breakpoint(vim.fn.input("Breakpoint condition: "))
	end
end, { desc = "DAP conditional breakpoint" })
vim.keymap.set("n", "<leader>dr", function()
	local d = safe_require("dap")
	if d then
		d.repl.open()
	end
end, { desc = "DAP repl" })
vim.keymap.set("n", "<leader>dl", function()
	local d = safe_require("dap")
	if d then
		d.run_last()
	end
end, { desc = "DAP run last" })
