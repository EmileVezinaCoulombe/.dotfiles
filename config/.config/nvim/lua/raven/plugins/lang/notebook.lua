-- from : https://alpha2phi.medium.com/neovim-pde-for-data-science-e1cc4c82a424
-- Thanks alpha2phi 😄

local function get_commenter()
    local commenter = { python = "# ", lua = "-- ", julia = "# ", fennel = ";; ", scala = "// ", r = "# " }
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
    if ft == nil or ft == "" then
        return commenter["python"]
    elseif commenter[ft] == nil then
        return commenter["python"]
    end

    return commenter[ft]
end

local CELL_MARKER = get_commenter() .. "%%"
vim.api.nvim_set_hl(0, "CellMarkerHl", { default = true, bg = "#c5c5c5", fg = "#111111" })

local function miniai_spec(mode)
    local start_line = vim.fn.search("^" .. CELL_MARKER, "bcnW")

    if start_line == 0 then
        start_line = 1
    else
        if mode == "i" then
            start_line = start_line + 1
        end
    end

    local end_line = vim.fn.search("^" .. CELL_MARKER, "nW") - 1
    if end_line == -1 then
        end_line = vim.fn.line("$")
    end

    local last_col = math.max(vim.fn.getline(end_line):len(), 1)

    local from = { line = start_line, col = 1 }
    local to = { line = end_line, col = last_col }

    return { from = from, to = to }
end

local function show_cell_markers()
    require("mini.hipatterns").enable(0, {
        highlighters = {
            marker = { pattern = "^" .. get_commenter() .. "%%%%", group = "CellMarkerHl" },
        },
    })
end

local function select_cell()
    local bufnr = vim.api.nvim_get_current_buf()
    local current_row = vim.api.nvim_win_get_cursor(0)[1]
    local current_col = vim.api.nvim_win_get_cursor(0)[2]

    local start_line = nil
    local end_line = nil

    for line = current_row, 1, -1 do
        local line_content = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]
        if line_content:find("^" .. CELL_MARKER) then
            start_line = line
            break
        end
    end
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    for line = current_row + 1, line_count do
        local line_content = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]
        if line_content:find("^" .. CELL_MARKER) then
            end_line = line
            break
        end
    end

    if not start_line then
        start_line = 1
    end
    if not end_line then
        end_line = line_count
    end
    return current_row, current_col, start_line, end_line
end

local function execute_cell()
    local current_row, current_col, start_line, end_line = select_cell()
    if start_line and end_line then
        vim.fn.setpos("'<", { 0, start_line + 1, 0, 0 })
        vim.fn.setpos("'>", { 0, end_line - 1, 0, 0 })
        require("iron.core").visual_send()
        vim.api.nvim_win_set_cursor(0, { current_row, current_col })
    end
end

local function delete_cell()
    local _, _, start_line, end_line = select_cell()
    if start_line and end_line then
        local rows_to_select = end_line - start_line - 1
        vim.api.nvim_win_set_cursor(0, { start_line, 0 })
        vim.cmd("normal!V " .. rows_to_select .. "j")
        vim.cmd("normal!d")
        vim.cmd("normal!k")
    end
end

local function navigate_cell(up)
    local is_up = up or false
    local _, _, start_line, end_line = select_cell()
    if is_up and start_line ~= 1 then
        vim.api.nvim_win_set_cursor(0, { start_line - 1, 0 })
    elseif end_line then
        local bufnr = vim.api.nvim_get_current_buf()
        local line_count = vim.api.nvim_buf_line_count(bufnr)
        if end_line ~= line_count then
            vim.api.nvim_win_set_cursor(0, { end_line + 1, 0 })
            _, _, start_line, end_line = select_cell()
            vim.api.nvim_win_set_cursor(0, { end_line - 1, 0 })
        end
    end
end

local function move_cell(dir)
    local search_res
    local result
    if dir == "d" then
        search_res = vim.fn.search("^" .. CELL_MARKER, "W")
        if search_res == 0 then
            result = "last"
        end
    else
        search_res = vim.fn.search("^" .. CELL_MARKER, "bW")
        if search_res == 0 then
            result = "first"
            vim.api.nvim_win_set_cursor(0, { 1, 0 })
        end
    end

    return result
end

local function insert_cell_before(content)
    content = content or CELL_MARKER
    local cell_object = miniai_spec("a")
    vim.api.nvim_buf_set_lines(0, cell_object.from.line - 1, cell_object.from.line - 1, false, { content, "" })
    move_cell("u")
end

local function insert_cell_after(content)
    content = content or CELL_MARKER
    vim.print(content)
    local cell_object = miniai_spec("a")
    vim.api.nvim_buf_set_lines(0, cell_object.to.line, cell_object.to.line, false, { content, "" })
    move_cell("d")
end

local function insert_markdown_cell()
    insert_cell_after(CELL_MARKER .. " [markdown]")
end

