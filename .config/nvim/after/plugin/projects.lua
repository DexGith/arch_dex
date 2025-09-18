    require("project_nvim").setup {
      -- By default, this is: { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" }
      -- Let's add more patterns for different project types!
      patterns = {
        ".git",
        "Makefile",
        "package.json",
        "requirements.txt", -- Python
        "Cargo.toml",       -- Rust
        "go.mod",           -- Go
        "pom.xml",          -- Maven/Java
      },
      exclude_dirs = {
          "~/Downloads/*",
          "~/.cache/*",
          "~/.local/share/*",
      },
  -- Show hidden files in telescope
  show_hidden = true,
    }


--# Get a list of recent projects:
-- local project_nvim = require("project_nvim")
-- local recent_projects = project_nvim.get_recent_projects()
--
-- print(vim.inspect(recent_projects))
