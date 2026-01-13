return {
  "esmuellert/codediff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = "CodeDiff",
  keys = {
    { "<leader>gc", "<cmd>CodeDiff<cr>", desc = "Code Diff" },
  },
}
