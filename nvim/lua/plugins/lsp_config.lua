return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    ---@type lspconfig.options
    servers = {
      intelephense = {
        commands = {
          IntelephenseIndex = {
            function()
              vim.lsp.buf.execute_command({ command = "intelephense.index.workspace" })
            end,
          },
        },
      },
    },
  },
}
