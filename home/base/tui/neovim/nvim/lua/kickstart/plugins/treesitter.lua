local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'zig', 'python', 'css', 'javascript', 'go', 'nix', 'regex' }

return {
  { -- Highlight, edit, and navigate code
    -- NOTE: This is the `main` branch rewrite. It has no `configs` module and ignores
    --  `opts` like ensure_installed/highlight, so parsers are installed and features
    --  enabled explicitly below. Building parsers needs the `tree-sitter` CLI and a C compiler.
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false, -- does not support lazy-loading
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install(parsers)

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('kickstart-treesitter', { clear = true }),
        callback = function(event)
          -- Only start treesitter when a parser exists for this filetype
          if not pcall(vim.treesitter.start, event.buf) then
            return
          end
          -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
          if event.match ~= 'ruby' then
            vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
}
-- vim: ts=2 sts=2 sw=2 et
