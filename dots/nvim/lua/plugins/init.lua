return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = true,
    lazy = false,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash Jump",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
    },
  },
  { import = "nvchad.blink.lazyspec" },
  {
    "strehk/lazy-watson",
    ft = { "javascript", "typescript", "svelte", "javascriptreact", "typescriptreact" },
    opts = {},
    keys = {
      {
        "<leader>wt",
        function()
          require("lazy-watson").toggle()
        end,
        desc = "Toggle Watson preview",
      },
      {
        "<leader>wl",
        function()
          require("lazy-watson").select_locale()
        end,
        desc = "Select locale",
      },
      {
        "<leader>wr",
        function()
          require("lazy-watson").refresh()
        end,
        desc = "Refresh translations",
      },
      {
        "<leader>wh",
        function()
          require("lazy-watson").show_hover()
        end,
        desc = "Show hover preview",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
      },
    },
  },
}
