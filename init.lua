profile_directories = {
    '/run/current-system/profile',
    vim.env.HOME .. '/.guix-profile',
    vim.env.HOME .. '/.guix-home/profile',
    vim.env.GUIX_PROFILE,
    vim.env.GUIX_ENVIRONMENT,
}

for _, directory in pairs(profile_directories) do
    vimplugins = directory .. '/share/vim/vimfiles'
    if vim.fn.isdirectory(vimplugins) ~= 0 then
        vim.opt.rtp:append(vimplugins)
    end
end

after_directories = {
    vim.env.VIM .. '/vimfiles',
    vim.env.HOME .. '/.vim',
}

for _, directory in pairs(after_directories) do
    vimplugins = directory .. '/after'
    if vim.fn.isdirectory(vimplugins) ~= 0 then
        vim.opt.rtp:append(vimplugins)
    end
end

vim.o.expandtab  = true
vim.o.tabstop    = 4
vim.o.shiftwidth = 4
vim.o.number     = true

local packer = require('packer')

packer.init({
	display = {
		open_fn = function()
			return require('packer.util').float({ border = 'rounded' })
		end,
	},
})

packer.startup(function(use)
    use('nvim-treesitter/nvim-treesitter')
end)

require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
    }
}
