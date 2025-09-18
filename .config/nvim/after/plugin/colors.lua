
function ColorMyPencils(color)
	-- color = color or "rose-pine"
	-- color = color or "rose-pine-moon"
	color = color or "rose-pine-moon"
	-- color = color or "tokyonight" or "rose-pine"
	-- color = color
	vim.cmd.colorscheme(color)
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end




ColorMyPencils()

