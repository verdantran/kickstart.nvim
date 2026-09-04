-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })

require('neo-tree').setup {
  filesystem = {
    filtered_items = {
      visible = true,          -- show filtered items (dimmed) rather than hiding them
      hide_dotfiles = false,   -- treat dotfiles as normal, fully-visible items
      hide_gitignored = false, -- optional: also show gitignored files
    },
    follow_current_file = {
      enabled = true,
      leave_dirs_open = false,
    },
    bind_to_cwd = false, -- don't chase the tree root to the current file's project
    use_libuv_file_watcher = true,
    window = {
      mappings = {
        ['\\'] = 'close_window',
      },
    },
  },
}
