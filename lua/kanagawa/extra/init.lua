local M = {}

---map of plugin name to it's extension
M.extras = {
  wezterm = { ext = "lua", url = "https://wezfurlong.org/wezterm/config/appearance.html" },
}

local function write(str, fileName)
  print("[write] extra/" .. fileName)
  vim.fn.mkdir(vim.fs.dirname("extras/" .. fileName), "p")
  local file = io.open("extras/" .. fileName, "w")
  file:write(str)
  file:close()
end

function M.read_file(file)
  local fd = assert(io.open(file, "r"))
  ---@type string
  local data = fd:read "*a"
  fd:close()
  return data
end

function M.write_file(file, contents)
  local fd = assert(io.open(file, "w+"))
  fd:write(contents)
  fd:close()
end

function M.setup()
  local kanagawa = require "kanagawa"

  local variants = { "wave", "dragon", "lotus" }

  for extra, info in pairs(M.extras) do
    package.loaded["kanagawa.extra." .. extra] = nil
    local plugin = require("kanagawa.extra." .. extra)

    for style, _ in pairs(variants) do
      local colors
      kanagawa.setup { theme = style }
      kanagawa.load(style)
      vim.cmd.colorscheme("kanagawa-" .. style)

      local fname = extra .. "/kanagawa-" .. style .. "." .. info.ext
      colors["_upstream_url"] = "https://www.github.com/rebelot/kanagawa.nvim/raw/main/extra"
        .. extra
      colors["_style_name"] = "Kanagawa" .. style
      colors["_name"] = "kanagawa-" .. style
      write(plugin.generate(colors), fname)
    end
  end
end

return M

