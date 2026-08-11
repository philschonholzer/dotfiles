return {
  {
    -- Use the nixpkgs-built version (via nix wrapper env var) to avoid the broken pre-compiled binary
    "iamcco/markdown-preview.nvim",
    dir = vim.env.MARKDOWN_PREVIEW_NVIM_PATH,
    build = false,
  },
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
