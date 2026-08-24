return {
  "emrearmagan/atlas.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "MeanderingProgrammer/render-markdown.nvim",
    "esmuellert/codediff.nvim",
  },
  cmd = { "Atlas", "AtlasDiff" },
  opts = {
    pulls = {
      providers = {
        bitbucket = {
          user = vim.env.BITBUCKET_USER,
          token = vim.env.BITBUCKET_TOKEN,
          views = {
            {
              name = "Current repository",
              key = "1",
              layout = "compact",
              current_repo = true,
            },
          },
        },
      },
    },
  },
}
