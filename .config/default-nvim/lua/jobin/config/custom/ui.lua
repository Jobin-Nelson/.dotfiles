local M = {}

local function bool2str(bool) return bool and "on" or "off" end

function M.set_indent()
  vim.ui.input({
    prompt = "Set indent value (>0 expandtab, <=0 noexpandtab): ",
  }, function(new_indent)
    new_indent = tonumber(new_indent)
    if new_indent == nil or new_indent == 0 then
      return
    end

    vim.bo.expandtab = (new_indent > 0)
    new_indent = math.abs(new_indent)
    vim.bo.tabstop = new_indent
    vim.bo.softtabstop = new_indent
    vim.bo.shiftwidth = new_indent
    print("Indent set to " .. new_indent)
  end)
end

function M.toggle_spell()
  vim.wo.spell = not vim.wo.spell
  print("Spell set to " .. bool2str(vim.wo.spell))
end

return M
