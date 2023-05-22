local M = {}

local function mason_python_path()
  local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
  if mason_path ~= "" and (vim.fn.has("macunix") == 1 or vim.fn.has("unix") == 1) then
    return mason_path .. "packages/debugpy/venv/bin/python"
  elseif mason_path ~= "" and (vim.fn.has("win32") == 1) then
    return mason_path .. "packages\\debugpy\\venv\\Scripts\\python.exe"
  else
    return nil
  end
end

local function venv_python_path()
  local venv_path = vim.fn.glob(require("lazyvim.util").get_root() .. "/venv/")
  if venv_path ~= "" and (vim.fn.has("macunix") == 1 or vim.fn.has("unix") == 1) then
    return venv_path .. "bin/python"
  elseif venv_path ~= "" and (vim.fn.has("win32") == 1) then
    return venv_path .. "Scripts\\python.exe"
  else
    return nil
  end
end

M.mason_python_path = mason_python_path()
M.venv_python_path = venv_python_path()
return M
