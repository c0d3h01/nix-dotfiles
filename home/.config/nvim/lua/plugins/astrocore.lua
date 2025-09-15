---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = function(_, opts)
    -- PERFORMANCE-OPTIMIZED OPTIONS
    opts.options = opts.options or {}
    opts.options.opt = vim.tbl_deep_extend("force", opts.options.opt or {}, {
      -- Display optimizations
      number = true,
      relativenumber = true,
      cursorline = true,
      cursorlineopt = "number", -- Only highlight line number, not entire line
      signcolumn = "yes:1", -- Fixed width signcolumn for stability
      wrap = false,
      termguicolors = true,
      lazyredraw = true, -- Don't redraw while executing macros

      -- Window behavior
      splitbelow = true,
      splitright = true,

      -- Performance timing
      timeoutlen = 300, -- Faster which-key popup
      updatetime = 100, -- Faster CursorHold events
      redrawtime = 1500, -- Limit redraw time for large files

      -- File handling (optimized)
      undofile = true,
      undolevels = 1000, -- Limit undo history for performance
      swapfile = false, -- Disable swap for speed (use undofile instead)
      backup = false,
      writebackup = false,

      -- System integration
      clipboard = "unnamedplus",
      mouse = "a", -- Enable mouse for productivity

      -- Search optimizations
      ignorecase = true,
      smartcase = true,
      incsearch = true,
      hlsearch = true,

      -- Scrolling performance
      scrolloff = 4, -- Reduced for performance
      sidescrolloff = 8,
      scroll = 10, -- Smooth scrolling

      -- Indentation (coding optimized)
      expandtab = true,
      shiftwidth = 2,
      tabstop = 2,
      softtabstop = 2,
      smartindent = true,
      autoindent = true,
      shiftround = true, -- Round indent to multiple of shiftwidth

      -- Visual indicators (minimal for performance)
      list = true,
      listchars = {
        tab = "→ ",
        trail = "·",
        extends = "»",
        precedes = "«",
        nbsp = "⦸",
      },
      fillchars = {
        vert = "│",
        fold = "·",
        eob = " ",
        msgsep = "─",
        diff = "╱",
      },

      -- Folding (optimized for code)
      foldmethod = "expr",
      foldexpr = "v:lua.vim.treesitter.foldexpr()", -- Modern API
      foldlevel = 99,
      foldlevelstart = 99,
      foldenable = true,
      foldcolumn = "1", -- Show fold column

      -- Completion performance
      completeopt = "menu,menuone,noselect,noinsert",
      pumheight = 15, -- Limit completion menu height

      -- Advanced editor features
      conceallevel = 2, -- Hide markup in markdown, etc.
      concealcursor = "nc", -- Hide concealed text in normal/command mode
      virtualedit = "block", -- Allow cursor beyond end of line in visual block

      -- Session and file handling
      sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions",

      -- Performance for large files
      synmaxcol = 300, -- Limit syntax highlighting for long lines
      maxmempattern = 20000, -- Increase pattern matching memory
    })

    -- ADVANCED FEATURES (lightweight)
    opts.features = vim.tbl_deep_extend("force", opts.features or {}, {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- More aggressive large file detection
      autopairs = true,
      cmp = true,
      diagnostics = {
        virtual_text = { severity = vim.diagnostic.severity.ERROR }, -- Only show errors inline
        virtual_lines = false,
        signs = true,
        underline = true,
        update_in_insert = false, -- Better performance
      },
      highlighturl = true,
      notifications = true,
    })

    -- ADVANCED KEY MAPPINGS
    opts.mappings = opts.mappings or {}
    opts.mappings.n = opts.mappings.n or {}
    local maps = opts.mappings.n

    local function map_once(lhs, rhs)
      if not maps[lhs] then maps[lhs] = rhs end
    end

    -- BUFFER MANAGEMENT (Advanced)
    map_once("]b", { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" })
    map_once("[b", { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" })
    map_once("<Leader>bd", {
      function()
        require("astroui.status.heirline").buffer_picker(function(bufnr) require("astrocore.buffer").close(bufnr) end)
      end,
      desc = "Close buffer (picker)",
    })
    map_once("<Leader>bb", { "<Cmd>enew<CR>", desc = "New buffer" })
    map_once("<Leader>bo", {
      function()
        local current = vim.api.nvim_get_current_buf()
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(b) and b ~= current and vim.bo[b].buflisted then
            pcall(vim.api.nvim_buf_delete, b, { force = false })
          end
        end
      end,
      desc = "Close other buffers",
    })
    map_once("<Leader>ba", { "<Cmd>%bd|e#<CR>", desc = "Close all but current" })

    -- FILE OPERATIONS (Quick)
    map_once("<Leader>w", { "<Cmd>w<CR>", desc = "Save" })
    map_once("<Leader>W", { "<Cmd>wa<CR>", desc = "Save all" })
    map_once("<Leader>q", { "<Cmd>q<CR>", desc = "Quit" })
    map_once("<Leader>Q", { "<Cmd>qa!<CR>", desc = "Force quit all" })
    map_once("<C-s>", { "<Cmd>w<CR>", desc = "Save (Ctrl+S)" })

    -- ADVANCED EDITING
    map_once("J", { "mzJ`z", desc = "Join lines (keep cursor)" })
    map_once("<C-d>", { "<C-d>zz", desc = "Half page down (center)" })
    map_once("<C-u>", { "<C-u>zz", desc = "Half page up (center)" })
    map_once("n", { "nzzzv", desc = "Next search (center)" })
    map_once("N", { "Nzzzv", desc = "Prev search (center)" })

    -- SMART LINE MOVEMENT
    map_once("j", { function() return vim.v.count == 0 and "gj" or "j" end, expr = true, desc = "Down (wrap aware)" })
    map_once("k", { function() return vim.v.count == 0 and "gk" or "k" end, expr = true, desc = "Up (wrap aware)" })

    -- WINDOW NAVIGATION (Vim-style)
    map_once("<C-h>", { "<C-w>h", desc = "Window left" })
    map_once("<C-j>", { "<C-w>j", desc = "Window down" })
    map_once("<C-k>", { "<C-w>k", desc = "Window up" })
    map_once("<C-l>", { "<C-w>l", desc = "Window right" })

    -- WINDOW RESIZING (Intuitive)
    map_once("<C-Left>", { "<Cmd>vertical resize -4<CR>", desc = "Resize left" })
    map_once("<C-Right>", { "<Cmd>vertical resize +4<CR>", desc = "Resize right" })
    map_once("<C-Up>", { "<Cmd>resize +2<CR>", desc = "Resize up" })
    map_once("<C-Down>", { "<Cmd>resize -2<CR>", desc = "Resize down" })

    -- ADVANCED SEARCH
    map_once("<Esc>", { "<Cmd>nohlsearch<CR><Esc>", desc = "Clear search" })
    map_once("*", { "*zz", desc = "Search word under cursor (center)" })
    map_once("#", { "#zz", desc = "Search word backward (center)" })

    -- DIAGNOSTICS (Quick access)
    map_once("[d", { function() vim.diagnostic.goto_prev { float = false } end, desc = "Prev diagnostic" })
    map_once("]d", { function() vim.diagnostic.goto_next { float = false } end, desc = "Next diagnostic" })
    map_once(
      "[e",
      { function() vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR } end, desc = "Prev error" }
    )
    map_once(
      "]e",
      { function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR } end, desc = "Next error" }
    )
    map_once("<Leader>e", {
      function() vim.diagnostic.open_float(nil, { focus = false, border = "rounded" }) end,
      desc = "Line diagnostics",
    })

    -- QUICKFIX & LOCATION LIST
    map_once("<Leader>cq", { "<Cmd>copen<CR>", desc = "Open quickfix" })
    map_once("<Leader>cc", { "<Cmd>cclose<CR>", desc = "Close quickfix" })
    map_once("<Leader>lq", { "<Cmd>lopen<CR>", desc = "Open location list" })
    map_once("<Leader>lc", { "<Cmd>lclose<CR>", desc = "Close location list" })
    map_once("]q", { "<Cmd>cnext<CR>", desc = "Next quickfix" })
    map_once("[q", { "<Cmd>cprev<CR>", desc = "Prev quickfix" })

    -- FOLDING (Advanced)
    map_once("zr", { "zr", desc = "Open more folds" })
    map_once("zm", { "zm", desc = "Close more folds" })
    map_once("zR", { "zR", desc = "Open all folds" })
    map_once("zM", { "zM", desc = "Close all folds" })
    map_once("za", { "za", desc = "Toggle fold" })
    map_once("zA", { "zA", desc = "Toggle fold recursively" })

    -- SYSTEM CLIPBOARD (Enhanced)
    map_once("<Leader>y", { '"+y', desc = "Yank to system" })
    map_once("<Leader>p", { '"+p', desc = "Paste from system" })
    map_once("<Leader>Y", { '"+Y', desc = "Yank line to system" })

    -- UI TOGGLES (Advanced)
    map_once("<Leader>ut", { "<Cmd>set invrelativenumber<CR>", desc = "Toggle relative numbers" })
    map_once("<Leader>uw", { "<Cmd>set invwrap<CR>", desc = "Toggle wrap" })
    map_once("<Leader>us", {
      function()
        vim.o.spell = not vim.o.spell
        vim.notify("Spell: " .. (vim.o.spell and "ON" or "OFF"))
      end,
      desc = "Toggle spell",
    })
    map_once("<Leader>ud", {
      function()
        local config = vim.diagnostic.config()
        local vt = config.virtual_text
        vim.diagnostic.config { virtual_text = not vt }
        vim.notify("Virtual text: " .. (vt and "OFF" or "ON"))
      end,
      desc = "Toggle diagnostic virtual text",
    })
    map_once("<Leader>uc", {
      function()
        vim.o.conceallevel = vim.o.conceallevel == 0 and 2 or 0
        vim.notify("Conceal: " .. (vim.o.conceallevel > 0 and "ON" or "OFF"))
      end,
      desc = "Toggle conceal",
    })

    -- CODE ACTIONS (Quick)
    map_once("<Leader>a", { function() vim.lsp.buf.code_action() end, desc = "Code action" })
    map_once("<Leader>r", { function() vim.lsp.buf.rename() end, desc = "Rename" })

    -- TERMINAL (Advanced)
    map_once("<Leader>tt", { "<Cmd>ToggleTerm direction=horizontal<CR>", desc = "Toggle terminal" })
    map_once("<Leader>tf", { "<Cmd>ToggleTerm direction=float<CR>", desc = "Toggle float terminal" })

    -- Group descriptors
    if not maps["<Leader>b"] then maps["<Leader>b"] = { desc = "󰓩 Buffers" } end
    if not maps["<Leader>f"] then maps["<Leader>f"] = { desc = "󰈞 Find" } end
    if not maps["<Leader>u"] then maps["<Leader>u"] = { desc = "󰔡 UI Toggles" } end
    if not maps["<Leader>c"] then maps["<Leader>c"] = { desc = "󰔫 QuickFix" } end
    if not maps["<Leader>l"] then maps["<Leader>l"] = { desc = "󰒋 LSP" } end
    if not maps["<Leader>t"] then maps["<Leader>t"] = { desc = "󰆍 Terminal" } end

    -- VISUAL MODE ENHANCEMENTS
    opts.mappings.v = opts.mappings.v or {}
    if not opts.mappings.v["<Leader>y"] then opts.mappings.v["<Leader>y"] = { '"+y', desc = "Yank to system" } end
    if not opts.mappings.v["<Leader>p"] then opts.mappings.v["<Leader>p"] = { '"+p', desc = "Paste from system" } end
    if not opts.mappings.v[">"] then opts.mappings.v[">"] = { ">gv", desc = "Indent and reselect" } end
    if not opts.mappings.v["<"] then opts.mappings.v["<"] = { "<gv", desc = "Outdent and reselect" } end
    if not opts.mappings.v["J"] then opts.mappings.v["J"] = { ":m '>+1<CR>gv=gv", desc = "Move selection down" } end
    if not opts.mappings.v["K"] then opts.mappings.v["K"] = { ":m '<-2<CR>gv=gv", desc = "Move selection up" } end

    -- INSERT MODE IMPROVEMENTS
    opts.mappings.i = opts.mappings.i or {}
    if not opts.mappings.i["jk"] then opts.mappings.i["jk"] = { "<Esc>", desc = "Exit insert mode" } end
    if not opts.mappings.i["<C-s>"] then
      opts.mappings.i["<C-s>"] = { "<Esc><Cmd>w<CR>a", desc = "Save and continue" }
    end

    -- PERFORMANCE-OPTIMIZED AUTOCMDS
    opts.autocmds = opts.autocmds or {}

    opts.autocmds.yank_highlight = {
      {
        event = "TextYankPost",
        desc = "Highlight yanked text",
        callback = function()
          vim.highlight.on_yank {
            higroup = "IncSearch",
            timeout = 200, -- Faster timeout
          }
        end,
      },
    }

    opts.autocmds.trim_trailing_ws = {
      {
        event = "BufWritePre",
        desc = "Trim trailing whitespace",
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          local exclude_ft = { "markdown", "diff", "gitcommit", "text" }
          if not vim.tbl_contains(exclude_ft, ft) then
            local view = vim.fn.winsaveview()
            vim.cmd [[silent! %s/\s\+$//e]]
            vim.fn.winrestview(view)
          end
        end,
      },
    }

    opts.autocmds.auto_create_dir = {
      {
        event = "BufWritePre",
        desc = "Auto create directories",
        callback = function(event)
          local file = event.match
          if file:match "^%w%w+://" then return end
          local dir = vim.fn.fnamemodify(file, ":p:h")
          if not (vim.uv or vim.loop).fs_stat(dir) then vim.fn.mkdir(dir, "p") end
        end,
      },
    }

    -- PERFORMANCE AUTOCMDS
    opts.autocmds.performance = {
      {
        event = "BufEnter",
        desc = "Disable syntax for large files",
        callback = function(args)
          local buf = args.buf
          local max_filesize = 512 * 1024 -- 512KB
          if vim.api.nvim_buf_is_valid(buf) then
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              vim.cmd "syntax off"
              vim.opt_local.foldmethod = "manual"
              vim.opt_local.spell = false
            end
          end
        end,
      },
      {
        event = "WinEnter",
        desc = "Auto resize splits",
        callback = function() vim.cmd "wincmd =" end,
      },
    }

    -- CODING HELPERS
    opts.autocmds.coding_helpers = {
      {
        event = "BufReadPost",
        desc = "Go to last cursor position",
        callback = function()
          local mark = vim.api.nvim_buf_get_mark(0, '"')
          local lcount = vim.api.nvim_buf_line_count(0)
          if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
        end,
      },
    }

    return opts
  end,
}
