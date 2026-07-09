-- nvim-treesitter-textobjects main branch config.
-- Replaces the old configs.setup({ textobjects = { ... } }) pattern.
-- Keymaps are set via direct module function calls; options via setup().

require("nvim-treesitter-textobjects").setup({
  select = { lookahead = true },
  move = { set_jumps = true },
})

local sel = require("nvim-treesitter-textobjects.select")
local mv  = require("nvim-treesitter-textobjects.move")
local sw  = require("nvim-treesitter-textobjects.swap")

-- Select textobjects (visual + operator-pending)
vim.keymap.set({"x","o"}, "af", function() sel.select_textobject("@function.outer","textobjects") end, {desc="outer function"})
vim.keymap.set({"x","o"}, "if", function() sel.select_textobject("@function.inner","textobjects") end, {desc="inner function"})
vim.keymap.set({"x","o"}, "ac", function() sel.select_textobject("@class.outer","textobjects")    end, {desc="outer class"})
vim.keymap.set({"x","o"}, "ic", function() sel.select_textobject("@class.inner","textobjects")    end, {desc="inner class"})
vim.keymap.set({"x","o"}, "aa", function() sel.select_textobject("@parameter.outer","textobjects") end, {desc="outer parameter"})
vim.keymap.set({"x","o"}, "ia", function() sel.select_textobject("@parameter.inner","textobjects") end, {desc="inner parameter"})
vim.keymap.set({"x","o"}, "ab", function() sel.select_textobject("@block.outer","textobjects")    end, {desc="outer block"})
vim.keymap.set({"x","o"}, "ib", function() sel.select_textobject("@block.inner","textobjects")    end, {desc="inner block"})

-- Move to function/class/parameter start/end (normal + visual + operator-pending)
vim.keymap.set({"n","x","o"}, "]m",  function() mv.goto_next_start("@function.outer","textobjects")    end, {desc="next function start"})
vim.keymap.set({"n","x","o"}, "]]",  function() mv.goto_next_start("@class.outer","textobjects")       end, {desc="next class start"})
vim.keymap.set({"n","x","o"}, "]a",  function() mv.goto_next_start("@parameter.inner","textobjects")   end, {desc="next parameter"})
vim.keymap.set({"n","x","o"}, "]M",  function() mv.goto_next_end("@function.outer","textobjects")      end, {desc="next function end"})
vim.keymap.set({"n","x","o"}, "][",  function() mv.goto_next_end("@class.outer","textobjects")         end, {desc="next class end"})
vim.keymap.set({"n","x","o"}, "[m",  function() mv.goto_previous_start("@function.outer","textobjects") end, {desc="prev function start"})
vim.keymap.set({"n","x","o"}, "[[",  function() mv.goto_previous_start("@class.outer","textobjects")   end, {desc="prev class start"})
vim.keymap.set({"n","x","o"}, "[a",  function() mv.goto_previous_start("@parameter.inner","textobjects") end, {desc="prev parameter"})
vim.keymap.set({"n","x","o"}, "[M",  function() mv.goto_previous_end("@function.outer","textobjects")  end, {desc="prev function end"})
vim.keymap.set({"n","x","o"}, "[]",  function() mv.goto_previous_end("@class.outer","textobjects")     end, {desc="prev class end"})

-- Swap adjacent parameters
vim.keymap.set("n", "<leader>sn", function() sw.swap_next("@parameter.inner")     end, {desc="swap next parameter"})
vim.keymap.set("n", "<leader>sp", function() sw.swap_previous("@parameter.inner") end, {desc="swap prev parameter"})
