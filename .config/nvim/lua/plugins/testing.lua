return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-go",
  },
  cmd = { "Neotest" },
  config = function()
    require("neotest").setup {
      adapters = {
        require "neotest-go",
      },
    }
  end,
}
