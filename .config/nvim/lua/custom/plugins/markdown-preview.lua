return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]()
    end,
    config = function()
      vim.g.mkdp_browser = "/usr/bin/firefox-developer-edition"
      vim.g.mkdp_theme = "dark"
    end,
}