return {
    {
        "goerz/jupytext.vim",
        build = "pip install jupytext",
        event = "VeryLazy",
        dependencies = { "neovim/nvim-lspconfig" },
        opts = {},
        config = function()
            -- The destination format: 'ipynb', 'markdown' or 'script', or a file extension: 'md', 'Rmd', 'jl', 'py', 'R', ..., 'auto' (script
            -- extension matching the notebook language), or a combination of an extension and a format name, e.g. md:markdown, md:pandoc,
            -- md:myst or py:percent, py:light, py:nomarker, py:hydrogen, py:sphinx. The default format for scripts is the 'light' format,
            -- which uses few cell markers (none when possible). Alternatively, a format compatible with many editors is the 'percent' format,
            -- which uses '# %%' as cell markers. The main formats (markdown, light, percent) preserve notebooks and text documents in a
            -- roundtrip. Use the --test and and --test-strict commands to test the roundtrip on your files. Read more about the available
            -- formats at https://jupytext.readthedocs.io/en/latest/formats.html (default: None)
            vim.g.jupytext_fmt = "py:percent"

            -- Autocmd to set cell markers
            vim.api.nvim_create_autocmd({ "BufEnter" }, { -- "BufWriteCmd"
                group = vim.api.nvim_create_augroup("au_show_cell_markers", { clear = true }),
                pattern = { "*.py", "*.ipynb" },
                callback = function(event)
                    show_cell_markers()
                end,
            })
        end,
    },
    {
        "Vigemus/iron.nvim",
        event = "VeryLazy",
        opts = function()
            return {
                config = {
                    -- Whether a repl should be discarded or not
                    scratch_repl = true,
                    -- Your repl definitions come here

                    repl_definition = {
                        python = require("iron.fts.python").ipython,
                        scala = require("iron.fts.scala").scala,
                    },
                    -- How the repl window will be displayed
                    -- See below for more information
                    repl_open_cmd = require("iron.view").right("50%"),
                },
                -- If the highliht is on, you can change how it looks
                -- For the available options, check nvim_set_hl
                highlight = {
                    italic = true,
                },
                ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
            }
        end,
        keys = {
            { "<leader>na", insert_cell_after, desc = "Insert Cell After" },
            { "<leader>nb", insert_cell_before, desc = "Insert Cell Before" },
            { "<leader>nm", insert_markdown_cell, desc = "Insert Markdown Cell" },
            { "<leader>ne", execute_cell, desc = "Execute Cell" },
            { "<leader>nx", delete_cell, desc = "Delete Cell" },
            { "]c", navigate_cell, desc = "Next Cell" },
            {
                "<[c",
                function()
                    navigate_cell(true)
                end,
                desc = "Previous Cell",
            },
            {
                "<leader>xs",
                function()
                    require("iron.core").run_motion("send_motion")
                end,
                desc = "Send Motion",
            },
            {
                "<leader>xs",
                function()
                    require("iron.core").visual_send()
                end,
                mode = { "v" },
                desc = "Send",
            },
            {
                "<leader>xl",
                function()
                    require("iron.core").send_line()
                end,
                desc = "Send Line",
            },
            {
                "<leader>xt",
                function()
                    require("iron.core").send_until_cursor()
                end,
                desc = "Send Until Cursor",
            },
            {
                "<leader>xf",
                function()
                    require("iron.core").send_file()
                end,
                desc = "Send File",
            },
            {
                "<leader>xL",
                function()
                    require("iron.marks").clear_hl()
                end,
                mode = { "v" },
                desc = "Clear Highlight",
            },
            {
                "<leader>x<cr>",
                function()
                    require("iron.core").send(nil, string.char(13))
                end,
                desc = "ENTER",
            },
            {
                "<leader>xI",
                function()
                    require("iron.core").send(nil, string.char(03))
                end,
                desc = "Interrupt",
            },
            {
                "<leader>xC",
                function()
                    require("iron.core").close_repl()
                end,
                desc = "Close REPL",
            },
            {
                "<leader>xc",
                function()
                    require("iron.core").send(nil, string.char(12))
                end,
                desc = "Clear",
            },
            {
                "<leader>xms",
                function()
                    require("iron.core").send_mark()
                end,
                desc = "Send Mark",
            },
            {
                "<leader>xmm",
                function()
                    require("iron.core").run_motion("mark_motion")
                end,
                desc = "Mark Motion",
            },
            {
                "<leader>xmv",
                function()
                    require("iron.core").mark_visual()
                end,
                mode = { "v" },
                desc = "Mark Visual",
            },
            {
                "<leader>xmr",
                function()
                    require("iron.marks").drop_last()
                end,
                desc = "Remove Mark",
            },
            { "<leader>xR", "<cmd>IronRepl<cr>", desc = "REPL" },
            { "<leader>xS", "<cmd>IronRestart<cr>", desc = "Restart" },
            { "<leader>xF", "<cmd>IronFocus<cr>", desc = "Focus" },
            { "<leader>xH", "<cmd>IronHide<cr>", desc = "Hide" },
        },
        config = function(_, opts)
            local iron = require("iron.core")
            iron.setup(opts)
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            defaults = {
                ["<leader>n"] = { name = "+NoteBook" },
                ["<leader>x"] = { name = "+REPL" },
                ["<leader>xm"] = { name = "+Mark" },
            },
        },
    },
    {
        "echasnovski/mini.ai",
        opts = function(_, opts)
            opts.custom_textobjects = vim.tbl_extend("force", opts.custom_textobjects, { j = miniai_spec })

            ---@type table<string, string|table>
            local i = {
                j = "jupyter cell",
            }
            require("which-key").register({ mode = { "o", "x" }, i = i, a = i })
        end,
    },
}
