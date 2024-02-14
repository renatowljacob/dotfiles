return {
  "HiPhish/rainbow-delimiters.nvim",
  -- This module contains a number of default definitions
  config = function()
    require('rainbow-delimiters.setup').setup({
      -- strategy = {
      --    [''] = rainbow_delimiters.strategy['global'],
      --    vim = rainbow_delimiters.strategy['local'],
      -- },
      query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
      },
      highlight = {
          'RainbowDelimiterYellow',
          'RainbowDelimiterRed',
          'RainbowDelimiterViolet',
          -- 'RainbowDelimiterBlue',
          -- 'RainbowDelimiterOrange',
          -- 'RainbowDelimiterGreen',
          -- 'RainbowDelimiterCyan',
      },
      blacklist = { 'html' },
    })
  end,
}
