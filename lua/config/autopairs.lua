require("nvim-autopairs").setup({
  check_ts = true, -- treesitter-aware: smarter pairing inside code vs strings/comments
})

-- Make nvim-autopairs cooperate with nvim-cmp: after confirming a function
-- completion, insert the matching "()". cmp is listed before autopairs in the
-- plugin spec, so it's already loaded on InsertEnter when this runs (guarded anyway).
local ok, cmp = pcall(require, "cmp")
if ok then
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end
