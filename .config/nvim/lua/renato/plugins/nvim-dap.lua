-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.

return {
    {
        -- NOTE: Yes, you can install new plugins here!
        "mfussenegger/nvim-dap",
        -- NOTE: And you can specify dependencies as well
        dependencies = {
            { "rcarriga/nvim-dap-ui" },
            { "nvim-neotest/nvim-nio" },

            { "theHamsta/nvim-dap-virtual-text", opts = {} },

            -- Installs the debug adapters for you
            { "williamboman/mason.nvim" },
            { "jay-babu/mason-nvim-dap.nvim" },
        },
        keys = {
            -- Basic debugging keymaps, feel free to change to your liking!
            {
                "<F1>",
                function()
                    require("dap").step_into()
                end,
                desc = "Debug: Step into",
            },
            {
                "<F2>",
                function()
                    require("dap").step_over()
                end,
                desc = "Debug: Step over",
            },
            {
                "<F3>",
                function()
                    require("dap").step_out()
                end,
                desc = "Debug: Step out",
            },
            {
                "<F4>",
                function()
                    require("dap").restart()
                end,
                desc = "Debug: Restart",
            },
            {
                "<F5>",
                function()
                    require("dap").continue()
                end,
                desc = "Debug: Start/continue",
            },
            {
                "<F6>",
                function()
                    require("dap").run_last()
                end,
                desc = "Debug: Run last session",
            },
            {
                "<F7>",
                function()
                    require("dapui").toggle()
                end,
                desc = "Debug: Toggle UI.",
            },
            {
                "<F8>",
                function()
                    require("dap").terminate()
                end,
                desc = "Debug: Terminate",
            },
            {
                "<leader>tt",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "Debug: Toggle breakpoint",
            },
            {
                "<leader>tb",
                function()
                    require("dap").set_breakpoint(
                        vim.fn.input("Breakpoint condition: ")
                    )
                end,
                desc = "Debug: Set breakpoint",
            },
            {
                "<leader>tc",
                function()
                    require("dap").clear_breakpoints()
                end,
                desc = "Debug: Clear breakpoints",
            },
            {
                "<leader>te",
                function()
                    require("dapui").eval()
                end,
                mode = { "n", "v" },
                desc = "Debug: Evaluate() expression.",
            },
            {
                "<leader>ti",
                function()
                    require("dapui").float_element()
                end,
                desc = "Debug: Inspect() element.",
            },
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            local colors = require("tokyonight.colors").setup()

            require("mason-nvim-dap").setup({
                -- Makes a best effort to setup the various debuggers with
                -- reasonable debug configurations
                automatic_installation = true,

                -- You can provide additional configuration to the handlers,
                -- see mason-nvim-dap README for more information
                handlers = {},

                -- You'll need to check that you have the required things installed
                -- online, please don't ask me how to install them :)
                ensure_installed = {
                    -- Update this to ensure that you have the debuggers for the langs you want
                },
            })

            -- Dap UI setup
            -- For more information, see |:help nvim-dap-ui|
            dapui.setup({
                -- Set icons to characters that are more likely to work in every terminal.
                --    Feel free to remove or use ones that you like more! :)
                --    Don't feel like these are good choices.
            })

            -- Change breakpoint icons
            vim.api.nvim_set_hl(0, "DapBreak", { fg = colors.red })
            vim.api.nvim_set_hl(0, "DapStop", { fg = colors.yellow })
            local breakpoint_icons = vim.g.have_nerd_font
                    and {
                        Breakpoint = "",
                        BreakpointCondition = "",
                        BreakpointRejected = "",
                        LogPoint = "",
                        Stopped = "",
                    }
                or {
                    Breakpoint = "●",
                    BreakpointCondition = "⊜",
                    BreakpointRejected = "⊘",
                    LogPoint = "◆",
                    Stopped = "⭔",
                }
            for type, icon in pairs(breakpoint_icons) do
                local tp = "Dap" .. type
                local hl = (type == "Stopped") and "DapStop" or "DapBreak"
                vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
            end

            dap.listeners.after.event_initialized["dapui_config"] = dapui.open
            dap.listeners.before.event_terminated["dapui_config"] = dapui.close
            dap.listeners.before.event_exited["dapui_config"] = dapui.close

            -- GDB setup
            dap.configurations.c = {
                {
                    name = "Launch file",
                    type = "cppdbg",
                    request = "launch",
                    program = function()
                        return vim.fn.input(
                            "Path to executable: ",
                            vim.fn.getcwd() .. "/",
                            "file"
                        )
                    end,
                    cwd = "${workspaceFolder}",
                    stopAtEntry = true,
                },
                {
                    name = "Launch file with arguments",
                    type = "cppdbg",
                    request = "launch",
                    program = function()
                        return vim.fn.input(
                            "Path to executable: ",
                            vim.fn.getcwd() .. "/",
                            "file"
                        )
                    end,
                    cwd = "${workspaceFolder}",
                    args = function()
                        return vim.fn.split(
                            vim.fn.input("Arguments: "),
                            " ",
                            true
                        )
                    end,
                },
            }

            dap.configurations.java = {
                {
                    name = "Run Debugger (2GB)",
                    type = "java",
                    request = "launch",
                    vmArgs = "" .. "-Xmx2g ",
                },
            }
        end,
    },
}
