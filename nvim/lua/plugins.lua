vim.cmd [[packadd packer.nvim]]


local use = require('packer').use

require('packer').startup(function()
    use 'wbthomason/packer.nvim' -- packer
    use { 'neoclide/coc.nvim', branch = 'release' } -- use coc as lsp server. 
    -- It seems that nvim-lspconfig have a very unpleasant
    -- bug, it suddenly stop
    use { 'nvim-treesitter/nvim-treesitter', run= ':TSUpdate' } -- treesitter for highligthing
    use 'L3MON4D3/LuaSnip' -- install snippet engine
    use 'nvim-lualine/lualine.nvim'
    use 'nvim-tree/nvim-tree.lua' -- file tree
    use 'preservim/nerdcommenter' -- better coments experince
    use 'lukas-reineke/indent-blankline.nvim' -- show indentation
    use 'windwp/nvim-autopairs' -- autopairs brackets
    use  { 'nvim-telescope/telescope.nvim', tag = '0.1.0', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } } -- fast fuzzy finder

    use 'fannheyward/telescope-coc.nvim' -- telescope + coc better experince

-- install without yarn or npm
use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
})

end)

-- disable netrw for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- tresitter config
require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "cpp" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

 highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    -- disable = function(lang, buf)
    --    local max_filesize = 100 * 1024 -- 100 KB
    --    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --    if ok and stats and stats.size > max_filesize then
    --        return true
    --    end
    -- end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

-- lua line config
require ('lualine').setup {
    options = { 
        icons_enabled = true,
        theme = 'Tomorrow' 
    }
}

require ('nvim-tree').setup{}

require ('indent_blankline').setup {
    show_current_context = true,
    show_current_context_start = true
}

-- autopairs
require ('nvim-autopairs').setup {
    check_ts = true
}

require ('telescope').setup ({
    extensions = {
        coc  = {
            prefer_locations = true
        }
    }
})

require ('telescope').load_extension('coc')
