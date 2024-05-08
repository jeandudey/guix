vim.o.expandtab  = true
vim.o.tabstop    = 4
vim.o.shiftwidth = 4
vim.o.number     = true

vim.api.nvim_create_autocmd('BufEnter', {
    pattern  = '*.slint',
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_option(buf, 'filetype', 'slint')
    end,
})

local packer = require('packer')

packer.init({
    display = {
        open_fn = function()
            return require('packer.util').float({ border = 'rounded' })
        end,
    },
})

packer.startup(function(use)
    use('neovim/nvim-lspconfig')
    use('preservim/nerdtree')
    use('Mofiqul/dracula.nvim')
    use('hrsh7th/cmp-nvim-lsp')
    use('hrsh7th/cmp-buffer')
    use('hrsh7th/cmp-path')
    use('hrsh7th/nvim-cmp')
    use('HiPhish/info.vim')
end)

-- require('nvim-treesitter.configs').setup {
--     highlight = {
--         enable = true,
--     }
-- }

local lspconfig = require('lspconfig')

lspconfig.clangd.setup {}
lspconfig.rust_analyzer.setup {}
lspconfig.slint_lsp.setup {}

vim.cmd[[colorscheme dracula]]
vim.cmd[[set background=dark]]

local cmp = require('cmp')

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<C-space>'] = cmp.mapping.complete(),
        ['<C-j>']     = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-k>']     = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<CR>']      = cmp.mapping.confirm({ select = false }),
    }),
    sources = cmp.config.sources(
        {{ name = 'nvim_lsp' }},
        {{ name = 'buffer' }}
    ),
    window = {
        completion    = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})
