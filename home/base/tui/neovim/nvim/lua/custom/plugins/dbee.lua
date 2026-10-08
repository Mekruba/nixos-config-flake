return
{
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  build = function()
    -- Install tries to automatically detect the install method.
    -- if it fails, try calling it with one of these parameters:
    --    "curl", "wget", "bitsadmin", "go"
    require("dbee").install()
  end,
  config = function()
    -- nvim-dbee still uses the deprecated vim.validate{} form; replace it until upstream fixes it
    require("dbee.config").validate = function(cfg)
      for name, spec in pairs {
        sources = { cfg.sources, "table" },
        extra_helpers = { cfg.extra_helpers, "table" },
        float_options = { cfg.float_options, "table" },

        drawer_disable_candies = { cfg.drawer.disable_candies, "boolean" },
        drawer_disable_help = { cfg.drawer.disable_help, "boolean" },
        drawer_candies = { cfg.drawer.candies, "table" },
        drawer_mappings = { cfg.drawer.mappings, "table" },
        result_page_size = { cfg.result.page_size, "number" },
        result_progress = { cfg.result.progress, "table" },
        result_mappings = { cfg.result.mappings, "table" },
        editor_mappings = { cfg.editor.mappings, "table" },
        call_log_mappings = { cfg.call_log.mappings, "table" },

        window_layout = { cfg.window_layout, "table" },
        window_layout_open = { cfg.window_layout.open, "function" },
        window_layout_is_open = { cfg.window_layout.is_open, "function" },
        window_layout_close = { cfg.window_layout.close, "function" },
      } do
        vim.validate(name, spec[1], spec[2])
      end
    end

    require("dbee").setup( --[[optional config]])
  end,
  -- keys = {
  --   { "<leader>do", function() require("dbee").open() end, desc = "Open db view" },
  -- }
}
