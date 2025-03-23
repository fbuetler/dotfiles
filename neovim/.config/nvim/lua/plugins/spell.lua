-- https://github.com/f3fora/cmp-spell
return {
  'f3fora/cmp-spell',
  config = function()
    require("cmp").setup({
    sources = {
      {
        name = "spell",
        option = {
          keep_all_entries = false,
          enable_in_context = function()
            return true
          end,
          preselect_correct_word = true,
          },
        },
    },
  })
  end
}
