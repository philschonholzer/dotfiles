return {
  "pablopunk/pi.nvim",
  keys = {
    -- Ask pi with the current buffer as context
    { "<leader>ai", ":PiAsk<CR>", desc = "Ask pi", mode = "n" },

    -- Ask pi with visual selection as context
    { "<leader>ai", ":PiAskSelection<CR>", desc = "Ask pi (selection)", mode = "v" },
  },
}
