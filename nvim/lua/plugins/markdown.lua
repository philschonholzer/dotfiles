return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          mason = false,
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(value)
        return not vim.tbl_contains({ "marksman" }, value)
      end, opts.ensure_installed)

      return opts
    end,
  },
}
