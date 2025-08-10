local function git_repo_name()
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result and result:gsub("\n", ""):match("([^/]+)$") or "[No Git]"
  end
  return "[No Git]"
end

return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Ensure sections table exists
    opts.sections = opts.sections or {}

    -- Modify lualine_b directly
    if opts.sections["lualine_b"] then
      opts.sections["lualine_b"] = { git_repo_name, "branch" } -- Show Git repo name here
    end
  end,
}
