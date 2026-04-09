local status_ok , ibl = pcall(require, "ibl")
if not status_ok then return end


ibl.setup({
		scope = {
		char = "|",
		enabled = true,
		show_start = true,
		show_end   = false,
		highlight = "Function",
	},
})
