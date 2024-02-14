return {

  "utilyre/sentiment.nvim",
  version = "*",
  event = "VeryLazy", -- keep for lazy loading
  opts = {
    delay = 30,

    pairs = {
      {"(", ")"},
      {"[", "]"},
      {"{", "}"},
    },
  },
  init = function()
    require("tokyonight.colors")
    -- `matchparen.vim` needs to be disabled manually in case of lazy loading
    vim.g.loaded_matchparen = 1
    vim.api.nvim_set_hl(0, "matchparen", { bg = "#292e42", fg = "#1abc9c", bold = true })
  end,
}
