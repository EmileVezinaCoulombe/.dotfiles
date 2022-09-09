local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    return
end

local setup = {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = false, -- adds help for motions
            text_objects = false, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true, -- bindings for prefixed with g
        },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    -- operators = { gc = "Comments" },
    key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
    },
    popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
    },
    window = {
        border = "rounded", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0,
    },
    layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
    },
    ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
    triggers = "auto", -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "k" },
        v = { "j", "k" },
    },
}

local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
    ["/"] = { "<cmd>lua require('Comment.api').toggle.linewise.current('g@$')<CR>", "Comment" },
    ["a"] = { "<cmd>Alpha<cr>", "Alpha" },
    ["b"] = {
        "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
        "Buffers",
    },
    ["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },
    ["C"] = { "<cmd>tabclose!<CR>", "Close Tab" },
    ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
    ["E"] = { "<cmd>NvimTreeFindFile<cr>", "Explorer current file" },
    ["f"] = {
        "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
        "Find files",
    },
    ["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
    ["o"] = {"<cmd>tabnew<cr>", "Open Tab"},
    ["P"] = { "<cmd>Telescope projects<cr>", "Projects" },
    ["q"] = { "<cmd>qa!<CR>", "Quit" },
    ["w"] = { "<cmd>w!<CR>", "Save" },
    v = {
        name = "View",
    },
    p = {
        name = "Plugin",
        c = { "<cmd>PackerCompile<cr>", "Compile" },
        i = { "<cmd>PackerInstall<cr>", "Install" },
        s = { "<cmd>PackerSync<cr>", "Sync" },
        S = { "<cmd>PackerStatus<cr>", "Status" },
        u = { "<cmd>PackerUpdate<cr>", "Update" },
    },
    g = {
        name = "Git",
        j = { "<cmd>Gitsigns next_hunk<cr>", "Next Hunk" },
        k = { "<cmd>Gitsigns prev_hunk<cr>", "Prev Hunk" },
        l = { "<cmd>Gitsigns blame_line<cr>", "Blame" },
        p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview Hunk" },
        r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset Hunk" },
        R = { "<cmd>Gitsigns reset_buffer<cr>", "Reset Buffer" },
        s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage Hunk" },
        u = {
            "<cmd>Gitsigns undo_stage_hunk<cr>",
            "Undo Stage Hunk",
        },
        o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
        d = { "<cmd>DiffviewOpen<cr>", "Diff open" },
        D = { "<cmd>DiffviewClose<cr>", "Diff close", },
        h = { "<cmd>DiffviewFileHistory %<cr>", "Diff history" },
    },
    t = {
        name = "Trouble",
        t = { "<cmd>TroubleToggle<cr>", "Togle" },
        w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace" },
        d = { "<cmd>Trouble document_diagnostics<cr>", "Document" },
        l = { "<cmd>Trouble loclist<cr>", "Local" },
        q = { "<cmd>Trouble quickfix<cr>", "Quickfix" },
        r = { "<cmd>Trouble lsp_references<cr>", "References" },
    },
    n = {
        name = "Navigate",
        a = { "<cmd>AerialToggle!<cr>", "Code outline", },
        j = { "<cmd>AerialNext<cr>", "Code outline down", },
        k = { "<cmd>AerialNextUp<cr>", "Code outline up", },
        i = { "<cmd>Telescope lsp_implementations<cr>", "Implementations", },
        d = { "<cmd>Telescope lsp_definitions<cr>", "Definitions", },
        r = { "<cmd>Telescope lsp_references<cr>", "References" },
        s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
        w = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols" },
    },
    l = {
        name = "LSP",
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
        d = { "<cmd>Telescope diagnostics<cr>", "Document Diagnostics", },
        f = { "<cmd>lua vim.lsp.buf.format()<cr>", "Format" },
        h = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover"},
        i = { "<cmd>LspInfo<cr>", "Info" },
        I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
        j = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Next Diagnostic" },
        k = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
        l = { "<cmd>lua vim.diagnostic.open_float()<cr>", "Line Diagnostic" },
        L = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
        q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
        r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
        w = { "<cmd>Telescope diagnostics<cr>", "Workspace Diagnostics", },
    },
    d = {
        name = "Debugging",
        f = { ":lua require'dap'.continue()<cr>1<cr>", "File" },
        p = {
            name = "Python",
            m = { ":lua require('dap-python').test_method()<cr>", "Test method" },
            c = { ":lua require('dap-python').test_class()<cr>", "Test class" },
            s = { ":lua require('dap-python').debug_selection()<cr>", "Section" },
        },
        c = { "<cmd>DapContinue<cr>", "Continue" },
        L = { "<cmd>DapSetLogLevel<cr>", "Set log level" },
        l = { "<cmd>DapShowLog<cr>", "Show log" },
        i = { "<cmd>DapStepInto<cr>", "Into" },
        O = { "<cmd>DapStepOut<cr>", "Out" },
        o = { "<cmd>DapStepOver<cr>", "Over" },
        t = { "<cmd>DapTerminate<cr>", "Terminate" },
        b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Breakpoint" },
        r = { "<cmd>DapToggleRepl<cr>", "Repl" },
        v = { "<cmd>DapVirtualTextToggle<cr>", "Toggle virtual text" },
        B = { "<cmd>lua require'dap'.toggle_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", "Conditional breakpoint" },
        m = { "<cmd>lua require'dap'.toggle_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>", "Message point" },
        u = { "<cmd>lua require'dapui'.toggle()<CR>", "Ui" },
    },
    s = {
        name = "Search",
        f = { "<cmd>Telescope find_files<cr>", "File" },
        t = { "<cmd>Telescope live_grep<cr>", "Text" },
        T = { "<cmd>Telescope<cr>", "Telescope Commands" },
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        B = { "<cmd>Telescope buffers<cr>", "Buffers" },
        c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
        h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
        m = { "<cmd>Telescope media_files<cr>", "Find media files" },
        M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
        r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
        R = { "<cmd>Telescope registers<cr>", "Registers" },
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        C = { "<cmd>Telescope commands<cr>", "Commands" },
    },

    T = {
        name = "Terminal",
        t = { "<cmd>ToggleTerm<cr>", "Terminal" },
        n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
        u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
        r = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
        p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
        f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
        h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
        v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
    },
    r = {
        name = "Run",
        p = {
            f = { "<cmd>TermExec cmd='python expand(\'%:p\')'<cr>", "File" },
            p = { "<cmd>TermExec cmd='python -m cProfile -o program.prof expand(\'%:p\')'<cr>", "Profile" },
            v = { "<cmd>TermExec cmd='snakeviz program.prof'<cr>", "View profile" },
        },
    },
    i = {
        name = "Icon Picker",
        a = { "<cmd>PickEverything<cr>", "All" },
        i = { "<cmd>PickIcons<cr>", "Icons and Emojis" },
        e = { "<cmd>PickEmoji<cr>", "Emojis" },
        n = { "<cmd>PickNerd<cr>", "Nerd Font" },
        s = { "<cmd>PickSymbols<cr>", "Symbols" },
        f = { "<cmd>PickAltFontAndSymbols<cr>", "Alt Font and Symbols" },
    }
}

local vopts = {
    mode = "v", -- VISUAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}
local vmappings = {
    ["/"] = { "<ESC><CMD>lua require(\"Comment.api\").toggle.linewise(vim.fn.visualmode())<CR>", "Comment" },
    ["a"] = { ":'<,'>lua vim.lsp.buf.range_code_action()<CR>", "List code actions" },
    r = {
        name = "Refactor",
        e = { "<Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>", "Extract Function" },
        f = {
            "<Esc><Cmd>lua require('refactoring').refactor('Extract Function to File')<CR>",
            "Extract Function to File",
        },
        v = { "<Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>", "Extract Variable" },
        i = { "<Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>", "Inline Variable" },
        r = { "<Esc><Cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", "Refactor" },
        V = { "<Esc><Cmd>lua require('refactoring').debug.print_var({})<CR>", "Debug Print Var" },
    },

}

which_key.setup(setup)
which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
