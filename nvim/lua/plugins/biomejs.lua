-- https://biomejs.dev/internals/language-support/
local supported = {
  "astro",
  "css",
  "graphql",
  -- "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  -- "markdown",
  "svelte",
  "typescript",
  "typescriptreact",
  "vue",
  -- "yaml",
}
return {
  {
    "stevearc/conform.nvim",
    optional = true,
    ---@param opts ConformOpts
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(supported) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "biome-check")
      end

      opts.formatters = opts.formatters or {}
      opts.formatters["biome-check"] = {
        command = "biome",
        require_cwd = true,
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        biome = {
          mason = false,
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(value)
        return not vim.tbl_contains({ "biome" }, value)
      end, opts.ensure_installed)

      return opts
    end,
  },
}
