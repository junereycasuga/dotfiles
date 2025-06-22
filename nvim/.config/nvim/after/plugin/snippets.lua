local ls = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

-- Press <Tab> to expand or jump to the next snippet placeholder
vim.keymap.set({ "i", "s" }, "<Tab>", function()
    if ls.expand_or_jumpable() then
      return "<Plug>luasnip-expand-or-jump"
    else
      return "<Tab>"
    end
  end, { expr = true, silent = true })
  
  -- Press <S-Tab> to jump backward in snippet
  vim.keymap.set("i", "<S-Tab>", function()
    ls.jump(-1)
  end, { silent = true })
  
  vim.keymap.set("s", "<Tab>", function()
    ls.jump(1)
  end, { silent = true })
  
  vim.keymap.set("s", "<S-Tab>", function()
    ls.jump(-1)
  end, { silent = true })
  
  -- For changing choices in choiceNodes
  vim.keymap.set("i", "<C-E>", function()
    if ls.choice_active() then
      return "<Plug>luasnip-next-choice"
    else
      return "<C-E>"
    end
  end, { expr = true, silent = true })
  
  vim.keymap.set("s", "<C-E>", function()
    if ls.choice_active() then
      return "<Plug>luasnip-next-choice"
    else
      return "<C-E>"
    end
  end, { expr = true, silent = true })