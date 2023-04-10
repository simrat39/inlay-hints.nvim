local M = {}

local defaults = {
  -- renderer to use
  -- possible options are dynamic, eol, virtline and custom
  renderer = "inlay-hints/render/dynamic",

  hints = {
    parameter = {
      show = true,
      highlight = "Comment",
    },
    type = {
      show = true,
      highlight = "Comment",
    },
  },

  -- Only show inlay hints for the current line
  only_current_line = false,

  eol = {
    -- whether to align to the extreme right or not
    right_align = false,

    -- padding from the right if right_align is true
    right_align_padding = 7,

    -- virtual text priority
    priority = 0,

    parameter = {
      separator = ", ",
      format = function(hints)
        return string.format(" <- (%s)", hints)
      end,
    },

    type = {
      separator = ", ",
      format = function(hints)
        return string.format(" » (%s)", hints)
      end,
    },
  },
}

M.options = {}

function M.setup(options)
  M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
end

return M
