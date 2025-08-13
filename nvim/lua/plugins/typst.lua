return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tinymist = {
          settings = {
            -- optional settings for tinymist
            exportPdf = "onSave", -- or "onType"
            formatterMode = "typstyle",
          },
          keys = {
            { "<leader>cp", "<cmd>TypstPreview<cr>", desc = "Start Typst Preview" },
            { "<leader>cq", "<cmd>TypstPreviewStop<cr>", desc = "Stop Typst Preview" },
            { "<leader>cx", "<cmd>LspTinymistExportPdf<cr>", desc = "Export Typst to PDF" },
          },
        },
      },
    },
  },
  {
    "chomosuke/typst-preview.nvim",
    lazy = false, -- or ft = 'typst'
    version = "1.*",
    opts = {}, -- lazy.nvim will implicitly calls `setup {}`
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        typst = { "typstyle" },
      },
      formatters = {
        typstyle = {
          command = "typstyle",
          args = { "-i", "--wrap-text", "$FILENAME" },
          stdin = false,
        },
      },
    },
  },
}
